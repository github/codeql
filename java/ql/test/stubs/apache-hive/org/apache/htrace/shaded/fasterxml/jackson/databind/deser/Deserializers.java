// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.deser.Deserializers for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.deser;

import org.apache.htrace.shaded.fasterxml.jackson.databind.BeanDescription;
import org.apache.htrace.shaded.fasterxml.jackson.databind.DeserializationConfig;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JavaType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JsonDeserializer;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JsonNode;
import org.apache.htrace.shaded.fasterxml.jackson.databind.KeyDeserializer;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsontype.TypeDeserializer;
import org.apache.htrace.shaded.fasterxml.jackson.databind.type.ArrayType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.type.CollectionLikeType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.type.CollectionType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.type.MapLikeType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.type.MapType;

public interface Deserializers
{
    JsonDeserializer<? extends Object> findArrayDeserializer(ArrayType p0, DeserializationConfig p1, BeanDescription p2, TypeDeserializer p3, JsonDeserializer<? extends Object> p4);
    JsonDeserializer<? extends Object> findBeanDeserializer(JavaType p0, DeserializationConfig p1, BeanDescription p2);
    JsonDeserializer<? extends Object> findCollectionDeserializer(CollectionType p0, DeserializationConfig p1, BeanDescription p2, TypeDeserializer p3, JsonDeserializer<? extends Object> p4);
    JsonDeserializer<? extends Object> findCollectionLikeDeserializer(CollectionLikeType p0, DeserializationConfig p1, BeanDescription p2, TypeDeserializer p3, JsonDeserializer<? extends Object> p4);
    JsonDeserializer<? extends Object> findEnumDeserializer(Class<? extends Object> p0, DeserializationConfig p1, BeanDescription p2);
    JsonDeserializer<? extends Object> findMapDeserializer(MapType p0, DeserializationConfig p1, BeanDescription p2, KeyDeserializer p3, TypeDeserializer p4, JsonDeserializer<? extends Object> p5);
    JsonDeserializer<? extends Object> findMapLikeDeserializer(MapLikeType p0, DeserializationConfig p1, BeanDescription p2, KeyDeserializer p3, TypeDeserializer p4, JsonDeserializer<? extends Object> p5);
    JsonDeserializer<? extends Object> findTreeNodeDeserializer(Class<? extends JsonNode> p0, DeserializationConfig p1, BeanDescription p2);
}
