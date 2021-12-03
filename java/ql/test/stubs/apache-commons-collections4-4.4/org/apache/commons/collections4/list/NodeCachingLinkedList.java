// Generated automatically from org.apache.commons.collections4.list.NodeCachingLinkedList for testing purposes

package org.apache.commons.collections4.list;

import java.io.Serializable;
import java.util.Collection;
import org.apache.commons.collections4.list.AbstractLinkedList;

public class NodeCachingLinkedList<E> extends AbstractLinkedList<E> implements Serializable
{
    protected AbstractLinkedList.Node<E> createNode(E p0){ return null; }
    protected AbstractLinkedList.Node<E> getNodeFromCache(){ return null; }
    protected boolean isCacheFull(){ return false; }
    protected int getMaximumCacheSize(){ return 0; }
    protected void addNodeToCache(AbstractLinkedList.Node<E> p0){}
    protected void removeAllNodes(){}
    protected void removeNode(AbstractLinkedList.Node<E> p0){}
    protected void setMaximumCacheSize(int p0){}
    protected void shrinkCacheToMaximumSize(){}
    public NodeCachingLinkedList(){}
    public NodeCachingLinkedList(Collection<? extends E> p0){}
    public NodeCachingLinkedList(int p0){}
}
