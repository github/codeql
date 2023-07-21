// Generated automatically from org.jdbi.v3.core.mapper.RowMapperFactory for testing purposes

package org.jdbi.v3.core.mapper;

import java.lang.reflect.Type;
import java.util.Optional;
import org.jdbi.v3.core.config.ConfigRegistry;
import org.jdbi.v3.core.mapper.RowMapper;

public interface RowMapperFactory
{
    Optional<RowMapper<? extends Object>> build(Type p0, ConfigRegistry p1);
    static RowMapperFactory of(Type p0, RowMapper<? extends Object> p1){ return null; }
}
