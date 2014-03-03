package connection;
import joinpoints.connection.ChannelJP;
import org.apache.log4j.Logger;
import baseaspects.connection.CompleteConnectionAspect;

public aspect InitiatorTimeAspect extends CompleteConnectionAspect{
	Logger logger = Logger.getLogger(InitiatorTimeAspect.class);
	
	private	long startTime = 0;	
	static String timingInfo = "";
	
	before(ChannelJP _channelJp): ConversationBeginOnInitiator(_channelJp){							
     	 
	}
	
	after(ChannelJP _channelJp): ConversationEndOnInitiator(_channelJp){	
		 
		 
			 
		 
	}
}

