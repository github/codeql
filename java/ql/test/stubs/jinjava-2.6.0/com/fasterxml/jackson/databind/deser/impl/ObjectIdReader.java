// Generated automatically from com.fasterxml.jackson.databind.deser.impl.ObjectIdReader for testing purposes

package com.fasterxml.jackson.databind.deser.impl;

import com.fasterxml.jackson.annotation.ObjectIdGenerator;
import com.fasterxml.jackson.annotation.ObjectIdResolver;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.fasterxml.jackson.databind.PropertyName;
import com.fasterxml.jackson.databind.deser.SettableBeanProperty;
import java.io.Serializable;

public class ObjectIdReader implements Serializable
{
    protected ObjectIdReader() {}
    protected ObjectIdReader(JavaType p0, PropertyName p1, ObjectIdGenerator<? extends Object> p2, JsonDeserializer<? extends Object> p3, SettableBeanProperty p4){}
    protected ObjectIdReader(JavaType p0, PropertyName p1, ObjectIdGenerator<? extends Object> p2, JsonDeserializer<? extends Object> p3, SettableBeanProperty p4, ObjectIdResolver p5){}
    protected final JavaType _idType = null;
    protected final JsonDeserializer<Object> _deserializer = null;
    public JavaType getIdType(){ return null; }
    public JsonDeserializer<Object> getDeserializer(){ return null; }
    public Object readObjectReference(JsonParser p0, DeserializationContext p1){ return null; }
    public boolean isValidReferencePropertyName(String p0, JsonParser p1){ return false; }
    public boolean maySerializeAsObject(){ return false; }
    public final ObjectIdGenerator<? extends Object> generator = null;
    public final ObjectIdResolver resolver = null;
    public final PropertyName propertyName = null;
    public final SettableBeanProperty idProperty = null;
    public static ObjectIdReader construct(JavaType p0, PropertyName p1, ObjectIdGenerator<? extends Object> p2, JsonDeserializer<? extends Object> p3, SettableBeanProperty p4){ return null; }
    public static ObjectIdReader construct(JavaType p0, PropertyName p1, ObjectIdGenerator<? extends Object> p2, JsonDeserializer<? extends Object> p3, SettableBeanProperty p4, ObjectIdResolver p5){ return null; }
}
