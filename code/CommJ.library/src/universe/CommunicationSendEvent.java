package universe;

import java.beans.PropertyChangeEvent;
import java.util.Timer;
import java.util.TimerTask;
import java.util.UUID;

public class CommunicationSendEvent extends CommunicationEvent{

	private Timer timer;
	 
	 
	
	public CommunicationSendEvent(Conversation con)
	{
		super.setConversation(con);
		long expiryTime = getLocalTime().getDeltaTime();
		super.setId(getConversation().getEventId());
		 
		setTimer(new Timer());
		timer.schedule(new Task(), expiryTime);
	}

	public Timer getTimer() {
		return timer;
	}

	public void setTimer(Timer timer) {
		this.timer = timer;
	}
	
	
	
	public class Task extends TimerTask {
		public void run(){		
			getMessage().isMessageLost();			
		}
	}
	

 
 
 
 
 

	
}
