// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.jsontype.TypeDeserializer for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.jsontype;

import org.apache.htrace.shaded.fasterxml.jackson.annotation.JsonTypeInfo;
import org.apache.htrace.shaded.fasterxml.jackson.core.JsonParser;
import org.apache.htrace.shaded.fasterxml.jackson.databind.BeanProperty;
import org.apache.htrace.shaded.fasterxml.jackson.databind.DeserializationContext;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JavaType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsontype.TypeIdResolver;

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
