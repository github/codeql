// Generated automatically from org.jdbi.v3.core.extension.ExtensionFactory for testing purposes

package org.jdbi.v3.core.extension;

import org.jdbi.v3.core.extension.HandleSupplier;

public interface ExtensionFactory
{
    <E> E attach(java.lang.Class<E> p0, HandleSupplier p1);
    boolean accepts(Class<? extends Object> p0);
}
