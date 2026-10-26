// Generated automatically from com.fasterxml.jackson.databind.deser.Deserializers for testing purposes

package com.fasterxml.jackson.databind.deser;

import com.fasterxml.jackson.databind.BeanDescription;
import com.fasterxml.jackson.databind.DeserializationConfig;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.KeyDeserializer;
import com.fasterxml.jackson.databind.jsontype.TypeDeserializer;
import com.fasterxml.jackson.databind.type.ArrayType;
import com.fasterxml.jackson.databind.type.CollectionLikeType;
import com.fasterxml.jackson.databind.type.CollectionType;
import com.fasterxml.jackson.databind.type.MapLikeType;
import com.fasterxml.jackson.databind.type.MapType;
import com.fasterxml.jackson.databind.type.ReferenceType;

public interface Deserializers
{
    JsonDeserializer<? extends Object> findArrayDeserializer(ArrayType p0, DeserializationConfig p1, BeanDescription p2, TypeDeserializer p3, JsonDeserializer<? extends Object> p4);
    JsonDeserializer<? extends Object> findBeanDeserializer(JavaType p0, DeserializationConfig p1, BeanDescription p2);
    JsonDeserializer<? extends Object> findCollectionDeserializer(CollectionType p0, DeserializationConfig p1, BeanDescription p2, TypeDeserializer p3, JsonDeserializer<? extends Object> p4);
    JsonDeserializer<? extends Object> findCollectionLikeDeserializer(CollectionLikeType p0, DeserializationConfig p1, BeanDescription p2, TypeDeserializer p3, JsonDeserializer<? extends Object> p4);
    JsonDeserializer<? extends Object> findEnumDeserializer(Class<? extends Object> p0, DeserializationConfig p1, BeanDescription p2);
    JsonDeserializer<? extends Object> findMapDeserializer(MapType p0, DeserializationConfig p1, BeanDescription p2, KeyDeserializer p3, TypeDeserializer p4, JsonDeserializer<? extends Object> p5);
    JsonDeserializer<? extends Object> findMapLikeDeserializer(MapLikeType p0, DeserializationConfig p1, BeanDescription p2, KeyDeserializer p3, TypeDeserializer p4, JsonDeserializer<? extends Object> p5);
    JsonDeserializer<? extends Object> findReferenceDeserializer(ReferenceType p0, DeserializationConfig p1, BeanDescription p2, TypeDeserializer p3, JsonDeserializer<? extends Object> p4);
    JsonDeserializer<? extends Object> findTreeNodeDeserializer(Class<? extends JsonNode> p0, DeserializationConfig p1, BeanDescription p2);
}
