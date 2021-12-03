// Generated automatically from com.google.common.collect.PeekingIterator for testing purposes

package com.google.common.collect;

import java.util.Iterator;

public interface PeekingIterator<E> extends Iterator<E>
{
    E next();
    E peek();
    void remove();
}
