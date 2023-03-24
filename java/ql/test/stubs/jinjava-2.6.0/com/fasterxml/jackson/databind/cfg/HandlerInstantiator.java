// Generated automatically from com.fasterxml.jackson.databind.cfg.HandlerInstantiator for testing purposes

package com.fasterxml.jackson.databind.cfg;

import com.fasterxml.jackson.annotation.ObjectIdGenerator;
import com.fasterxml.jackson.annotation.ObjectIdResolver;
import com.fasterxml.jackson.databind.DeserializationConfig;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.KeyDeserializer;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;
import com.fasterxml.jackson.databind.SerializationConfig;
import com.fasterxml.jackson.databind.cfg.MapperConfig;
import com.fasterxml.jackson.databind.deser.ValueInstantiator;
import com.fasterxml.jackson.databind.introspect.Annotated;
import com.fasterxml.jackson.databind.jsontype.TypeIdResolver;
import com.fasterxml.jackson.databind.jsontype.TypeResolverBuilder;
import com.fasterxml.jackson.databind.ser.VirtualBeanPropertyWriter;
import com.fasterxml.jackson.databind.util.Converter;

abstract public class HandlerInstantiator
{
    public Converter<? extends Object, ? extends Object> converterInstance(MapperConfig<? extends Object> p0, Annotated p1, Class<? extends Object> p2){ return null; }
    public HandlerInstantiator(){}
    public ObjectIdGenerator<? extends Object> objectIdGeneratorInstance(MapperConfig<? extends Object> p0, Annotated p1, Class<? extends Object> p2){ return null; }
    public ObjectIdResolver resolverIdGeneratorInstance(MapperConfig<? extends Object> p0, Annotated p1, Class<? extends Object> p2){ return null; }
    public PropertyNamingStrategy namingStrategyInstance(MapperConfig<? extends Object> p0, Annotated p1, Class<? extends Object> p2){ return null; }
    public ValueInstantiator valueInstantiatorInstance(MapperConfig<? extends Object> p0, Annotated p1, Class<? extends Object> p2){ return null; }
    public VirtualBeanPropertyWriter virtualPropertyWriterInstance(MapperConfig<? extends Object> p0, Class<? extends Object> p1){ return null; }
    public abstract JsonDeserializer<? extends Object> deserializerInstance(DeserializationConfig p0, Annotated p1, Class<? extends Object> p2);
    public abstract JsonSerializer<? extends Object> serializerInstance(SerializationConfig p0, Annotated p1, Class<? extends Object> p2);
    public abstract KeyDeserializer keyDeserializerInstance(DeserializationConfig p0, Annotated p1, Class<? extends Object> p2);
    public abstract TypeIdResolver typeIdResolverInstance(MapperConfig<? extends Object> p0, Annotated p1, Class<? extends Object> p2);
    public abstract TypeResolverBuilder<? extends Object> typeResolverBuilderInstance(MapperConfig<? extends Object> p0, Annotated p1, Class<? extends Object> p2);
}
