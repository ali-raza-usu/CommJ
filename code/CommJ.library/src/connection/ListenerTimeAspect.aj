package connection;
import joinpoints.connection.ChannelJP;
import org.apache.log4j.Logger;
import baseaspects.connection.CompleteConnectionAspect;


public aspect ListenerTimeAspect extends CompleteConnectionAspect{
	Logger logger = Logger.getLogger(ListenerTimeAspect.class);
	
	private	long startTime = 0;	
	static String timingInfo = "";
	
	Object around(ChannelJP _channelJp): ConversationBeginOnListener(_channelJp)
	{					
     	 
       	return proceed(_channelJp);
	}
	
	Object around(ChannelJP _channelJp): ConversationEndOnListener(_channelJp)
	{	
		 
		 
		 
		return proceed(_channelJp);
	}
}
