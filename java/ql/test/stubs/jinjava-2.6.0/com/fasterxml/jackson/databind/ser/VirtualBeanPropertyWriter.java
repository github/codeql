// Generated automatically from com.fasterxml.jackson.databind.ser.VirtualBeanPropertyWriter for testing purposes

package com.fasterxml.jackson.databind.ser;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.PropertyName;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.cfg.MapperConfig;
import com.fasterxml.jackson.databind.introspect.AnnotatedClass;
import com.fasterxml.jackson.databind.introspect.BeanPropertyDefinition;
import com.fasterxml.jackson.databind.jsontype.TypeSerializer;
import com.fasterxml.jackson.databind.ser.BeanPropertyWriter;
import com.fasterxml.jackson.databind.util.Annotations;
import java.io.Serializable;

abstract public class VirtualBeanPropertyWriter extends BeanPropertyWriter implements Serializable
{
    protected VirtualBeanPropertyWriter(){}
    protected VirtualBeanPropertyWriter(BeanPropertyDefinition p0, Annotations p1, JavaType p2){}
    protected VirtualBeanPropertyWriter(BeanPropertyDefinition p0, Annotations p1, JavaType p2, JsonSerializer<? extends Object> p3, TypeSerializer p4, JavaType p5, JsonInclude.Value p6){}
    protected VirtualBeanPropertyWriter(VirtualBeanPropertyWriter p0){}
    protected VirtualBeanPropertyWriter(VirtualBeanPropertyWriter p0, PropertyName p1){}
    protected abstract Object value(Object p0, JsonGenerator p1, SerializerProvider p2);
    protected static Object _suppressableValue(JsonInclude.Value p0){ return null; }
    protected static boolean _suppressNulls(JsonInclude.Value p0){ return false; }
    public abstract VirtualBeanPropertyWriter withConfig(MapperConfig<? extends Object> p0, AnnotatedClass p1, BeanPropertyDefinition p2, JavaType p3);
    public boolean isVirtual(){ return false; }
    public void serializeAsElement(Object p0, JsonGenerator p1, SerializerProvider p2){}
    public void serializeAsField(Object p0, JsonGenerator p1, SerializerProvider p2){}
}
