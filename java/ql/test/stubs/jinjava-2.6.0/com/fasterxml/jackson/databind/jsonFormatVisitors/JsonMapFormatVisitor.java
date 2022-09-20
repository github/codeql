// Generated automatically from com.fasterxml.jackson.databind.jsonFormatVisitors.JsonMapFormatVisitor for testing purposes

package com.fasterxml.jackson.databind.jsonFormatVisitors;

import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.jsonFormatVisitors.JsonFormatVisitable;
import com.fasterxml.jackson.databind.jsonFormatVisitors.JsonFormatVisitorWithSerializerProvider;

public interface JsonMapFormatVisitor extends JsonFormatVisitorWithSerializerProvider
{
    void keyFormat(JsonFormatVisitable p0, JavaType p1);
    void valueFormat(JsonFormatVisitable p0, JavaType p1);
}
