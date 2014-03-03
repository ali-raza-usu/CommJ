package utilities;

import java.net.DatagramPacket;

import org.apache.log4j.Logger;

import patterns.CommunicationPattern;

import universe.*;



public class Session {
	Logger logger = Logger.getLogger(Session.class);

	private static Session instance = null;

	private CommunicationThread comThread;
	private Conversation conversation;
	private CommunicationChannel channel;
	private Protocol protocol;
	protected Message message = new Message();
	private CommunicationJoinPointRegistry comJpReg;
	private ConnectionJoinPointRegistry conJpReg;

	public static Session getInstance()
	{
		if(instance == null)
			instance = new Session();		
		return instance;
	}


	private Session()
	{
		buildUniverse();
	}


	void buildUniverse()
	{
		comJpReg = new CommunicationJoinPointRegistry();
		conJpReg = new ConnectionJoinPointRegistry();
	}


	public void printMessage(){}


 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 



	public Message getMessage() {
		return message;
	}

	public void setMessage(Message _message) {
		this.message = _message;
	}

	public Conversation getConversation() {
		return conversation;
	}


	public CommunicationJoinPointRegistry getUniverse() {
		return comJpReg;
	}


	public void setUniverse(CommunicationJoinPointRegistry _universe) {
		this.comJpReg = _universe;
	}


	public int getRand()
	{
		return (int) (Math.random()*1000000);
	}


	public ConnectionJoinPointRegistry getConUniverse() {
		return conJpReg;
	}


	public void setConUniverse(ConnectionJoinPointRegistry _conUniverse) {
		this.conJpReg = _conUniverse;
	}

}
