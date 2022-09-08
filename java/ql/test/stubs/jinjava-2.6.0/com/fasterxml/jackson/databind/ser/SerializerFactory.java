// Generated automatically from com.fasterxml.jackson.databind.ser.SerializerFactory for testing purposes

package com.fasterxml.jackson.databind.ser;

import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializationConfig;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.jsontype.TypeSerializer;
import com.fasterxml.jackson.databind.ser.BeanSerializerModifier;
import com.fasterxml.jackson.databind.ser.Serializers;

abstract public class SerializerFactory
{
    public SerializerFactory(){}
    public abstract JsonSerializer<Object> createKeySerializer(SerializationConfig p0, JavaType p1, JsonSerializer<Object> p2);
    public abstract JsonSerializer<Object> createSerializer(SerializerProvider p0, JavaType p1);
    public abstract SerializerFactory withAdditionalKeySerializers(Serializers p0);
    public abstract SerializerFactory withAdditionalSerializers(Serializers p0);
    public abstract SerializerFactory withSerializerModifier(BeanSerializerModifier p0);
    public abstract TypeSerializer createTypeSerializer(SerializationConfig p0, JavaType p1);
}
