// Generated automatically from com.fasterxml.jackson.databind.JsonDeserializer for testing purposes

package com.fasterxml.jackson.databind;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.deser.SettableBeanProperty;
import com.fasterxml.jackson.databind.deser.impl.ObjectIdReader;
import com.fasterxml.jackson.databind.jsontype.TypeDeserializer;
import com.fasterxml.jackson.databind.util.NameTransformer;
import java.util.Collection;

abstract public class JsonDeserializer<T>
{
    public Class<? extends Object> handledType(){ return null; }
    public Collection<Object> getKnownPropertyNames(){ return null; }
    public JsonDeserializer(){}
    public JsonDeserializer<? extends Object> getDelegatee(){ return null; }
    public JsonDeserializer<? extends Object> replaceDelegatee(JsonDeserializer<? extends Object> p0){ return null; }
    public JsonDeserializer<T> unwrappingDeserializer(NameTransformer p0){ return null; }
    public Object deserializeWithType(JsonParser p0, DeserializationContext p1, TypeDeserializer p2){ return null; }
    public ObjectIdReader getObjectIdReader(){ return null; }
    public SettableBeanProperty findBackReference(String p0){ return null; }
    public T deserialize(JsonParser p0, DeserializationContext p1, T p2){ return null; }
    public T getEmptyValue(){ return null; }
    public T getEmptyValue(DeserializationContext p0){ return null; }
    public T getNullValue(){ return null; }
    public T getNullValue(DeserializationContext p0){ return null; }
    public abstract T deserialize(JsonParser p0, DeserializationContext p1);
    public boolean isCachable(){ return false; }
}
