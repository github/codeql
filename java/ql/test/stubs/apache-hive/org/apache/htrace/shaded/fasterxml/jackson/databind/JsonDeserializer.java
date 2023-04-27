// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.JsonDeserializer for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind;

import java.util.Collection;
import org.apache.htrace.shaded.fasterxml.jackson.core.JsonParser;
import org.apache.htrace.shaded.fasterxml.jackson.databind.DeserializationContext;
import org.apache.htrace.shaded.fasterxml.jackson.databind.deser.SettableBeanProperty;
import org.apache.htrace.shaded.fasterxml.jackson.databind.deser.impl.ObjectIdReader;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsontype.TypeDeserializer;
import org.apache.htrace.shaded.fasterxml.jackson.databind.util.NameTransformer;

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
    public T getNullValue(){ return null; }
    public abstract T deserialize(JsonParser p0, DeserializationContext p1);
    public boolean isCachable(){ return false; }
}
