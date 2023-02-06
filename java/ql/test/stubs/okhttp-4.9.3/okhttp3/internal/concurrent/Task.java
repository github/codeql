// Generated automatically from okhttp3.internal.concurrent.Task for testing purposes

package okhttp3.internal.concurrent;

import okhttp3.internal.concurrent.TaskQueue;

abstract public class Task
{
    protected Task() {}
    public String toString(){ return null; }
    public Task(String p0, boolean p1){}
    public abstract long runOnce();
    public final String getName(){ return null; }
    public final TaskQueue getQueue$okhttp(){ return null; }
    public final boolean getCancelable(){ return false; }
    public final long getNextExecuteNanoTime$okhttp(){ return 0; }
    public final void initQueue$okhttp(TaskQueue p0){}
    public final void setNextExecuteNanoTime$okhttp(long p0){}
    public final void setQueue$okhttp(TaskQueue p0){}
}
