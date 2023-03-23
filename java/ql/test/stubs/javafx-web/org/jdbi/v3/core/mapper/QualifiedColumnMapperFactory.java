// Generated automatically from org.jdbi.v3.core.mapper.QualifiedColumnMapperFactory for testing purposes

package org.jdbi.v3.core.mapper;

import java.util.Optional;
import org.jdbi.v3.core.config.ConfigRegistry;
import org.jdbi.v3.core.mapper.ColumnMapper;
import org.jdbi.v3.core.mapper.ColumnMapperFactory;
import org.jdbi.v3.core.qualifier.QualifiedType;

public interface QualifiedColumnMapperFactory
{
    Optional<ColumnMapper<? extends Object>> build(QualifiedType<? extends Object> p0, ConfigRegistry p1);
    static <T> QualifiedColumnMapperFactory of(org.jdbi.v3.core.qualifier.QualifiedType<T> p0, org.jdbi.v3.core.mapper.ColumnMapper<T> p1){ return null; }
    static QualifiedColumnMapperFactory adapt(ColumnMapperFactory p0){ return null; }
}
