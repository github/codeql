// Generated automatically from com.fasterxml.jackson.databind.ser.PropertyFilter for testing purposes

package com.fasterxml.jackson.databind.ser;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.jsonFormatVisitors.JsonObjectFormatVisitor;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.fasterxml.jackson.databind.ser.PropertyWriter;

public interface PropertyFilter
{
    void depositSchemaProperty(PropertyWriter p0, JsonObjectFormatVisitor p1, SerializerProvider p2);
    void depositSchemaProperty(PropertyWriter p0, ObjectNode p1, SerializerProvider p2);
    void serializeAsElement(Object p0, JsonGenerator p1, SerializerProvider p2, PropertyWriter p3);
    void serializeAsField(Object p0, JsonGenerator p1, SerializerProvider p2, PropertyWriter p3);
}
