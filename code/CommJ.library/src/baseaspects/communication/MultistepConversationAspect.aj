package baseaspects.communication;

import java.util.UUID;

import joinpoints.communication.CommunicationEventJP;
import joinpoints.communication.MultistepConversationJP;
import joinpoints.communication.ReceiveEventJP;
import joinpoints.communication.SendEventJP;
import org.apache.log4j.Logger;
import baseaspects.communication.MessageAspect;
import universe.Conversation;
import utilities.Encoder;
import utilities.Session;
import utilities.statemachine.StateMachine;


public  abstract aspect MultistepConversationAspect extends MessageAspect{

	
	public pointcut ConversationBegin(MultistepConversationJP _multiStepJp) : execution(* MultistepConversationAspect.Begin(MultistepConversationJP)) && args(_multiStepJp);	
	public pointcut ConversationEnd(MultistepConversationJP _multiStepJp) : execution(* MultistepConversationAspect.End(..)) && args(_multiStepJp);	
	private Logger logger = Logger.getLogger(MultistepConversationAspect.class);
	private Conversation currentConversation = null;

	void around(SendEventJP _sendJp) : MessageSend(_sendJp){	
		 
		 
		makeStateTransiton(_sendJp, 'S');
		 
		proceed(_sendJp);		
	}
	

	void around(ReceiveEventJP _receiveJp) : MessageRecieve(_receiveJp){
		 
		 
		makeStateTransiton(_receiveJp, 'R');
		 
		proceed(_receiveJp);		
	}

	
	public void Begin(MultistepConversationJP _multiStepJp){
	}

	public void End(MultistepConversationJP _multiStepJp){	
		 
	}
	
	private void makeStateTransiton(CommunicationEventJP _commJp, char _actionType){
		 
		if(_commJp.getProtocol() == null)
			return;
		
		if (_commJp!= null && _commJp.getConversation() == null){
			if(currentConversation == null)
				currentConversation =  new Conversation();
			_commJp.setConversation(currentConversation);
		}else{
			currentConversation = _commJp.getConversation();
		}
		
		MultistepConversationJP multiStepJp = (MultistepConversationJP)Session.getInstance().getUniverse().findByConversation(_commJp.getConversation().getId());
		 
		if(multiStepJp == null){
			multiStepJp = new MultistepConversationJP(_commJp);
		 
		 
		 
		 
			Session.getInstance().getUniverse().getConversationJoinPointList().add(multiStepJp);
		 
			
		} else{
			multiStepJp.setMessageType(_commJp.getMessageType());
			 
		}	
		multiStepJp.setBytes(_commJp.getBytes());
		 
		StateMachine stateMachine = StateMachine.findConverstion(multiStepJp.getConversation());
		 
		if (stateMachine == null){			
			 
			stateMachine =  StateMachine.createStateMachine(multiStepJp.getProtocolRole(), multiStepJp.getConversation());
			 
			 
			if(stateMachine !=null)
				multiStepJp.getConversation().setCurrentState(stateMachine.getIntialState());
		}
		
		if(stateMachine !=null){

			if(multiStepJp.getConversation().isInInitialState())
				Begin(multiStepJp);
			
			logger.debug(_actionType+" : before transition current state is " + multiStepJp.getConversation().getCurrentState().getName());	
			if(!multiStepJp.getConversation().getCurrentState().isFinal())
				multiStepJp.getConversation().setCurrentState(stateMachine.makeTransition(multiStepJp.getConversation(), _actionType,multiStepJp.getMessageType()) );
			logger.debug(_actionType+" : after transition current state is " + multiStepJp.getConversation().getCurrentState().getName());
			logger.debug(_actionType+" : is final state  " + multiStepJp.getConversation().getCurrentState().isFinal());
			logger.debug(" : current message is " + Encoder.decode(multiStepJp.getBytes()).getClass());
			multiStepJp.setConversation(StateMachine.getConversationInProgress(multiStepJp.getConversation()));		

			if(multiStepJp.getConversation().isInFinalState()){
				End(multiStepJp);
				currentConversation = null;
				StateMachine.deleteStateMachine(currentConversation);
			}
		}
	}
}


