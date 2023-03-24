// Generated automatically from org.jdbi.v3.core.result.RowReducer for testing purposes

package org.jdbi.v3.core.result;

import java.util.stream.Stream;
import org.jdbi.v3.core.result.RowView;

public interface RowReducer<C, R>
{
    C container();
    java.util.stream.Stream<R> stream(C p0);
    void accumulate(C p0, RowView p1);
}
