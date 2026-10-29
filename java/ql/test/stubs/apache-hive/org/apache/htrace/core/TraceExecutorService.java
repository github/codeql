// Generated automatically from org.apache.htrace.core.TraceExecutorService for testing purposes

package org.apache.htrace.core;

import java.util.Collection;
import java.util.List;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Future;
import java.util.concurrent.TimeUnit;

public class TraceExecutorService implements ExecutorService
{
    protected TraceExecutorService() {}
    public <T> T invokeAny(java.util.Collection<? extends java.util.concurrent.Callable<T>> p0){ return null; }
    public <T> T invokeAny(java.util.Collection<? extends java.util.concurrent.Callable<T>> p0, long p1, TimeUnit p2){ return null; }
    public <T> java.util.List<java.util.concurrent.Future<T>> invokeAll(java.util.Collection<? extends java.util.concurrent.Callable<T>> p0){ return null; }
    public <T> java.util.List<java.util.concurrent.Future<T>> invokeAll(java.util.Collection<? extends java.util.concurrent.Callable<T>> p0, long p1, TimeUnit p2){ return null; }
    public <T> java.util.concurrent.Future<T> submit(Runnable p0, T p1){ return null; }
    public <T> java.util.concurrent.Future<T> submit(java.util.concurrent.Callable<T> p0){ return null; }
    public Future<? extends Object> submit(Runnable p0){ return null; }
    public List<Runnable> shutdownNow(){ return null; }
    public boolean awaitTermination(long p0, TimeUnit p1){ return false; }
    public boolean isShutdown(){ return false; }
    public boolean isTerminated(){ return false; }
    public void execute(Runnable p0){}
    public void shutdown(){}
}
