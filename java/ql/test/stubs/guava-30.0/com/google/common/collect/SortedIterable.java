// Generated automatically from com.google.common.collect.SortedIterable for testing purposes

package com.google.common.collect;

import java.util.Comparator;
import java.util.Iterator;

interface SortedIterable<T> extends Iterable<T>
{
    Comparator<? super T> comparator();
    Iterator<T> iterator();
}
