// Generated automatically from org.jdbi.v3.core.codec.Codec for testing purposes

package org.jdbi.v3.core.codec;

import java.util.function.Function;
import org.jdbi.v3.core.argument.Argument;
import org.jdbi.v3.core.config.ConfigRegistry;
import org.jdbi.v3.core.mapper.ColumnMapper;

public interface Codec<T>
{
    default Function<T, Argument> getArgumentFunction(){ return null; }
    default Function<T, Argument> getArgumentFunction(ConfigRegistry p0){ return null; }
    default org.jdbi.v3.core.mapper.ColumnMapper<T> getColumnMapper(){ return null; }
    default org.jdbi.v3.core.mapper.ColumnMapper<T> getColumnMapper(ConfigRegistry p0){ return null; }
}
