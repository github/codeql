// Generated automatically from okio.Timeout for testing purposes

package okio;

import java.util.concurrent.TimeUnit;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;

public class Timeout
{
    public Timeout clearDeadline(){ return null; }
    public Timeout clearTimeout(){ return null; }
    public Timeout deadlineNanoTime(long p0){ return null; }
    public Timeout timeout(long p0, TimeUnit p1){ return null; }
    public Timeout(){}
    public boolean hasDeadline(){ return false; }
    public final Timeout deadline(long p0, TimeUnit p1){ return null; }
    public final void intersectWith(Timeout p0, Function0<Unit> p1){}
    public final void waitUntilNotified(Object p0){}
    public long deadlineNanoTime(){ return 0; }
    public long timeoutNanos(){ return 0; }
    public static Timeout NONE = null;
    public static Timeout.Companion Companion = null;
    public void throwIfReached(){}
    static public class Companion
    {
        protected Companion() {}
        public final long minTimeout(long p0, long p1){ return 0; }
    }
}
