// Generated automatically from org.jdbi.v3.core.mapper.ColumnMapperFactory for testing purposes

package org.jdbi.v3.core.mapper;

import java.lang.reflect.Type;
import java.util.Optional;
import org.jdbi.v3.core.config.ConfigRegistry;
import org.jdbi.v3.core.mapper.ColumnMapper;

public interface ColumnMapperFactory
{
    Optional<ColumnMapper<? extends Object>> build(Type p0, ConfigRegistry p1);
    static ColumnMapperFactory of(Type p0, ColumnMapper<? extends Object> p1){ return null; }
}
