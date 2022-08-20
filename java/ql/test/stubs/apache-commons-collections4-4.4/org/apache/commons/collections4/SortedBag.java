// Generated automatically from org.apache.commons.collections4.SortedBag for testing purposes

package org.apache.commons.collections4;

import java.util.Comparator;
import org.apache.commons.collections4.Bag;

public interface SortedBag<E> extends Bag<E>
{
    Comparator<? super E> comparator();
    E first();
    E last();
}
