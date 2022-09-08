// Generated automatically from com.fasterxml.jackson.databind.ser.PropertyWriter for testing purposes

package com.fasterxml.jackson.databind.ser;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.PropertyMetadata;
import com.fasterxml.jackson.databind.PropertyName;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.introspect.BeanPropertyDefinition;
import com.fasterxml.jackson.databind.introspect.ConcreteBeanPropertyBase;
import com.fasterxml.jackson.databind.jsonFormatVisitors.JsonObjectFormatVisitor;
import com.fasterxml.jackson.databind.node.ObjectNode;
import java.io.Serializable;
import java.lang.annotation.Annotation;

abstract public class PropertyWriter extends ConcreteBeanPropertyBase implements Serializable
{
    protected PropertyWriter() {}
    protected PropertyWriter(BeanPropertyDefinition p0){}
    protected PropertyWriter(PropertyMetadata p0){}
    protected PropertyWriter(PropertyWriter p0){}
    public <A extends Annotation> A findAnnotation(Class<A> p0){ return null; }
    public abstract <A extends Annotation> A getAnnotation(Class<A> p0);
    public abstract <A extends Annotation> A getContextAnnotation(Class<A> p0);
    public abstract PropertyName getFullName();
    public abstract String getName();
    public abstract void depositSchemaProperty(JsonObjectFormatVisitor p0, SerializerProvider p1);
    public abstract void depositSchemaProperty(ObjectNode p0, SerializerProvider p1);
    public abstract void serializeAsElement(Object p0, JsonGenerator p1, SerializerProvider p2);
    public abstract void serializeAsField(Object p0, JsonGenerator p1, SerializerProvider p2);
    public abstract void serializeAsOmittedField(Object p0, JsonGenerator p1, SerializerProvider p2);
    public abstract void serializeAsPlaceholder(Object p0, JsonGenerator p1, SerializerProvider p2);
}
