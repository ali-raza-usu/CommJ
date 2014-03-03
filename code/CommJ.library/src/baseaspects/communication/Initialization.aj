package baseaspects.communication;
import java.lang.reflect.Method;
import java.util.*;

import org.apache.log4j.Logger;

import universe.*;
import utilities.*;
import joinpointracker.*;



 

public abstract  aspect Initialization {

	private Logger logger = Logger.getLogger(Initialization.class);
  	
	public static Protocol protocol = null;
	public static Role role = null;
		
	private pointcut ConfigureMessage(IMessage _message) : execution(void utilities.IMessage.setMessage(..)) && target(_message);
	public  pointcut ConfigureProtocolRole() :execution(void *.main(..));
	public  pointcut DeserializeMessage(byte[] bytes) :call(IMessage MessageJoinPointTracker.ReadMessage(..)) && args(bytes);
	
	
	public static HashMap<Class<?>, Class<?>> mappings = new HashMap<Class<?>, Class<?>>();
	
	public abstract void defineMappng();
	before():ConfigureProtocolRole()
	{								
		defineMappng();
	 
        Class<?> className = thisJoinPointStaticPart.getSignature().getDeclaringType();
        logger.debug("className "+ className.getName());
        invokeRoleAndProtocol(className);
	}		
	
	after(IMessage _message):ConfigureMessage(_message)
	{	
		logger.debug("Configuring the Message: Role, Protocol, Conversation");
 
 

		_message.setProtocol(protocol);
		_message.setRole(role);
		 
	 
	}
	
	 
	IMessage around(byte[] bytes):DeserializeMessage(bytes)
	{								
		IMessage msg = proceed(bytes);
		if(msg != null){
			msg.setProtocol(protocol);
			msg.setRole(role);
		}
		return msg;
	}
	
	public void invokeRoleAndProtocol(Class<?> _className)
	{		
	 
		Class<?> _stateMachineClass = mappings.get(_className);
		protocol = (Protocol)invoke("getProtocol", _stateMachineClass);
	 
	 
		role = (Role)invoke("getRole", _stateMachineClass);
	 
	 
	}
	
	public void addMapping(Class<?> _classA, Class<?> _classB){
		mappings.put(_classA, _classB);
	}
	

	public Object invoke(String _methodName, Class<?> _class)
	{
		try{
		Method method = _class.getMethod(_methodName, null);			
		return method.invoke(null, null);
		}catch(Exception e){
			return null;
		}		
	}
	
}
