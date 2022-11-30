// Generated automatically from com.fasterxml.jackson.databind.jsontype.TypeDeserializer for testing purposes

package com.fasterxml.jackson.databind.jsontype;

import com.fasterxml.jackson.annotation.JsonTypeInfo;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.BeanProperty;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.jsontype.TypeIdResolver;

abstract public class TypeDeserializer
{
    public TypeDeserializer(){}
    public abstract Class<? extends Object> getDefaultImpl();
    public abstract JsonTypeInfo.As getTypeInclusion();
    public abstract Object deserializeTypedFromAny(JsonParser p0, DeserializationContext p1);
    public abstract Object deserializeTypedFromArray(JsonParser p0, DeserializationContext p1);
    public abstract Object deserializeTypedFromObject(JsonParser p0, DeserializationContext p1);
    public abstract Object deserializeTypedFromScalar(JsonParser p0, DeserializationContext p1);
    public abstract String getPropertyName();
    public abstract TypeDeserializer forProperty(BeanProperty p0);
    public abstract TypeIdResolver getTypeIdResolver();
    public static Object deserializeIfNatural(JsonParser p0, DeserializationContext p1, Class<? extends Object> p2){ return null; }
    public static Object deserializeIfNatural(JsonParser p0, DeserializationContext p1, JavaType p2){ return null; }
}
