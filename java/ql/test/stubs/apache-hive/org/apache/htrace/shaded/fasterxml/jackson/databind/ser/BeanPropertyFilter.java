// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.ser.BeanPropertyFilter for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.ser;

import org.apache.htrace.shaded.fasterxml.jackson.core.JsonGenerator;
import org.apache.htrace.shaded.fasterxml.jackson.databind.SerializerProvider;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsonFormatVisitors.JsonObjectFormatVisitor;
import org.apache.htrace.shaded.fasterxml.jackson.databind.node.ObjectNode;
import org.apache.htrace.shaded.fasterxml.jackson.databind.ser.BeanPropertyWriter;

public interface BeanPropertyFilter
{
    void depositSchemaProperty(BeanPropertyWriter p0, JsonObjectFormatVisitor p1, SerializerProvider p2);
    void depositSchemaProperty(BeanPropertyWriter p0, ObjectNode p1, SerializerProvider p2);
    void serializeAsField(Object p0, JsonGenerator p1, SerializerProvider p2, BeanPropertyWriter p3);
}
