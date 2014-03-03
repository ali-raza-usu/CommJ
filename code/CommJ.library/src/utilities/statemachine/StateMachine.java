package utilities.statemachine;

import java.lang.reflect.Constructor;
import java.lang.reflect.Type;
import java.nio.MappedByteBuffer;
import java.util.Comparator;
import java.util.HashMap;
import java.util.UUID;
import java.util.concurrent.*;
import org.apache.commons.lang3.exception.ExceptionUtils;
import org.apache.log4j.Logger;

import universe.Conversation;
import universe.MessageType;
import universe.ProtocolRole;
import universe.Protocol;
import universe.Role;

public  abstract class StateMachine implements IStateMachine{

	private static Logger logger = Logger.getLogger(StateMachine.class);	
	private String initialState = null;
	private String finalState = null;
	private HashMap<String , State> states  = new HashMap<String, State>();
	private HashMap<UUID, Transition> transitions = new HashMap<UUID, Transition>();
	private static ProtocolRole protocolRole = null;
	private static ConcurrentHashMap<Conversation, StateMachine> conversationsInProgress = new ConcurrentHashMap<Conversation, StateMachine>();
	private static HashMap<ProtocolRole, Type> stateMachineTypes;
	private static String protocolName = "";
	public static ProtocolRole getProtocolRole() {
		return protocolRole;
	}
	
	public static ConcurrentHashMap<Conversation, StateMachine> getConversationsInProgress() {
		return conversationsInProgress;
	}
	
	public static void setConversationsInProgress(
			ConcurrentHashMap<Conversation, StateMachine> conversationsInProgress) {
		StateMachine.conversationsInProgress = conversationsInProgress;
	}

	public static  StateMachine findConverstion(Conversation _conversation){
		for(Conversation conversation :  StateMachine.getConversationsInProgress().keySet()){
			if(conversation.getId().equals(_conversation.getId())){
				return StateMachine.getConversationsInProgress().get(conversation);
			}
		}
		return null;			
	}
	
	public static  boolean deleteStateMachine(Conversation _conversation){
		boolean isdeleted = false;
		if(_conversation != null){
			for(Conversation conversation :  StateMachine.getConversationsInProgress().keySet()){
				if(conversation.getId().equals(_conversation.getId())){
					StateMachine.getConversationsInProgress().remove(conversation);
					isdeleted = true;
				}
			}
		}
		return isdeleted;			
	}
	
	
	public static  Conversation getConversationInProgress(Conversation _conversation){
		for(Conversation conversation :  StateMachine.getConversationsInProgress().keySet()){
			if(conversation.equals(_conversation))
				return conversation;
		}
		return null;			
	}
	
	public static void register(Type _type, Protocol _protocol, Role _role){	
		protocolName = _protocol.getName();
		protocolRole = new ProtocolRole(_protocol, _role);
		if (stateMachineTypes==null)
			stateMachineTypes = new HashMap<ProtocolRole, Type>();
		
		if(!stateMachineTypes.containsKey(_type)){
			stateMachineTypes.put(protocolRole, _type);
		}
	}
	
	public StateMachine(Conversation _conversation){
		 
		initialize();
		StateMachine.getConversationsInProgress().put(_conversation,  this);
	}
	
	public StateMachine(){
		initialize();
	}
	
	
	public HashMap<String, State> getStates() {
		return states;
	}

	public void setStates(HashMap<String, State> _states) {
		this.states = _states;
	}

	public HashMap<UUID, Transition> getTransitions() {
		return transitions;
	}

	public void setTransitions(HashMap<UUID, Transition> _transitions) {
		this.transitions = _transitions;
	}

	public void setInitialState(String _initialState) {
		this.initialState = _initialState;
	}
	
	public State getIntialState(){
		 
		 
		return  states.get(initialState);
	}

	public void setFinalState(String _finalState) {
		this.finalState = _finalState;
	}
	
	public State getFinalState(){
		return states.get(finalState);
	}
	
	public State makeTransition(Conversation _conversation, char _action, MessageType _type){
			 
			 
			 
			 
			State curState = _conversation.getCurrentState().makeTransition(_action, _type);
			if (curState == null){
				curState = _conversation.getCurrentState();
				 
			}
			 
				 
		return curState;
	}
	
	public State findByState(String _name){
		return getStates().get(_name);
	}
	
	
	private boolean isInitial(String _name){
		if(_name!= null && _name.equals("Initial"))
			return true;
		else
			return false;
	}
	
	public State addState(String _name){
		State state = findByState(_name);
		if(state == null){			
			state = new State(false, isInitial(_name),_name);
			if(state.isInitial()){
				initialState = state.getName();
			}
			states.put(_name, state);
		}
		return state;
	}
	
	public void addTransition(String _from, char _actionType, String _messageType, String _to) {		
		State fromState = addState(_from);
		State toState = addState(_to);
		 
		Transition transition = new Transition(_actionType, new MessageType(_messageType), fromState, toState, UUID.randomUUID());
		 
		getTransitions().put(transition.getIndex(),transition);
		 
		getStates().get(_from).getTransitions().add(transition);
		 
	}


	public void initialize(){	
		buildTransitions();		
		for(State state : states.values()){			
			 
			if(state.getTransitions()!= null && state.getTransitions().size() == 0){				
				state.setFinal(true);
			}			
		}
	}
	
	
	public static Type getType(ProtocolRole _partRole){
		 
		if(stateMachineTypes!=null)
			for(ProtocolRole _pRole : stateMachineTypes.keySet()){					
				if(_pRole.equals(_partRole)){
					return stateMachineTypes.get(_pRole);
				}
			}
		return null;		
	}

	
	public static Type getType(String _role){	
		for(ProtocolRole _pRole : stateMachineTypes.keySet()){			
			if(_pRole.getRole().getName().equals(_role)){
				return stateMachineTypes.get(_pRole);
			}
		}
		return null;		
	}
	

	public static StateMachine createStateMachine(ProtocolRole _protocolRole, Conversation _conversation) {
		logger.debug("In Creat State Machine method");
		logger.debug("In Creat State Machine method with Protocol "+ _protocolRole.getProtocol());
		logger.debug("In Creat State Machine method with Protocol.Name "+ _protocolRole.getProtocol().getName());
		logger.debug("role " + _protocolRole.getRole().getName());
		logger.debug("conversation "+ _conversation);
		Type stateMachineType = getType(_protocolRole);
		logger.debug("creating state machine for type "+ stateMachineType);
		 try {
			 Class<?> tempClass =  Class.forName(( (Class<?>)stateMachineType).getName());
			 Constructor<?> constructor = tempClass.getConstructor(Conversation.class); 
			return (StateMachine)constructor.newInstance(_conversation);
		}catch (Exception e){		
			 
			return null;
		} 
	}
}
