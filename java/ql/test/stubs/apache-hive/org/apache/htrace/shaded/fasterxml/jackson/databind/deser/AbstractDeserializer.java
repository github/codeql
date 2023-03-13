// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.deser.AbstractDeserializer for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.deser;

import java.io.Serializable;
import java.util.Map;
import org.apache.htrace.shaded.fasterxml.jackson.core.JsonParser;
import org.apache.htrace.shaded.fasterxml.jackson.databind.BeanDescription;
import org.apache.htrace.shaded.fasterxml.jackson.databind.DeserializationContext;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JavaType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JsonDeserializer;
import org.apache.htrace.shaded.fasterxml.jackson.databind.deser.BeanDeserializerBuilder;
import org.apache.htrace.shaded.fasterxml.jackson.databind.deser.SettableBeanProperty;
import org.apache.htrace.shaded.fasterxml.jackson.databind.deser.impl.ObjectIdReader;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsontype.TypeDeserializer;

public class AbstractDeserializer extends JsonDeserializer<Object> implements Serializable
{
    protected AbstractDeserializer() {}
    protected AbstractDeserializer(BeanDescription p0){}
    protected Object _deserializeFromObjectId(JsonParser p0, DeserializationContext p1){ return null; }
    protected Object _deserializeIfNatural(JsonParser p0, DeserializationContext p1){ return null; }
    protected final JavaType _baseType = null;
    protected final Map<String, SettableBeanProperty> _backRefProperties = null;
    protected final ObjectIdReader _objectIdReader = null;
    protected final boolean _acceptBoolean = false;
    protected final boolean _acceptDouble = false;
    protected final boolean _acceptInt = false;
    protected final boolean _acceptString = false;
    public AbstractDeserializer(BeanDeserializerBuilder p0, BeanDescription p1, Map<String, SettableBeanProperty> p2){}
    public Class<? extends Object> handledType(){ return null; }
    public Object deserialize(JsonParser p0, DeserializationContext p1){ return null; }
    public Object deserializeWithType(JsonParser p0, DeserializationContext p1, TypeDeserializer p2){ return null; }
    public ObjectIdReader getObjectIdReader(){ return null; }
    public SettableBeanProperty findBackReference(String p0){ return null; }
    public boolean isCachable(){ return false; }
    public static AbstractDeserializer constructForNonPOJO(BeanDescription p0){ return null; }
}
