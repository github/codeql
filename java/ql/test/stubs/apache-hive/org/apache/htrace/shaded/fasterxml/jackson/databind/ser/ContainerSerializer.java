// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.ser.ContainerSerializer for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.ser;

import org.apache.htrace.shaded.fasterxml.jackson.databind.BeanProperty;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JavaType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JsonSerializer;
import org.apache.htrace.shaded.fasterxml.jackson.databind.SerializerProvider;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsontype.TypeSerializer;
import org.apache.htrace.shaded.fasterxml.jackson.databind.ser.std.StdSerializer;

abstract public class ContainerSerializer<T> extends StdSerializer<T>
{
    protected ContainerSerializer() {}
    protected ContainerSerializer(Class<? extends Object> p0, boolean p1){}
    protected ContainerSerializer(ContainerSerializer<? extends Object> p0){}
    protected ContainerSerializer(java.lang.Class<T> p0){}
    protected abstract ContainerSerializer<? extends Object> _withValueTypeSerializer(TypeSerializer p0);
    protected boolean hasContentTypeAnnotation(SerializerProvider p0, BeanProperty p1){ return false; }
    public ContainerSerializer<? extends Object> withValueTypeSerializer(TypeSerializer p0){ return null; }
    public abstract JavaType getContentType();
    public abstract JsonSerializer<? extends Object> getContentSerializer();
    public abstract boolean hasSingleElement(T p0);
    public abstract boolean isEmpty(T p0);
}
