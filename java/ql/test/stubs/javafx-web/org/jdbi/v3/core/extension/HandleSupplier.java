// Generated automatically from org.jdbi.v3.core.extension.HandleSupplier for testing purposes

package org.jdbi.v3.core.extension;

import java.util.concurrent.Callable;
import org.jdbi.v3.core.Handle;
import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.core.config.ConfigRegistry;
import org.jdbi.v3.core.config.Configurable;
import org.jdbi.v3.core.extension.ExtensionContext;
import org.jdbi.v3.core.extension.ExtensionMethod;

public interface HandleSupplier extends AutoCloseable, Configurable<HandleSupplier>
{
    <V> V invokeInContext(ExtensionMethod p0, ConfigRegistry p1, java.util.concurrent.Callable<V> p2);
    Handle getHandle();
    Jdbi getJdbi();
    default <V> V invokeInContext(ExtensionContext p0, java.util.concurrent.Callable<V> p1){ return null; }
    default void close(){}
}
