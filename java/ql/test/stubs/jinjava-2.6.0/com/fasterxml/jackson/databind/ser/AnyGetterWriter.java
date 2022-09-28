// Generated automatically from com.fasterxml.jackson.databind.ser.AnyGetterWriter for testing purposes

package com.fasterxml.jackson.databind.ser;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.BeanProperty;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.introspect.AnnotatedMember;
import com.fasterxml.jackson.databind.ser.PropertyFilter;
import com.fasterxml.jackson.databind.ser.std.MapSerializer;

public class AnyGetterWriter
{
    protected AnyGetterWriter() {}
    protected JsonSerializer<Object> _serializer = null;
    protected MapSerializer _mapSerializer = null;
    protected final AnnotatedMember _accessor = null;
    protected final BeanProperty _property = null;
    public AnyGetterWriter(BeanProperty p0, AnnotatedMember p1, JsonSerializer<? extends Object> p2){}
    public void getAndFilter(Object p0, JsonGenerator p1, SerializerProvider p2, PropertyFilter p3){}
    public void getAndSerialize(Object p0, JsonGenerator p1, SerializerProvider p2){}
    public void resolve(SerializerProvider p0){}
}
