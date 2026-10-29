// Generated automatically from org.jdbi.v3.core.statement.SqlStatement for testing purposes

package org.jdbi.v3.core.statement;

import java.io.InputStream;
import java.io.Reader;
import java.lang.reflect.Type;
import java.math.BigDecimal;
import java.net.URI;
import java.net.URL;
import java.sql.Blob;
import java.sql.Clob;
import java.sql.Time;
import java.sql.Timestamp;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.function.BiConsumer;
import org.jdbi.v3.core.argument.Argument;
import org.jdbi.v3.core.argument.NamedArgumentFinder;
import org.jdbi.v3.core.generic.GenericType;
import org.jdbi.v3.core.qualifier.QualifiedType;
import org.jdbi.v3.core.statement.BaseStatement;
import org.jdbi.v3.core.statement.Binding;

abstract public class SqlStatement<This extends SqlStatement<This>> extends BaseStatement<This>
{
    protected SqlStatement() {}
    protected Binding getBinding(){ return null; }
    protected String getSql(){ return null; }
    public String toString(){ return null; }
    public This bind(String p0, Argument p1){ return null; }
    public This bind(int p0, Argument p1){ return null; }
    public This bindBean(Object p0){ return null; }
    public This bindBean(String p0, Object p1){ return null; }
    public This bindFields(Object p0){ return null; }
    public This bindFields(String p0, Object p1){ return null; }
    public This bindMap(Map<String, ? extends Object> p0){ return null; }
    public This bindMethods(Object p0){ return null; }
    public This bindMethods(String p0, Object p1){ return null; }
    public This bindNamedArgumentFinder(NamedArgumentFinder p0){ return null; }
    public This bindPojo(Object p0){ return null; }
    public This bindPojo(Object p0, GenericType<? extends Object> p1){ return null; }
    public This bindPojo(Object p0, Type p1){ return null; }
    public This bindPojo(String p0, Object p1){ return null; }
    public This bindPojo(String p0, Object p1, GenericType<? extends Object> p2){ return null; }
    public This bindPojo(String p0, Object p1, Type p2){ return null; }
    public This cleanupHandleCommit(){ return null; }
    public This cleanupHandleRollback(){ return null; }
    public This defineNamedBindings(){ return null; }
    public This setQueryTimeout(int p0){ return null; }
    public final <T> This bindArray(String p0, T... p1){ return null; }
    public final <T> This bindArray(int p0, T... p1){ return null; }
    public final This bind(String p0, BigDecimal p1){ return null; }
    public final This bind(String p0, Blob p1){ return null; }
    public final This bind(String p0, Boolean p1){ return null; }
    public final This bind(String p0, Byte p1){ return null; }
    public final This bind(String p0, Character p1){ return null; }
    public final This bind(String p0, Clob p1){ return null; }
    public final This bind(String p0, Double p1){ return null; }
    public final This bind(String p0, Float p1){ return null; }
    public final This bind(String p0, Integer p1){ return null; }
    public final This bind(String p0, Long p1){ return null; }
    public final This bind(String p0, Object p1){ return null; }
    public final This bind(String p0, Reader p1, int p2){ return null; }
    public final This bind(String p0, Short p1){ return null; }
    public final This bind(String p0, String p1){ return null; }
    public final This bind(String p0, Time p1){ return null; }
    public final This bind(String p0, Timestamp p1){ return null; }
    public final This bind(String p0, URI p1){ return null; }
    public final This bind(String p0, URL p1){ return null; }
    public final This bind(String p0, UUID p1){ return null; }
    public final This bind(String p0, boolean p1){ return null; }
    public final This bind(String p0, byte p1){ return null; }
    public final This bind(String p0, byte[] p1){ return null; }
    public final This bind(String p0, char p1){ return null; }
    public final This bind(String p0, double p1){ return null; }
    public final This bind(String p0, float p1){ return null; }
    public final This bind(String p0, int p1){ return null; }
    public final This bind(String p0, java.sql.Date p1){ return null; }
    public final This bind(String p0, java.util.Date p1){ return null; }
    public final This bind(String p0, long p1){ return null; }
    public final This bind(String p0, short p1){ return null; }
    public final This bind(int p0, BigDecimal p1){ return null; }
    public final This bind(int p0, Blob p1){ return null; }
    public final This bind(int p0, Boolean p1){ return null; }
    public final This bind(int p0, Byte p1){ return null; }
    public final This bind(int p0, Character p1){ return null; }
    public final This bind(int p0, Clob p1){ return null; }
    public final This bind(int p0, Double p1){ return null; }
    public final This bind(int p0, Float p1){ return null; }
    public final This bind(int p0, Integer p1){ return null; }
    public final This bind(int p0, Long p1){ return null; }
    public final This bind(int p0, Object p1){ return null; }
    public final This bind(int p0, Reader p1, int p2){ return null; }
    public final This bind(int p0, Short p1){ return null; }
    public final This bind(int p0, String p1){ return null; }
    public final This bind(int p0, Time p1){ return null; }
    public final This bind(int p0, Timestamp p1){ return null; }
    public final This bind(int p0, URI p1){ return null; }
    public final This bind(int p0, URL p1){ return null; }
    public final This bind(int p0, UUID p1){ return null; }
    public final This bind(int p0, boolean p1){ return null; }
    public final This bind(int p0, byte p1){ return null; }
    public final This bind(int p0, byte[] p1){ return null; }
    public final This bind(int p0, char p1){ return null; }
    public final This bind(int p0, double p1){ return null; }
    public final This bind(int p0, float p1){ return null; }
    public final This bind(int p0, int p1){ return null; }
    public final This bind(int p0, java.sql.Date p1){ return null; }
    public final This bind(int p0, java.util.Date p1){ return null; }
    public final This bind(int p0, long p1){ return null; }
    public final This bind(int p0, short p1){ return null; }
    public final This bindASCIIStream(String p0, InputStream p1, int p2){ return null; }
    public final This bindASCIIStream(int p0, InputStream p1, int p2){ return null; }
    public final This bindArray(String p0, Type p1, Iterable<? extends Object> p2){ return null; }
    public final This bindArray(String p0, Type p1, Iterator<? extends Object> p2){ return null; }
    public final This bindArray(String p0, Type p1, Object... p2){ return null; }
    public final This bindArray(int p0, Type p1, Iterable<? extends Object> p2){ return null; }
    public final This bindArray(int p0, Type p1, Iterator<? extends Object> p2){ return null; }
    public final This bindArray(int p0, Type p1, Object... p2){ return null; }
    public final This bindBeanList(String p0, List<? extends Object> p1, List<String> p2){ return null; }
    public final This bindBinaryStream(String p0, InputStream p1, int p2){ return null; }
    public final This bindBinaryStream(int p0, InputStream p1, int p2){ return null; }
    public final This bindBySqlType(String p0, Object p1, int p2){ return null; }
    public final This bindBySqlType(int p0, Object p1, int p2){ return null; }
    public final This bindByType(String p0, Object p1, GenericType<? extends Object> p2){ return null; }
    public final This bindByType(String p0, Object p1, QualifiedType<? extends Object> p2){ return null; }
    public final This bindByType(String p0, Object p1, Type p2){ return null; }
    public final This bindByType(int p0, Object p1, GenericType<? extends Object> p2){ return null; }
    public final This bindByType(int p0, Object p1, QualifiedType<? extends Object> p2){ return null; }
    public final This bindByType(int p0, Object p1, Type p2){ return null; }
    public final This bindList(BiConsumer<SqlStatement, String> p0, String p1, Iterable<? extends Object> p2){ return null; }
    public final This bindList(BiConsumer<SqlStatement, String> p0, String p1, Iterator<? extends Object> p2){ return null; }
    public final This bindList(BiConsumer<SqlStatement, String> p0, String p1, List<? extends Object> p2){ return null; }
    public final This bindList(BiConsumer<SqlStatement, String> p0, String p1, Object... p2){ return null; }
    public final This bindList(String p0, Iterable<? extends Object> p1){ return null; }
    public final This bindList(String p0, Iterator<? extends Object> p1){ return null; }
    public final This bindList(String p0, Object... p1){ return null; }
    public final This bindMethodsList(String p0, Iterable<? extends Object> p1, List<String> p2){ return null; }
    public final This bindNVarchar(String p0, String p1){ return null; }
    public final This bindNVarchar(int p0, String p1){ return null; }
    public final This bindNull(String p0, int p1){ return null; }
    public final This bindNull(int p0, int p1){ return null; }
    public final This defineList(String p0, List<? extends Object> p1){ return null; }
    public final This defineList(String p0, Object... p1){ return null; }
}
