// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.ser.PropertyWriter for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.ser;

import org.apache.htrace.shaded.fasterxml.jackson.core.JsonGenerator;
import org.apache.htrace.shaded.fasterxml.jackson.databind.PropertyName;
import org.apache.htrace.shaded.fasterxml.jackson.databind.SerializerProvider;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsonFormatVisitors.JsonObjectFormatVisitor;
import org.apache.htrace.shaded.fasterxml.jackson.databind.node.ObjectNode;

abstract public class PropertyWriter
{
    public PropertyWriter(){}
    public abstract PropertyName getFullName();
    public abstract String getName();
    public abstract void depositSchemaProperty(JsonObjectFormatVisitor p0);
    public abstract void depositSchemaProperty(ObjectNode p0, SerializerProvider p1);
    public abstract void serializeAsElement(Object p0, JsonGenerator p1, SerializerProvider p2);
    public abstract void serializeAsField(Object p0, JsonGenerator p1, SerializerProvider p2);
    public abstract void serializeAsOmittedField(Object p0, JsonGenerator p1, SerializerProvider p2);
    public abstract void serializeAsPlaceholder(Object p0, JsonGenerator p1, SerializerProvider p2);
}
