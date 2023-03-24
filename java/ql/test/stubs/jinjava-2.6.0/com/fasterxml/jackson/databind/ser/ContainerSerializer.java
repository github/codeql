// Generated automatically from com.fasterxml.jackson.databind.ser.ContainerSerializer for testing purposes

package com.fasterxml.jackson.databind.ser;

import com.fasterxml.jackson.databind.BeanProperty;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.jsontype.TypeSerializer;
import com.fasterxml.jackson.databind.ser.std.StdSerializer;

abstract public class ContainerSerializer<T> extends StdSerializer<T>
{
    protected ContainerSerializer() {}
    protected ContainerSerializer(Class<? extends Object> p0, boolean p1){}
    protected ContainerSerializer(Class<T> p0){}
    protected ContainerSerializer(ContainerSerializer<? extends Object> p0){}
    protected ContainerSerializer(JavaType p0){}
    protected abstract ContainerSerializer<? extends Object> _withValueTypeSerializer(TypeSerializer p0);
    protected boolean hasContentTypeAnnotation(SerializerProvider p0, BeanProperty p1){ return false; }
    public ContainerSerializer<? extends Object> withValueTypeSerializer(TypeSerializer p0){ return null; }
    public abstract JavaType getContentType();
    public abstract JsonSerializer<? extends Object> getContentSerializer();
    public abstract boolean hasSingleElement(T p0);
    public boolean isEmpty(T p0){ return false; }
}
