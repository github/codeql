// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.ser.Serializers for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.ser;

import org.apache.htrace.shaded.fasterxml.jackson.databind.BeanDescription;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JavaType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JsonSerializer;
import org.apache.htrace.shaded.fasterxml.jackson.databind.SerializationConfig;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsontype.TypeSerializer;
import org.apache.htrace.shaded.fasterxml.jackson.databind.type.ArrayType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.type.CollectionLikeType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.type.CollectionType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.type.MapLikeType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.type.MapType;

public interface Serializers
{
    JsonSerializer<? extends Object> findArraySerializer(SerializationConfig p0, ArrayType p1, BeanDescription p2, TypeSerializer p3, JsonSerializer<Object> p4);
    JsonSerializer<? extends Object> findCollectionLikeSerializer(SerializationConfig p0, CollectionLikeType p1, BeanDescription p2, TypeSerializer p3, JsonSerializer<Object> p4);
    JsonSerializer<? extends Object> findCollectionSerializer(SerializationConfig p0, CollectionType p1, BeanDescription p2, TypeSerializer p3, JsonSerializer<Object> p4);
    JsonSerializer<? extends Object> findMapLikeSerializer(SerializationConfig p0, MapLikeType p1, BeanDescription p2, JsonSerializer<Object> p3, TypeSerializer p4, JsonSerializer<Object> p5);
    JsonSerializer<? extends Object> findMapSerializer(SerializationConfig p0, MapType p1, BeanDescription p2, JsonSerializer<Object> p3, TypeSerializer p4, JsonSerializer<Object> p5);
    JsonSerializer<? extends Object> findSerializer(SerializationConfig p0, JavaType p1, BeanDescription p2);
}
