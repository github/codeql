package org.slf4j;

import java.io.Serializable;
import java.util.Iterator;

public interface Marker extends Serializable {
    String ANY_MARKER = "*";
    String ANY_NON_NULL_MARKER = "+";

    String getName();

    void add(Marker var1);

    boolean remove(Marker var1);

    /** @deprecated */
    boolean hasChildren();

    boolean hasReferences();

    Iterator iterator();

    boolean contains(Marker var1);

    boolean contains(String var1);

    boolean equals(Object var1);

    int hashCode();
}
