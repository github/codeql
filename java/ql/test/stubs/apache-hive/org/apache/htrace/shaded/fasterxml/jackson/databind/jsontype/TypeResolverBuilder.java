// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.jsontype.TypeResolverBuilder for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.jsontype;

import java.util.Collection;
import org.apache.htrace.shaded.fasterxml.jackson.annotation.JsonTypeInfo;
import org.apache.htrace.shaded.fasterxml.jackson.databind.DeserializationConfig;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JavaType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.SerializationConfig;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsontype.NamedType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsontype.TypeDeserializer;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsontype.TypeIdResolver;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsontype.TypeSerializer;

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
