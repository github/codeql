// Generated automatically from com.fasterxml.jackson.databind.Module for testing purposes

package com.fasterxml.jackson.databind;

import com.fasterxml.jackson.core.JsonFactory;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.ObjectCodec;
import com.fasterxml.jackson.core.Version;
import com.fasterxml.jackson.core.Versioned;
import com.fasterxml.jackson.databind.AbstractTypeResolver;
import com.fasterxml.jackson.databind.AnnotationIntrospector;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.MapperFeature;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.databind.deser.BeanDeserializerModifier;
import com.fasterxml.jackson.databind.deser.DeserializationProblemHandler;
import com.fasterxml.jackson.databind.deser.Deserializers;
import com.fasterxml.jackson.databind.deser.KeyDeserializers;
import com.fasterxml.jackson.databind.deser.ValueInstantiators;
import com.fasterxml.jackson.databind.introspect.ClassIntrospector;
import com.fasterxml.jackson.databind.jsontype.NamedType;
import com.fasterxml.jackson.databind.ser.BeanSerializerModifier;
import com.fasterxml.jackson.databind.ser.Serializers;
import com.fasterxml.jackson.databind.type.TypeFactory;
import com.fasterxml.jackson.databind.type.TypeModifier;

abstract public class Module implements Versioned
{
    public Module(){}
    public Object getTypeId(){ return null; }
    public abstract String getModuleName();
    public abstract Version version();
    public abstract void setupModule(Module.SetupContext p0);
    static public interface SetupContext
    {
        <C extends ObjectCodec> C getOwner();
        TypeFactory getTypeFactory();
        Version getMapperVersion();
        boolean isEnabled(DeserializationFeature p0);
        boolean isEnabled(JsonFactory.Feature p0);
        boolean isEnabled(JsonGenerator.Feature p0);
        boolean isEnabled(JsonParser.Feature p0);
        boolean isEnabled(MapperFeature p0);
        boolean isEnabled(SerializationFeature p0);
        void addAbstractTypeResolver(AbstractTypeResolver p0);
        void addBeanDeserializerModifier(BeanDeserializerModifier p0);
        void addBeanSerializerModifier(BeanSerializerModifier p0);
        void addDeserializationProblemHandler(DeserializationProblemHandler p0);
        void addDeserializers(Deserializers p0);
        void addKeyDeserializers(KeyDeserializers p0);
        void addKeySerializers(Serializers p0);
        void addSerializers(Serializers p0);
        void addTypeModifier(TypeModifier p0);
        void addValueInstantiators(ValueInstantiators p0);
        void appendAnnotationIntrospector(AnnotationIntrospector p0);
        void insertAnnotationIntrospector(AnnotationIntrospector p0);
        void registerSubtypes(Class<? extends Object>... p0);
        void registerSubtypes(NamedType... p0);
        void setClassIntrospector(ClassIntrospector p0);
        void setMixInAnnotations(Class<? extends Object> p0, Class<? extends Object> p1);
        void setNamingStrategy(PropertyNamingStrategy p0);
    }
}
