// Generated automatically from org.apache.commons.collections4.queue.UnmodifiableQueue for testing purposes

package org.apache.commons.collections4.queue;

import java.util.Collection;
import java.util.Iterator;
import java.util.Queue;
import java.util.function.Predicate;
import org.apache.commons.collections4.Unmodifiable;
import org.apache.commons.collections4.queue.AbstractQueueDecorator;

public class UnmodifiableQueue<E> extends AbstractQueueDecorator<E> implements Unmodifiable
{
    protected UnmodifiableQueue() {}
    public E poll(){ return null; }
    public E remove(){ return null; }
    public Iterator<E> iterator(){ return null; }
    public boolean add(Object p0){ return false; }
    public boolean addAll(Collection<? extends E> p0){ return false; }
    public boolean offer(E p0){ return false; }
    public boolean remove(Object p0){ return false; }
    public boolean removeAll(Collection<? extends Object> p0){ return false; }
    public boolean removeIf(Predicate<? super E> p0){ return false; }
    public boolean retainAll(Collection<? extends Object> p0){ return false; }
    public static <E> Queue<E> unmodifiableQueue(Queue<? extends E> p0){ return null; }
    public void clear(){}
}
