// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.deser.BeanDeserializerModifier for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.deser;

import java.util.List;
import org.apache.htrace.shaded.fasterxml.jackson.databind.BeanDescription;
import org.apache.htrace.shaded.fasterxml.jackson.databind.DeserializationConfig;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JavaType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JsonDeserializer;
import org.apache.htrace.shaded.fasterxml.jackson.databind.KeyDeserializer;
import org.apache.htrace.shaded.fasterxml.jackson.databind.deser.BeanDeserializerBuilder;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.BeanPropertyDefinition;
import org.apache.htrace.shaded.fasterxml.jackson.databind.type.ArrayType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.type.CollectionLikeType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.type.CollectionType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.type.MapLikeType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.type.MapType;

abstract public class BeanDeserializerModifier
{
    public BeanDeserializerBuilder updateBuilder(DeserializationConfig p0, BeanDescription p1, BeanDeserializerBuilder p2){ return null; }
    public BeanDeserializerModifier(){}
    public JsonDeserializer<? extends Object> modifyArrayDeserializer(DeserializationConfig p0, ArrayType p1, BeanDescription p2, JsonDeserializer<? extends Object> p3){ return null; }
    public JsonDeserializer<? extends Object> modifyCollectionDeserializer(DeserializationConfig p0, CollectionType p1, BeanDescription p2, JsonDeserializer<? extends Object> p3){ return null; }
    public JsonDeserializer<? extends Object> modifyCollectionLikeDeserializer(DeserializationConfig p0, CollectionLikeType p1, BeanDescription p2, JsonDeserializer<? extends Object> p3){ return null; }
    public JsonDeserializer<? extends Object> modifyDeserializer(DeserializationConfig p0, BeanDescription p1, JsonDeserializer<? extends Object> p2){ return null; }
    public JsonDeserializer<? extends Object> modifyEnumDeserializer(DeserializationConfig p0, JavaType p1, BeanDescription p2, JsonDeserializer<? extends Object> p3){ return null; }
    public JsonDeserializer<? extends Object> modifyMapDeserializer(DeserializationConfig p0, MapType p1, BeanDescription p2, JsonDeserializer<? extends Object> p3){ return null; }
    public JsonDeserializer<? extends Object> modifyMapLikeDeserializer(DeserializationConfig p0, MapLikeType p1, BeanDescription p2, JsonDeserializer<? extends Object> p3){ return null; }
    public KeyDeserializer modifyKeyDeserializer(DeserializationConfig p0, JavaType p1, KeyDeserializer p2){ return null; }
    public List<BeanPropertyDefinition> updateProperties(DeserializationConfig p0, BeanDescription p1, List<BeanPropertyDefinition> p2){ return null; }
}
