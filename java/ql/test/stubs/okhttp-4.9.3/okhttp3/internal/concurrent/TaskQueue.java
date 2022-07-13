// Generated automatically from okhttp3.internal.concurrent.TaskQueue for testing purposes

package okhttp3.internal.concurrent;

import java.util.List;
import java.util.concurrent.CountDownLatch;
import kotlin.Unit;
import kotlin.jvm.functions.Function0;
import okhttp3.internal.concurrent.Task;
import okhttp3.internal.concurrent.TaskRunner;

public class TaskQueue
{
    protected TaskQueue() {}
    public String toString(){ return null; }
    public TaskQueue(TaskRunner p0, String p1){}
    public final CountDownLatch idleLatch(){ return null; }
    public final List<Task> getFutureTasks$okhttp(){ return null; }
    public final List<Task> getScheduledTasks(){ return null; }
    public final String getName$okhttp(){ return null; }
    public final Task getActiveTask$okhttp(){ return null; }
    public final TaskRunner getTaskRunner$okhttp(){ return null; }
    public final boolean cancelAllAndDecide$okhttp(){ return false; }
    public final boolean getCancelActiveTask$okhttp(){ return false; }
    public final boolean getShutdown$okhttp(){ return false; }
    public final boolean scheduleAndDecide$okhttp(Task p0, long p1, boolean p2){ return false; }
    public final void cancelAll(){}
    public final void execute(String p0, long p1, boolean p2, Function0<Unit> p3){}
    public final void schedule(String p0, long p1, Function0<Long> p2){}
    public final void schedule(Task p0, long p1){}
    public final void setActiveTask$okhttp(Task p0){}
    public final void setCancelActiveTask$okhttp(boolean p0){}
    public final void setShutdown$okhttp(boolean p0){}
    public final void shutdown(){}
}
