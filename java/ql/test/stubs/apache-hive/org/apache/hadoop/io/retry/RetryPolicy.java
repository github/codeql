// Generated automatically from org.apache.hadoop.io.retry.RetryPolicy for testing purposes

package org.apache.hadoop.io.retry;


public interface RetryPolicy
{
    RetryPolicy.RetryAction shouldRetry(Exception p0, int p1, int p2, boolean p3);
    static public class RetryAction
    {
        protected RetryAction() {}
        public RetryAction(RetryPolicy.RetryAction.RetryDecision p0){}
        public RetryAction(RetryPolicy.RetryAction.RetryDecision p0, long p1){}
        public RetryAction(RetryPolicy.RetryAction.RetryDecision p0, long p1, String p2){}
        public String toString(){ return null; }
        public final RetryPolicy.RetryAction.RetryDecision action = null;
        public final String reason = null;
        public final long delayMillis = 0;
        public static RetryPolicy.RetryAction FAIL = null;
        public static RetryPolicy.RetryAction FAILOVER_AND_RETRY = null;
        public static RetryPolicy.RetryAction RETRY = null;
        static public enum RetryDecision
        {
            FAIL, FAILOVER_AND_RETRY, RETRY;
            private RetryDecision() {}
        }
    }
}
