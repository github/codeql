// Generated automatically from org.jdbi.v3.core.result.BatchResultIterable for testing purposes

package org.jdbi.v3.core.result;

import java.util.List;
import java.util.function.Supplier;
import org.jdbi.v3.core.result.ResultIterable;

public interface BatchResultIterable<T> extends org.jdbi.v3.core.result.ResultIterable<T>
{
    List<java.util.List<T>> listPerBatch();
    static <U> BatchResultIterable<U> of(ResultIterable<U> p0, Supplier<int[]> p1){ return null; }
}
