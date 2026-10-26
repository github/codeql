// Generated automatically from org.jdbi.v3.core.argument.ArgumentFactory for testing purposes

package org.jdbi.v3.core.argument;

import java.lang.reflect.Type;
import java.util.Collection;
import java.util.Optional;
import java.util.function.Function;
import org.jdbi.v3.core.argument.Argument;
import org.jdbi.v3.core.config.ConfigRegistry;

public interface ArgumentFactory
{
    Optional<Argument> build(Type p0, Object p1, ConfigRegistry p2);
    static public interface Preparable extends ArgumentFactory
    {
        Optional<Function<Object, Argument>> prepare(Type p0, ConfigRegistry p1);
        default Collection<? extends Type> prePreparedTypes(){ return null; }
        default Optional<Argument> build(Type p0, Object p1, ConfigRegistry p2){ return null; }
    }
}
