// Generated automatically from org.jdbi.v3.core.result.StreamCallback for testing purposes

package org.jdbi.v3.core.result;

import java.util.stream.Stream;

public interface StreamCallback<T, R, X extends Exception>
{
    R withStream(java.util.stream.Stream<T> p0);
}
