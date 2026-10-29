// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.ser.std.StdSerializer for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.ser.std;

import java.lang.reflect.Type;
import org.apache.htrace.shaded.fasterxml.jackson.core.JsonGenerator;
import org.apache.htrace.shaded.fasterxml.jackson.databind.BeanProperty;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JavaType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JsonNode;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JsonSerializer;
import org.apache.htrace.shaded.fasterxml.jackson.databind.SerializerProvider;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsonFormatVisitors.JsonFormatVisitable;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsonFormatVisitors.JsonFormatVisitorWrapper;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsonschema.SchemaAware;
import org.apache.htrace.shaded.fasterxml.jackson.databind.node.ObjectNode;
import org.apache.htrace.shaded.fasterxml.jackson.databind.ser.PropertyFilter;

abstract public class StdSerializer<T> extends org.apache.htrace.shaded.fasterxml.jackson.databind.JsonSerializer<T> implements JsonFormatVisitable, SchemaAware
{
    protected StdSerializer() {}
    protected JsonSerializer<? extends Object> findConvertingContentSerializer(SerializerProvider p0, BeanProperty p1, JsonSerializer<? extends Object> p2){ return null; }
    protected ObjectNode createObjectNode(){ return null; }
    protected ObjectNode createSchemaNode(String p0){ return null; }
    protected ObjectNode createSchemaNode(String p0, boolean p1){ return null; }
    protected PropertyFilter findPropertyFilter(SerializerProvider p0, Object p1, Object p2){ return null; }
    protected StdSerializer(Class<? extends Object> p0, boolean p1){}
    protected StdSerializer(JavaType p0){}
    protected StdSerializer(java.lang.Class<T> p0){}
    protected boolean isDefaultSerializer(JsonSerializer<? extends Object> p0){ return false; }
    protected final java.lang.Class<T> _handledType = null;
    public JsonNode getSchema(SerializerProvider p0, Type p1){ return null; }
    public JsonNode getSchema(SerializerProvider p0, Type p1, boolean p2){ return null; }
    public abstract void serialize(T p0, JsonGenerator p1, SerializerProvider p2);
    public java.lang.Class<T> handledType(){ return null; }
    public void acceptJsonFormatVisitor(JsonFormatVisitorWrapper p0, JavaType p1){}
    public void wrapAndThrow(SerializerProvider p0, Throwable p1, Object p2, String p3){}
    public void wrapAndThrow(SerializerProvider p0, Throwable p1, Object p2, int p3){}
}
