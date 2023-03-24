// Generated automatically from okhttp3.Dispatcher for testing purposes

package okhttp3;

import java.util.List;
import java.util.concurrent.ExecutorService;
import okhttp3.Call;
import okhttp3.internal.connection.RealCall;

public class Dispatcher
{
    public Dispatcher(){}
    public Dispatcher(ExecutorService p0){}
    public final ExecutorService executorService(){ return null; }
    public final List<Call> queuedCalls(){ return null; }
    public final List<Call> runningCalls(){ return null; }
    public final Runnable getIdleCallback(){ return null; }
    public final int getMaxRequests(){ return 0; }
    public final int getMaxRequestsPerHost(){ return 0; }
    public final int queuedCallsCount(){ return 0; }
    public final int runningCallsCount(){ return 0; }
    public final void cancelAll(){}
    public final void enqueue$okhttp(RealCall.AsyncCall p0){}
    public final void executed$okhttp(RealCall p0){}
    public final void finished$okhttp(RealCall p0){}
    public final void finished$okhttp(RealCall.AsyncCall p0){}
    public final void setIdleCallback(Runnable p0){}
    public final void setMaxRequests(int p0){}
    public final void setMaxRequestsPerHost(int p0){}
}
