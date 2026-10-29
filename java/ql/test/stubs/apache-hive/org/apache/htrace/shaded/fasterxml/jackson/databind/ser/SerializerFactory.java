// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.ser.SerializerFactory for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.ser;

import org.apache.htrace.shaded.fasterxml.jackson.databind.JavaType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JsonSerializer;
import org.apache.htrace.shaded.fasterxml.jackson.databind.SerializationConfig;
import org.apache.htrace.shaded.fasterxml.jackson.databind.SerializerProvider;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsontype.TypeSerializer;
import org.apache.htrace.shaded.fasterxml.jackson.databind.ser.BeanSerializerModifier;
import org.apache.htrace.shaded.fasterxml.jackson.databind.ser.Serializers;

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
