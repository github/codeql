// Generated automatically from com.fasterxml.jackson.databind.jsontype.TypeResolverBuilder for testing purposes

package com.fasterxml.jackson.databind.jsontype;

import com.fasterxml.jackson.annotation.JsonTypeInfo;
import com.fasterxml.jackson.databind.DeserializationConfig;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.SerializationConfig;
import com.fasterxml.jackson.databind.jsontype.NamedType;
import com.fasterxml.jackson.databind.jsontype.TypeDeserializer;
import com.fasterxml.jackson.databind.jsontype.TypeIdResolver;
import com.fasterxml.jackson.databind.jsontype.TypeSerializer;
import java.util.Collection;

public interface TypeResolverBuilder<T extends TypeResolverBuilder<T>>
{
    Class<? extends Object> getDefaultImpl();
    T defaultImpl(Class<? extends Object> p0);
    T inclusion(JsonTypeInfo.As p0);
    T init(JsonTypeInfo.Id p0, TypeIdResolver p1);
    T typeIdVisibility(boolean p0);
    T typeProperty(String p0);
    TypeDeserializer buildTypeDeserializer(DeserializationConfig p0, JavaType p1, Collection<NamedType> p2);
    TypeSerializer buildTypeSerializer(SerializationConfig p0, JavaType p1, Collection<NamedType> p2);
}
