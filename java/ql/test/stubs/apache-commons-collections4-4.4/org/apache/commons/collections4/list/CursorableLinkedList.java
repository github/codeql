// Generated automatically from org.apache.commons.collections4.list.CursorableLinkedList for testing purposes

package org.apache.commons.collections4.list;

import java.io.Serializable;
import java.util.Collection;
import java.util.Iterator;
import java.util.ListIterator;
import org.apache.commons.collections4.list.AbstractLinkedList;

public class CursorableLinkedList<E> extends AbstractLinkedList<E> implements Serializable
{
    protected ListIterator<E> createSubListListIterator(AbstractLinkedList.LinkedSubList<E> p0, int p1){ return null; }
    protected void addNode(AbstractLinkedList.Node<E> p0, AbstractLinkedList.Node<E> p1){}
    protected void broadcastNodeChanged(AbstractLinkedList.Node<E> p0){}
    protected void broadcastNodeInserted(AbstractLinkedList.Node<E> p0){}
    protected void broadcastNodeRemoved(AbstractLinkedList.Node<E> p0){}
    protected void init(){}
    protected void registerCursor(CursorableLinkedList.Cursor<E> p0){}
    protected void removeAllNodes(){}
    protected void removeNode(AbstractLinkedList.Node<E> p0){}
    protected void unregisterCursor(CursorableLinkedList.Cursor<E> p0){}
    protected void updateNode(AbstractLinkedList.Node<E> p0, E p1){}
    public CursorableLinkedList(){}
    public CursorableLinkedList(Collection<? extends E> p0){}
    public CursorableLinkedList.Cursor<E> cursor(){ return null; }
    public CursorableLinkedList.Cursor<E> cursor(int p0){ return null; }
    public Iterator<E> iterator(){ return null; }
    public ListIterator<E> listIterator(){ return null; }
    public ListIterator<E> listIterator(int p0){ return null; }
    static public class Cursor<E> extends AbstractLinkedList.LinkedListIterator<E>
    {
        protected Cursor() {}
        protected Cursor(CursorableLinkedList<E> p0, int p1){}
        protected void checkModCount(){}
        protected void nodeChanged(AbstractLinkedList.Node<E> p0){}
        protected void nodeInserted(AbstractLinkedList.Node<E> p0){}
        protected void nodeRemoved(AbstractLinkedList.Node<E> p0){}
        public int nextIndex(){ return 0; }
        public void add(E p0){}
        public void close(){}
        public void remove(){}
    }
}
