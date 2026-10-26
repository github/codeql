// Generated automatically from org.apache.commons.collections4.queue.TransformedQueue for testing purposes

package org.apache.commons.collections4.queue;

import java.util.Queue;
import org.apache.commons.collections4.Transformer;
import org.apache.commons.collections4.collection.TransformedCollection;

public class TransformedQueue<E> extends TransformedCollection<E> implements Queue<E>
{
    protected TransformedQueue() {}
    protected Queue<E> getQueue(){ return null; }
    protected TransformedQueue(Queue<E> p0, Transformer<? super E, ? extends E> p1){}
    public E element(){ return null; }
    public E peek(){ return null; }
    public E poll(){ return null; }
    public E remove(){ return null; }
    public boolean offer(E p0){ return false; }
    public static <E> TransformedQueue<E> transformedQueue(Queue<E> p0, Transformer<? super E, ? extends E> p1){ return null; }
    public static <E> TransformedQueue<E> transformingQueue(Queue<E> p0, Transformer<? super E, ? extends E> p1){ return null; }
}
