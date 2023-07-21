// Generated automatically from org.jdbi.v3.core.codec.CodecFactory for testing purposes

package org.jdbi.v3.core.codec;

import java.lang.reflect.Type;
import java.util.Collection;
import java.util.Map;
import java.util.Optional;
import java.util.concurrent.ConcurrentMap;
import java.util.function.Function;
import org.jdbi.v3.core.argument.Argument;
import org.jdbi.v3.core.argument.QualifiedArgumentFactory;
import org.jdbi.v3.core.codec.Codec;
import org.jdbi.v3.core.config.ConfigRegistry;
import org.jdbi.v3.core.generic.GenericType;
import org.jdbi.v3.core.mapper.ColumnMapper;
import org.jdbi.v3.core.mapper.QualifiedColumnMapperFactory;
import org.jdbi.v3.core.qualifier.QualifiedType;

public class CodecFactory implements QualifiedArgumentFactory.Preparable, QualifiedColumnMapperFactory
{
    protected CodecFactory() {}
    protected Codec<? extends Object> resolveType(QualifiedType<? extends Object> p0){ return null; }
    protected final ConcurrentMap<QualifiedType<? extends Object>, Codec<? extends Object>> codecMap = null;
    public CodecFactory(Map<QualifiedType<? extends Object>, Codec<? extends Object>> p0){}
    public final Collection<QualifiedType<? extends Object>> prePreparedTypes(){ return null; }
    public final Optional<Argument> build(QualifiedType<? extends Object> p0, Object p1, ConfigRegistry p2){ return null; }
    public final Optional<ColumnMapper<? extends Object>> build(QualifiedType<? extends Object> p0, ConfigRegistry p1){ return null; }
    public final Optional<Function<Object, Argument>> prepare(QualifiedType<? extends Object> p0, ConfigRegistry p1){ return null; }
    public static CodecFactory forSingleCodec(QualifiedType<? extends Object> p0, Codec<? extends Object> p1){ return null; }
    public static CodecFactory.Builder builder(){ return null; }
    static public class Builder
    {
        protected Builder() {}
        public Builder(Function<Map<QualifiedType<? extends Object>, Codec<? extends Object>>, CodecFactory> p0){}
        public CodecFactory build(){ return null; }
        public CodecFactory.Builder addCodec(GenericType<? extends Object> p0, Codec<? extends Object> p1){ return null; }
        public CodecFactory.Builder addCodec(QualifiedType<? extends Object> p0, Codec<? extends Object> p1){ return null; }
        public CodecFactory.Builder addCodec(Type p0, Codec<? extends Object> p1){ return null; }
    }
}
