// Generated automatically from org.jdbi.v3.core.collector.CollectorFactory for testing purposes

package org.jdbi.v3.core.collector;

import java.lang.reflect.Type;
import java.util.Optional;
import java.util.stream.Collector;

public interface CollectorFactory
{
    Collector<? extends Object, ? extends Object, ? extends Object> build(Type p0);
    Optional<Type> elementType(Type p0);
    boolean accepts(Type p0);
}
