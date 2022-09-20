// Generated automatically from com.fasterxml.jackson.databind.jsonFormatVisitors.JsonArrayFormatVisitor for testing purposes

package com.fasterxml.jackson.databind.jsonFormatVisitors;

import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.jsonFormatVisitors.JsonFormatTypes;
import com.fasterxml.jackson.databind.jsonFormatVisitors.JsonFormatVisitable;
import com.fasterxml.jackson.databind.jsonFormatVisitors.JsonFormatVisitorWithSerializerProvider;

public interface JsonArrayFormatVisitor extends JsonFormatVisitorWithSerializerProvider
{
    void itemsFormat(JsonFormatTypes p0);
    void itemsFormat(JsonFormatVisitable p0, JavaType p1);
}
