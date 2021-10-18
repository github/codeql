// Generated automatically from org.apache.commons.collections4.list.AbstractLinkedList for testing purposes

package org.apache.commons.collections4.list;

import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.AbstractList;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import org.apache.commons.collections4.OrderedIterator;

abstract public class AbstractLinkedList<E> implements List<E>
{
    protected AbstractLinkedList(){}
    protected AbstractLinkedList(Collection<? extends E> p0){}
    protected AbstractLinkedList.Node<E> createHeaderNode(){ return null; }
    protected AbstractLinkedList.Node<E> createNode(E p0){ return null; }
    protected AbstractLinkedList.Node<E> getNode(int p0, boolean p1){ return null; }
    protected Iterator<E> createSubListIterator(AbstractLinkedList.LinkedSubList<E> p0){ return null; }
    protected ListIterator<E> createSubListListIterator(AbstractLinkedList.LinkedSubList<E> p0, int p1){ return null; }
    protected boolean isEqualValue(Object p0, Object p1){ return false; }
    protected void addNode(AbstractLinkedList.Node<E> p0, AbstractLinkedList.Node<E> p1){}
    protected void addNodeAfter(AbstractLinkedList.Node<E> p0, E p1){}
    protected void addNodeBefore(AbstractLinkedList.Node<E> p0, E p1){}
    protected void doReadObject(ObjectInputStream p0){}
    protected void doWriteObject(ObjectOutputStream p0){}
    protected void init(){}
    protected void removeAllNodes(){}
    protected void removeNode(AbstractLinkedList.Node<E> p0){}
    protected void updateNode(AbstractLinkedList.Node<E> p0, E p1){}
    public <T> T[] toArray(T[] p0){ return null; }
    public E get(int p0){ return null; }
    public E getFirst(){ return null; }
    public E getLast(){ return null; }
    public E remove(int p0){ return null; }
    public E removeFirst(){ return null; }
    public E removeLast(){ return null; }
    public E set(int p0, E p1){ return null; }
    public Iterator<E> iterator(){ return null; }
    public List<E> subList(int p0, int p1){ return null; }
    public ListIterator<E> listIterator(){ return null; }
    public ListIterator<E> listIterator(int p0){ return null; }
    public Object[] toArray(){ return null; }
    public String toString(){ return null; }
    public boolean add(E p0){ return false; }
    public boolean addAll(Collection<? extends E> p0){ return false; }
    public boolean addAll(int p0, Collection<? extends E> p1){ return false; }
    public boolean addFirst(E p0){ return false; }
    public boolean addLast(E p0){ return false; }
    public boolean contains(Object p0){ return false; }
    public boolean containsAll(Collection<? extends Object> p0){ return false; }
    public boolean equals(Object p0){ return false; }
    public boolean isEmpty(){ return false; }
    public boolean remove(Object p0){ return false; }
    public boolean removeAll(Collection<? extends Object> p0){ return false; }
    public boolean retainAll(Collection<? extends Object> p0){ return false; }
    public int hashCode(){ return 0; }
    public int indexOf(Object p0){ return 0; }
    public int lastIndexOf(Object p0){ return 0; }
    public int size(){ return 0; }
    public void add(int p0, E p1){}
    public void clear(){}
    static class LinkedListIterator<E> implements ListIterator<E>, OrderedIterator<E>
    {
        protected LinkedListIterator() {}
        protected AbstractLinkedList.Node<E> current = null;
        protected AbstractLinkedList.Node<E> getLastNodeReturned(){ return null; }
        protected AbstractLinkedList.Node<E> next = null;
        protected LinkedListIterator(AbstractLinkedList<E> p0, int p1){}
        protected final AbstractLinkedList<E> parent = null;
        protected int expectedModCount = 0;
        protected int nextIndex = 0;
        protected void checkModCount(){}
        public E next(){ return null; }
        public E previous(){ return null; }
        public boolean hasNext(){ return false; }
        public boolean hasPrevious(){ return false; }
        public int nextIndex(){ return 0; }
        public int previousIndex(){ return 0; }
        public void add(E p0){}
        public void remove(){}
        public void set(E p0){}
    }
    static class LinkedSubList<E> extends AbstractList<E>
    {
        protected LinkedSubList() {}
        protected LinkedSubList(AbstractLinkedList<E> p0, int p1, int p2){}
        protected void checkModCount(){}
        protected void rangeCheck(int p0, int p1){}
        public E get(int p0){ return null; }
        public E remove(int p0){ return null; }
        public E set(int p0, E p1){ return null; }
        public Iterator<E> iterator(){ return null; }
        public List<E> subList(int p0, int p1){ return null; }
        public ListIterator<E> listIterator(int p0){ return null; }
        public boolean addAll(Collection<? extends E> p0){ return false; }
        public boolean addAll(int p0, Collection<? extends E> p1){ return false; }
        public int size(){ return 0; }
        public void add(int p0, E p1){}
        public void clear(){}
    }
    static class Node<E>
    {
        protected AbstractLinkedList.Node<E> getNextNode(){ return null; }
        protected AbstractLinkedList.Node<E> getPreviousNode(){ return null; }
        protected AbstractLinkedList.Node<E> next = null;
        protected AbstractLinkedList.Node<E> previous = null;
        protected E getValue(){ return null; }
        protected E value = null;
        protected Node(){}
        protected Node(AbstractLinkedList.Node<E> p0, AbstractLinkedList.Node<E> p1, E p2){}
        protected Node(E p0){}
        protected void setNextNode(AbstractLinkedList.Node<E> p0){}
        protected void setPreviousNode(AbstractLinkedList.Node<E> p0){}
        protected void setValue(E p0){}
    }
}
