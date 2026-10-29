// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.ser.BeanSerializerModifier for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.ser;

import java.util.List;
import org.apache.htrace.shaded.fasterxml.jackson.databind.BeanDescription;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JavaType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JsonSerializer;
import org.apache.htrace.shaded.fasterxml.jackson.databind.SerializationConfig;
import org.apache.htrace.shaded.fasterxml.jackson.databind.ser.BeanPropertyWriter;
import org.apache.htrace.shaded.fasterxml.jackson.databind.ser.BeanSerializerBuilder;
import org.apache.htrace.shaded.fasterxml.jackson.databind.type.ArrayType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.type.CollectionLikeType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.type.CollectionType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.type.MapLikeType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.type.MapType;

abstract public class BeanSerializerModifier
{
    public BeanSerializerBuilder updateBuilder(SerializationConfig p0, BeanDescription p1, BeanSerializerBuilder p2){ return null; }
    public BeanSerializerModifier(){}
    public JsonSerializer<? extends Object> modifyArraySerializer(SerializationConfig p0, ArrayType p1, BeanDescription p2, JsonSerializer<? extends Object> p3){ return null; }
    public JsonSerializer<? extends Object> modifyCollectionLikeSerializer(SerializationConfig p0, CollectionLikeType p1, BeanDescription p2, JsonSerializer<? extends Object> p3){ return null; }
    public JsonSerializer<? extends Object> modifyCollectionSerializer(SerializationConfig p0, CollectionType p1, BeanDescription p2, JsonSerializer<? extends Object> p3){ return null; }
    public JsonSerializer<? extends Object> modifyEnumSerializer(SerializationConfig p0, JavaType p1, BeanDescription p2, JsonSerializer<? extends Object> p3){ return null; }
    public JsonSerializer<? extends Object> modifyKeySerializer(SerializationConfig p0, JavaType p1, BeanDescription p2, JsonSerializer<? extends Object> p3){ return null; }
    public JsonSerializer<? extends Object> modifyMapLikeSerializer(SerializationConfig p0, MapLikeType p1, BeanDescription p2, JsonSerializer<? extends Object> p3){ return null; }
    public JsonSerializer<? extends Object> modifyMapSerializer(SerializationConfig p0, MapType p1, BeanDescription p2, JsonSerializer<? extends Object> p3){ return null; }
    public JsonSerializer<? extends Object> modifySerializer(SerializationConfig p0, BeanDescription p1, JsonSerializer<? extends Object> p2){ return null; }
    public List<BeanPropertyWriter> changeProperties(SerializationConfig p0, BeanDescription p1, List<BeanPropertyWriter> p2){ return null; }
    public List<BeanPropertyWriter> orderProperties(SerializationConfig p0, BeanDescription p1, List<BeanPropertyWriter> p2){ return null; }
}
