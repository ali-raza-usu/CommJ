package communication;

import joinpoints.communication.MultistepConversationJP;
import baseaspects.communication.MultistepConversationAspect;

public abstract aspect TotalTurnAroundTimeMonitor extends MultistepConversationAspect{
	private long startTime = 0;
	private long turnAroundTime = 0;
	
	before(MultistepConversationJP jp): ConversationBegin(jp){
	     startTime = System.currentTimeMillis();
	     Begin(jp);
	}
	after(MultistepConversationJP jp): ConversationEnd(jp){
	     long turnaroundTime = (System.currentTimeMillis() - startTime)/1000;
	End(jp);
	}

	public long getTurnAroundTime() {
	     return turnAroundTime;
	}
	
	public void Begin(MultistepConversationJP jp){
	 
	}
	
	public void End(MultistepConversationJP jp){
	 
	}
}
