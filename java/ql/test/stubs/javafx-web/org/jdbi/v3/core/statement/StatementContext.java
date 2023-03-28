// Generated automatically from org.jdbi.v3.core.statement.StatementContext for testing purposes

package org.jdbi.v3.core.statement;

import java.io.Closeable;
import java.lang.reflect.Type;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collector;
import org.jdbi.v3.core.argument.Argument;
import org.jdbi.v3.core.array.SqlArrayArgumentStrategy;
import org.jdbi.v3.core.array.SqlArrayType;
import org.jdbi.v3.core.config.ConfigRegistry;
import org.jdbi.v3.core.config.JdbiConfig;
import org.jdbi.v3.core.extension.ExtensionMethod;
import org.jdbi.v3.core.generic.GenericType;
import org.jdbi.v3.core.mapper.ColumnMapper;
import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.qualifier.QualifiedType;
import org.jdbi.v3.core.statement.Binding;
import org.jdbi.v3.core.statement.Cleanable;
import org.jdbi.v3.core.statement.ParsedSql;

public class StatementContext implements Closeable
{
    protected StatementContext() {}
    public <C extends org.jdbi.v3.core.config.JdbiConfig<C>> C getConfig(java.lang.Class<C> p0){ return null; }
    public <T> java.util.Optional<org.jdbi.v3.core.mapper.ColumnMapper<T>> findColumnMapperFor(java.lang.Class<T> p0){ return null; }
    public <T> java.util.Optional<org.jdbi.v3.core.mapper.ColumnMapper<T>> findColumnMapperFor(org.jdbi.v3.core.generic.GenericType<T> p0){ return null; }
    public <T> java.util.Optional<org.jdbi.v3.core.mapper.ColumnMapper<T>> findColumnMapperFor(org.jdbi.v3.core.qualifier.QualifiedType<T> p0){ return null; }
    public <T> java.util.Optional<org.jdbi.v3.core.mapper.RowMapper<T>> findMapperFor(java.lang.Class<T> p0){ return null; }
    public <T> java.util.Optional<org.jdbi.v3.core.mapper.RowMapper<T>> findMapperFor(org.jdbi.v3.core.generic.GenericType<T> p0){ return null; }
    public <T> java.util.Optional<org.jdbi.v3.core.mapper.RowMapper<T>> findMapperFor(org.jdbi.v3.core.qualifier.QualifiedType<T> p0){ return null; }
    public <T> java.util.Optional<org.jdbi.v3.core.mapper.RowMapper<T>> findRowMapperFor(java.lang.Class<T> p0){ return null; }
    public <T> java.util.Optional<org.jdbi.v3.core.mapper.RowMapper<T>> findRowMapperFor(org.jdbi.v3.core.generic.GenericType<T> p0){ return null; }
    public Binding getBinding(){ return null; }
    public ConfigRegistry getConfig(){ return null; }
    public Connection getConnection(){ return null; }
    public ExtensionMethod getExtensionMethod(){ return null; }
    public Instant getCompletionMoment(){ return null; }
    public Instant getExceptionMoment(){ return null; }
    public Instant getExecutionMoment(){ return null; }
    public Map<String, Object> getAttributes(){ return null; }
    public Object getAttribute(String p0){ return null; }
    public Optional<Argument> findArgumentFor(QualifiedType<? extends Object> p0, Object p1){ return null; }
    public Optional<Argument> findArgumentFor(Type p0, Object p1){ return null; }
    public Optional<Collector<? extends Object, ? extends Object, ? extends Object>> findCollectorFor(Type p0){ return null; }
    public Optional<ColumnMapper<? extends Object>> findColumnMapperFor(Type p0){ return null; }
    public Optional<RowMapper<? extends Object>> findMapperFor(Type p0){ return null; }
    public Optional<RowMapper<? extends Object>> findRowMapperFor(Type p0){ return null; }
    public Optional<SqlArrayType<? extends Object>> findSqlArrayTypeFor(Type p0){ return null; }
    public Optional<Type> findElementTypeFor(Type p0){ return null; }
    public ParsedSql getParsedSql(){ return null; }
    public PreparedStatement getStatement(){ return null; }
    public SqlArrayArgumentStrategy getSqlArrayArgumentStrategy(){ return null; }
    public String getRawSql(){ return null; }
    public String getRenderedSql(){ return null; }
    public String[] getGeneratedKeysColumnNames(){ return null; }
    public boolean isConcurrentUpdatable(){ return false; }
    public boolean isReturningGeneratedKeys(){ return false; }
    public final boolean equals(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public long getElapsedTime(ChronoUnit p0){ return 0; }
    public void addCleanable(Cleanable p0){}
    public void close(){}
    public void define(String p0, Object p1){}
    public void setCompletionMoment(Instant p0){}
    public void setConcurrentUpdatable(boolean p0){}
    public void setExceptionMoment(Instant p0){}
    public void setExecutionMoment(Instant p0){}
    public void setGeneratedKeysColumnNames(String[] p0){}
    public void setReturningGeneratedKeys(boolean p0){}
}
