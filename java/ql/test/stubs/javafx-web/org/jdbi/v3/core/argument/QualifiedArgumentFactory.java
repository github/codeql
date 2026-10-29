// Generated automatically from org.jdbi.v3.core.argument.QualifiedArgumentFactory for testing purposes

package org.jdbi.v3.core.argument;

import java.util.Collection;
import java.util.Optional;
import java.util.function.Function;
import org.jdbi.v3.core.argument.Argument;
import org.jdbi.v3.core.argument.ArgumentFactory;
import org.jdbi.v3.core.config.ConfigRegistry;
import org.jdbi.v3.core.qualifier.QualifiedType;

public interface QualifiedArgumentFactory
{
    Optional<Argument> build(QualifiedType<? extends Object> p0, Object p1, ConfigRegistry p2);
    static QualifiedArgumentFactory adapt(ConfigRegistry p0, ArgumentFactory p1){ return null; }
    static QualifiedArgumentFactory.Preparable adapt(ConfigRegistry p0, ArgumentFactory.Preparable p1){ return null; }
    static public interface Preparable extends QualifiedArgumentFactory
    {
        Optional<Function<Object, Argument>> prepare(QualifiedType<? extends Object> p0, ConfigRegistry p1);
        default Collection<QualifiedType<? extends Object>> prePreparedTypes(){ return null; }
        static QualifiedArgumentFactory.Preparable adapt(ConfigRegistry p0, ArgumentFactory.Preparable p1){ return null; }
    }
}
