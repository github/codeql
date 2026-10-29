// Generated automatically from org.jdbi.v3.core.result.ResultIterator for testing purposes

package org.jdbi.v3.core.result;

import java.io.Closeable;
import java.util.Iterator;
import java.util.function.Consumer;
import org.jdbi.v3.core.statement.StatementContext;

public interface ResultIterator<T> extends Closeable, java.util.Iterator<T>
{
    StatementContext getContext();
    default void forEachRemaining(java.util.function.Consumer<? super T> p0){}
    void close();
}
