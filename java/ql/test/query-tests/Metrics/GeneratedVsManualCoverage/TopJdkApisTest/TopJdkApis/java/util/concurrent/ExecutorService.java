// Generated automatically from java.util.concurrent.ExecutorService for testing purposes

package java.util.concurrent;

import java.util.Collection;
import java.util.List;
import java.util.concurrent.Callable;
import java.util.concurrent.Executor;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;

public interface ExecutorService extends Executor
{
    Future<? extends Object> submit(Runnable p0); // manual summary
    void shutdown(); // manual neutral
}
