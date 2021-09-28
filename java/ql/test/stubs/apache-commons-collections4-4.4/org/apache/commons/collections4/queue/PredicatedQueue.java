// Generated automatically from org.apache.commons.collections4.queue.PredicatedQueue for testing purposes

package org.apache.commons.collections4.queue;

import java.util.Queue;
import org.apache.commons.collections4.Predicate;
import org.apache.commons.collections4.collection.PredicatedCollection;

public class PredicatedQueue<E> extends PredicatedCollection<E> implements Queue<E>
{
    protected PredicatedQueue() {}
    protected PredicatedQueue(Queue<E> p0, Predicate<? super E> p1){}
    protected Queue<E> decorated(){ return null; }
    public E element(){ return null; }
    public E peek(){ return null; }
    public E poll(){ return null; }
    public E remove(){ return null; }
    public boolean offer(E p0){ return false; }
    public static <E> PredicatedQueue<E> predicatedQueue(Queue<E> p0, Predicate<? super E> p1){ return null; }
}
