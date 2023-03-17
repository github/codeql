// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.jsontype.TypeSerializer for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.jsontype;

import org.apache.htrace.shaded.fasterxml.jackson.annotation.JsonTypeInfo;
import org.apache.htrace.shaded.fasterxml.jackson.core.JsonGenerator;
import org.apache.htrace.shaded.fasterxml.jackson.databind.BeanProperty;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsontype.TypeIdResolver;

abstract public class TypeSerializer
{
    public TypeSerializer(){}
    public abstract JsonTypeInfo.As getTypeInclusion();
    public abstract String getPropertyName();
    public abstract TypeIdResolver getTypeIdResolver();
    public abstract TypeSerializer forProperty(BeanProperty p0);
    public abstract void writeCustomTypePrefixForArray(Object p0, JsonGenerator p1, String p2);
    public abstract void writeCustomTypePrefixForObject(Object p0, JsonGenerator p1, String p2);
    public abstract void writeCustomTypePrefixForScalar(Object p0, JsonGenerator p1, String p2);
    public abstract void writeCustomTypeSuffixForArray(Object p0, JsonGenerator p1, String p2);
    public abstract void writeCustomTypeSuffixForObject(Object p0, JsonGenerator p1, String p2);
    public abstract void writeCustomTypeSuffixForScalar(Object p0, JsonGenerator p1, String p2);
    public abstract void writeTypePrefixForArray(Object p0, JsonGenerator p1);
    public abstract void writeTypePrefixForObject(Object p0, JsonGenerator p1);
    public abstract void writeTypePrefixForScalar(Object p0, JsonGenerator p1);
    public abstract void writeTypeSuffixForArray(Object p0, JsonGenerator p1);
    public abstract void writeTypeSuffixForObject(Object p0, JsonGenerator p1);
    public abstract void writeTypeSuffixForScalar(Object p0, JsonGenerator p1);
    public void writeTypePrefixForArray(Object p0, JsonGenerator p1, Class<? extends Object> p2){}
    public void writeTypePrefixForObject(Object p0, JsonGenerator p1, Class<? extends Object> p2){}
    public void writeTypePrefixForScalar(Object p0, JsonGenerator p1, Class<? extends Object> p2){}
}
