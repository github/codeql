// Generated automatically from com.fasterxml.jackson.databind.ser.BeanSerializer for testing purposes

package com.fasterxml.jackson.databind.ser;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.ser.BeanPropertyWriter;
import com.fasterxml.jackson.databind.ser.BeanSerializerBuilder;
import com.fasterxml.jackson.databind.ser.impl.ObjectIdWriter;
import com.fasterxml.jackson.databind.ser.std.BeanSerializerBase;
import com.fasterxml.jackson.databind.util.NameTransformer;

public class BeanSerializer extends BeanSerializerBase
{
    protected BeanSerializer() {}
    protected BeanSerializer(BeanSerializerBase p0){}
    protected BeanSerializer(BeanSerializerBase p0, ObjectIdWriter p1){}
    protected BeanSerializer(BeanSerializerBase p0, ObjectIdWriter p1, Object p2){}
    protected BeanSerializer(BeanSerializerBase p0, String[] p1){}
    protected BeanSerializerBase asArraySerializer(){ return null; }
    protected BeanSerializerBase withIgnorals(String[] p0){ return null; }
    public BeanSerializer(JavaType p0, BeanSerializerBuilder p1, BeanPropertyWriter[] p2, BeanPropertyWriter[] p3){}
    public BeanSerializerBase withFilterId(Object p0){ return null; }
    public BeanSerializerBase withObjectIdWriter(ObjectIdWriter p0){ return null; }
    public JsonSerializer<Object> unwrappingSerializer(NameTransformer p0){ return null; }
    public String toString(){ return null; }
    public final void serialize(Object p0, JsonGenerator p1, SerializerProvider p2){}
    public static BeanSerializer createDummy(JavaType p0){ return null; }
}
