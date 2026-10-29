// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.cfg.HandlerInstantiator for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.cfg;

import org.apache.htrace.shaded.fasterxml.jackson.annotation.ObjectIdGenerator;
import org.apache.htrace.shaded.fasterxml.jackson.annotation.ObjectIdResolver;
import org.apache.htrace.shaded.fasterxml.jackson.databind.DeserializationConfig;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JsonDeserializer;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JsonSerializer;
import org.apache.htrace.shaded.fasterxml.jackson.databind.KeyDeserializer;
import org.apache.htrace.shaded.fasterxml.jackson.databind.PropertyNamingStrategy;
import org.apache.htrace.shaded.fasterxml.jackson.databind.SerializationConfig;
import org.apache.htrace.shaded.fasterxml.jackson.databind.cfg.MapperConfig;
import org.apache.htrace.shaded.fasterxml.jackson.databind.deser.ValueInstantiator;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.Annotated;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsontype.TypeIdResolver;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsontype.TypeResolverBuilder;
import org.apache.htrace.shaded.fasterxml.jackson.databind.util.Converter;

abstract public class HandlerInstantiator
{
    public Converter<? extends Object, ? extends Object> converterInstance(MapperConfig<? extends Object> p0, Annotated p1, Class<? extends Object> p2){ return null; }
    public HandlerInstantiator(){}
    public ObjectIdGenerator<? extends Object> objectIdGeneratorInstance(MapperConfig<? extends Object> p0, Annotated p1, Class<? extends Object> p2){ return null; }
    public ObjectIdResolver resolverIdGeneratorInstance(MapperConfig<? extends Object> p0, Annotated p1, Class<? extends Object> p2){ return null; }
    public PropertyNamingStrategy namingStrategyInstance(MapperConfig<? extends Object> p0, Annotated p1, Class<? extends Object> p2){ return null; }
    public ValueInstantiator valueInstantiatorInstance(MapperConfig<? extends Object> p0, Annotated p1, Class<? extends Object> p2){ return null; }
    public abstract JsonDeserializer<? extends Object> deserializerInstance(DeserializationConfig p0, Annotated p1, Class<? extends Object> p2);
    public abstract JsonSerializer<? extends Object> serializerInstance(SerializationConfig p0, Annotated p1, Class<? extends Object> p2);
    public abstract KeyDeserializer keyDeserializerInstance(DeserializationConfig p0, Annotated p1, Class<? extends Object> p2);
    public abstract TypeIdResolver typeIdResolverInstance(MapperConfig<? extends Object> p0, Annotated p1, Class<? extends Object> p2);
    public abstract TypeResolverBuilder<? extends Object> typeResolverBuilderInstance(MapperConfig<? extends Object> p0, Annotated p1, Class<? extends Object> p2);
}
