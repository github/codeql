// Generated automatically from org.apache.commons.collections4.queue.SynchronizedQueue for testing purposes

package org.apache.commons.collections4.queue;

import java.util.Queue;
import org.apache.commons.collections4.collection.SynchronizedCollection;

public class SynchronizedQueue<E> extends SynchronizedCollection<E> implements Queue<E>
{
    protected SynchronizedQueue() {}
    protected Queue<E> decorated(){ return null; }
    protected SynchronizedQueue(Queue<E> p0){}
    protected SynchronizedQueue(Queue<E> p0, Object p1){}
    public E element(){ return null; }
    public E peek(){ return null; }
    public E poll(){ return null; }
    public E remove(){ return null; }
    public boolean equals(Object p0){ return false; }
    public boolean offer(E p0){ return false; }
    public int hashCode(){ return 0; }
    public static <E> SynchronizedQueue<E> synchronizedQueue(Queue<E> p0){ return null; }
}
