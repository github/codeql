// Generated automatically from com.fasterxml.jackson.databind.ser.BeanPropertyFilter for testing purposes

package com.fasterxml.jackson.databind.ser;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.jsonFormatVisitors.JsonObjectFormatVisitor;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.fasterxml.jackson.databind.ser.BeanPropertyWriter;

public interface BeanPropertyFilter
{
    void depositSchemaProperty(BeanPropertyWriter p0, JsonObjectFormatVisitor p1, SerializerProvider p2);
    void depositSchemaProperty(BeanPropertyWriter p0, ObjectNode p1, SerializerProvider p2);
    void serializeAsField(Object p0, JsonGenerator p1, SerializerProvider p2, BeanPropertyWriter p3);
}
