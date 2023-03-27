// Generated automatically from org.jdbi.v3.core.array.SqlArrayTypeFactory for testing purposes

package org.jdbi.v3.core.array;

import java.lang.reflect.Type;
import java.util.Optional;
import java.util.function.Function;
import org.jdbi.v3.core.array.SqlArrayType;
import org.jdbi.v3.core.config.ConfigRegistry;

public interface SqlArrayTypeFactory
{
    Optional<SqlArrayType<? extends Object>> build(Type p0, ConfigRegistry p1);
    static <T> SqlArrayTypeFactory of(java.lang.Class<T> p0, String p1, java.util.function.Function<T, ? extends Object> p2){ return null; }
}
