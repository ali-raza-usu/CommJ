package communication;
import java.util.*;

import baseaspects.communication.MultistepConversationAspect;

import joinpoints.communication.MultistepConversationJP;


public aspect MyAppPerformanceMonitor extends TotalTurnAroundTimeMonitor{

        public MyAppPerformanceMonitor() {
		super();
		 
	}

		private ArrayList<Stats> statsList = new ArrayList(11);
        private int currentStatsIndex = 0;
        
        @Override
		public void End(MultistepConversationJP jp)
        {
                 
                long elapsedMinutes = Math.min(statsList.get(currentStatsIndex).getMinutesSinceStartTime(), 10);

                 
                for (int i=0; i<elapsedMinutes; i++)
                {
                        currentStatsIndex++;
                        if (currentStatsIndex>10)
                                currentStatsIndex=0;
                        statsList.get(currentStatsIndex).Reset();
                         
                        statsList.get(currentStatsIndex).addCompleteConversation(getTurnAroundTime());
                        
                }

                 
                 
        }
}

class Stats{
        private long startTime;
        private int completeConvCount;
        private double avgTurnaroundTime;

        public Stats() {
                Reset();
        }

        public void Reset() {
                startTime = System.currentTimeMillis();
                completeConvCount = 0;
                avgTurnaroundTime = 0;
        }
        public long getMinutesSinceStartTime() {
                 
                 
        	return 0;
        }

        public void addCompleteConversation(double newTurnaroundTime){
                avgTurnaroundTime = ((completeConvCount*avgTurnaroundTime) + newTurnaroundTime)/(++completeConvCount);
        }

        public int getCompleteConvCount(){
                return completeConvCount;
        }

        public double getAvgTurnaroundTime(){
                return avgTurnaroundTime;
        }
}
