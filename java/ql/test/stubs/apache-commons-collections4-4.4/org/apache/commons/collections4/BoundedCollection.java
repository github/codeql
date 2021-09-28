// Generated automatically from org.apache.commons.collections4.BoundedCollection for testing purposes

package org.apache.commons.collections4;

import java.util.Collection;

public interface BoundedCollection<E> extends Collection<E>
{
    boolean isFull();
    int maxSize();
}
