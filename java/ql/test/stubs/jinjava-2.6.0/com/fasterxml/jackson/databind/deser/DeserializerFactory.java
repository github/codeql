// Generated automatically from com.fasterxml.jackson.databind.deser.DeserializerFactory for testing purposes

package com.fasterxml.jackson.databind.deser;

import com.fasterxml.jackson.databind.AbstractTypeResolver;
import com.fasterxml.jackson.databind.BeanDescription;
import com.fasterxml.jackson.databind.DeserializationConfig;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.fasterxml.jackson.databind.KeyDeserializer;
import com.fasterxml.jackson.databind.deser.BeanDeserializerModifier;
import com.fasterxml.jackson.databind.deser.Deserializers;
import com.fasterxml.jackson.databind.deser.KeyDeserializers;
import com.fasterxml.jackson.databind.deser.ValueInstantiator;
import com.fasterxml.jackson.databind.deser.ValueInstantiators;
import com.fasterxml.jackson.databind.jsontype.TypeDeserializer;
import com.fasterxml.jackson.databind.type.ArrayType;
import com.fasterxml.jackson.databind.type.CollectionLikeType;
import com.fasterxml.jackson.databind.type.CollectionType;
import com.fasterxml.jackson.databind.type.MapLikeType;
import com.fasterxml.jackson.databind.type.MapType;
import com.fasterxml.jackson.databind.type.ReferenceType;

abstract public class DeserializerFactory
{
    protected static Deserializers[] NO_DESERIALIZERS = null;
    public DeserializerFactory(){}
    public abstract DeserializerFactory withAbstractTypeResolver(AbstractTypeResolver p0);
    public abstract DeserializerFactory withAdditionalDeserializers(Deserializers p0);
    public abstract DeserializerFactory withAdditionalKeyDeserializers(KeyDeserializers p0);
    public abstract DeserializerFactory withDeserializerModifier(BeanDeserializerModifier p0);
    public abstract DeserializerFactory withValueInstantiators(ValueInstantiators p0);
    public abstract JavaType mapAbstractType(DeserializationConfig p0, JavaType p1);
    public abstract JsonDeserializer<? extends Object> createArrayDeserializer(DeserializationContext p0, ArrayType p1, BeanDescription p2);
    public abstract JsonDeserializer<? extends Object> createCollectionDeserializer(DeserializationContext p0, CollectionType p1, BeanDescription p2);
    public abstract JsonDeserializer<? extends Object> createCollectionLikeDeserializer(DeserializationContext p0, CollectionLikeType p1, BeanDescription p2);
    public abstract JsonDeserializer<? extends Object> createEnumDeserializer(DeserializationContext p0, JavaType p1, BeanDescription p2);
    public abstract JsonDeserializer<? extends Object> createMapDeserializer(DeserializationContext p0, MapType p1, BeanDescription p2);
    public abstract JsonDeserializer<? extends Object> createMapLikeDeserializer(DeserializationContext p0, MapLikeType p1, BeanDescription p2);
    public abstract JsonDeserializer<? extends Object> createReferenceDeserializer(DeserializationContext p0, ReferenceType p1, BeanDescription p2);
    public abstract JsonDeserializer<? extends Object> createTreeDeserializer(DeserializationConfig p0, JavaType p1, BeanDescription p2);
    public abstract JsonDeserializer<Object> createBeanDeserializer(DeserializationContext p0, JavaType p1, BeanDescription p2);
    public abstract JsonDeserializer<Object> createBuilderBasedDeserializer(DeserializationContext p0, JavaType p1, BeanDescription p2, Class<? extends Object> p3);
    public abstract KeyDeserializer createKeyDeserializer(DeserializationContext p0, JavaType p1);
    public abstract TypeDeserializer findTypeDeserializer(DeserializationConfig p0, JavaType p1);
    public abstract ValueInstantiator findValueInstantiator(DeserializationContext p0, BeanDescription p1);
}
