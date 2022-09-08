// Generated automatically from com.fasterxml.jackson.databind.ser.Serializers for testing purposes

package com.fasterxml.jackson.databind.ser;

import com.fasterxml.jackson.databind.BeanDescription;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializationConfig;
import com.fasterxml.jackson.databind.jsontype.TypeSerializer;
import com.fasterxml.jackson.databind.type.ArrayType;
import com.fasterxml.jackson.databind.type.CollectionLikeType;
import com.fasterxml.jackson.databind.type.CollectionType;
import com.fasterxml.jackson.databind.type.MapLikeType;
import com.fasterxml.jackson.databind.type.MapType;
import com.fasterxml.jackson.databind.type.ReferenceType;

public interface Serializers
{
    JsonSerializer<? extends Object> findArraySerializer(SerializationConfig p0, ArrayType p1, BeanDescription p2, TypeSerializer p3, JsonSerializer<Object> p4);
    JsonSerializer<? extends Object> findCollectionLikeSerializer(SerializationConfig p0, CollectionLikeType p1, BeanDescription p2, TypeSerializer p3, JsonSerializer<Object> p4);
    JsonSerializer<? extends Object> findCollectionSerializer(SerializationConfig p0, CollectionType p1, BeanDescription p2, TypeSerializer p3, JsonSerializer<Object> p4);
    JsonSerializer<? extends Object> findMapLikeSerializer(SerializationConfig p0, MapLikeType p1, BeanDescription p2, JsonSerializer<Object> p3, TypeSerializer p4, JsonSerializer<Object> p5);
    JsonSerializer<? extends Object> findMapSerializer(SerializationConfig p0, MapType p1, BeanDescription p2, JsonSerializer<Object> p3, TypeSerializer p4, JsonSerializer<Object> p5);
    JsonSerializer<? extends Object> findReferenceSerializer(SerializationConfig p0, ReferenceType p1, BeanDescription p2, TypeSerializer p3, JsonSerializer<Object> p4);
    JsonSerializer<? extends Object> findSerializer(SerializationConfig p0, JavaType p1, BeanDescription p2);
}
