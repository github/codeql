// Generated automatically from okio.AsyncTimeout for testing purposes

package okio;

import java.io.IOException;
import kotlin.jvm.functions.Function0;
import okio.Sink;
import okio.Source;
import okio.Timeout;

public class AsyncTimeout extends Timeout
{
    protected IOException newTimeoutException(IOException p0){ return null; }
    protected void timedOut(){}
    public AsyncTimeout(){}
    public final <T> T withTimeout(Function0<? extends T> p0){ return null; }
    public final IOException access$newTimeoutException(IOException p0){ return null; }
    public final Sink sink(Sink p0){ return null; }
    public final Source source(Source p0){ return null; }
    public final boolean exit(){ return false; }
    public final void enter(){}
    public static AsyncTimeout.Companion Companion = null;
    static public class Companion
    {
        protected Companion() {}
        public final AsyncTimeout awaitTimeout$okio(){ return null; }
    }
}
