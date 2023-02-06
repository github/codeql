// Generated automatically from okhttp3.internal.concurrent.TaskRunner for testing purposes

package okhttp3.internal.concurrent;

import java.util.List;
import java.util.logging.Logger;
import okhttp3.internal.concurrent.Task;
import okhttp3.internal.concurrent.TaskQueue;

public class TaskRunner
{
    protected TaskRunner() {}
    public TaskRunner(TaskRunner.Backend p0){}
    public final List<TaskQueue> activeQueues(){ return null; }
    public final Task awaitTaskToRun(){ return null; }
    public final TaskQueue newQueue(){ return null; }
    public final TaskRunner.Backend getBackend(){ return null; }
    public final void cancelAll(){}
    public final void kickCoordinator$okhttp(TaskQueue p0){}
    public static TaskRunner INSTANCE = null;
    public static TaskRunner.Companion Companion = null;
    static public class Companion
    {
        protected Companion() {}
        public final Logger getLogger(){ return null; }
    }
    static public interface Backend
    {
        long nanoTime();
        void beforeTask(TaskRunner p0);
        void coordinatorNotify(TaskRunner p0);
        void coordinatorWait(TaskRunner p0, long p1);
        void execute(Runnable p0);
    }
}
