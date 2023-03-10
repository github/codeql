// Generated automatically from org.jdbi.v3.core.config.Configurable for testing purposes

package org.jdbi.v3.core.config;

import java.lang.reflect.Type;
import java.util.function.Consumer;
import java.util.function.Function;
import org.jdbi.v3.core.argument.ArgumentFactory;
import org.jdbi.v3.core.argument.QualifiedArgumentFactory;
import org.jdbi.v3.core.array.SqlArrayArgumentStrategy;
import org.jdbi.v3.core.array.SqlArrayType;
import org.jdbi.v3.core.array.SqlArrayTypeFactory;
import org.jdbi.v3.core.codec.CodecFactory;
import org.jdbi.v3.core.collector.CollectorFactory;
import org.jdbi.v3.core.config.ConfigRegistry;
import org.jdbi.v3.core.config.JdbiConfig;
import org.jdbi.v3.core.extension.ExtensionFactory;
import org.jdbi.v3.core.generic.GenericType;
import org.jdbi.v3.core.mapper.ColumnMapper;
import org.jdbi.v3.core.mapper.ColumnMapperFactory;
import org.jdbi.v3.core.mapper.QualifiedColumnMapperFactory;
import org.jdbi.v3.core.mapper.RowMapper;
import org.jdbi.v3.core.mapper.RowMapperFactory;
import org.jdbi.v3.core.qualifier.QualifiedType;
import org.jdbi.v3.core.statement.SqlLogger;
import org.jdbi.v3.core.statement.SqlParser;
import org.jdbi.v3.core.statement.StatementCustomizer;
import org.jdbi.v3.core.statement.TemplateEngine;
import org.jdbi.v3.core.statement.TimingCollector;

public interface Configurable<This>
{
    ConfigRegistry getConfig();
    default <C extends org.jdbi.v3.core.config.JdbiConfig<C>> C getConfig(java.lang.Class<C> p0){ return null; }
    default <C extends org.jdbi.v3.core.config.JdbiConfig<C>> This configure(java.lang.Class<C> p0, java.util.function.Consumer<C> p1){ return null; }
    default <T> This registerArrayType(java.lang.Class<T> p0, String p1, java.util.function.Function<T, ? extends Object> p2){ return null; }
    default <T> This registerColumnMapper(org.jdbi.v3.core.generic.GenericType<T> p0, org.jdbi.v3.core.mapper.ColumnMapper<T> p1){ return null; }
    default <T> This registerColumnMapper(org.jdbi.v3.core.qualifier.QualifiedType<T> p0, org.jdbi.v3.core.mapper.ColumnMapper<T> p1){ return null; }
    default <T> This registerRowMapper(org.jdbi.v3.core.generic.GenericType<T> p0, org.jdbi.v3.core.mapper.RowMapper<T> p1){ return null; }
    default This addCustomizer(StatementCustomizer p0){ return null; }
    default This define(String p0, Object p1){ return null; }
    default This registerArgument(ArgumentFactory p0){ return null; }
    default This registerArgument(QualifiedArgumentFactory p0){ return null; }
    default This registerArrayType(Class<? extends Object> p0, String p1){ return null; }
    default This registerArrayType(SqlArrayType<? extends Object> p0){ return null; }
    default This registerArrayType(SqlArrayTypeFactory p0){ return null; }
    default This registerCodecFactory(CodecFactory p0){ return null; }
    default This registerCollector(CollectorFactory p0){ return null; }
    default This registerColumnMapper(ColumnMapper<? extends Object> p0){ return null; }
    default This registerColumnMapper(ColumnMapperFactory p0){ return null; }
    default This registerColumnMapper(QualifiedColumnMapperFactory p0){ return null; }
    default This registerColumnMapper(Type p0, ColumnMapper<? extends Object> p1){ return null; }
    default This registerExtension(ExtensionFactory p0){ return null; }
    default This registerRowMapper(RowMapper<? extends Object> p0){ return null; }
    default This registerRowMapper(RowMapperFactory p0){ return null; }
    default This registerRowMapper(Type p0, RowMapper<? extends Object> p1){ return null; }
    default This setMapKeyColumn(String p0){ return null; }
    default This setMapValueColumn(String p0){ return null; }
    default This setSqlArrayArgumentStrategy(SqlArrayArgumentStrategy p0){ return null; }
    default This setSqlLogger(SqlLogger p0){ return null; }
    default This setSqlParser(SqlParser p0){ return null; }
    default This setTemplateEngine(TemplateEngine p0){ return null; }
    default This setTimingCollector(TimingCollector p0){ return null; }
}
