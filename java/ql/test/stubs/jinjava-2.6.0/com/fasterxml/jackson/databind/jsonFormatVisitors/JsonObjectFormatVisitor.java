// Generated automatically from com.fasterxml.jackson.databind.jsonFormatVisitors.JsonObjectFormatVisitor for testing purposes

package com.fasterxml.jackson.databind.jsonFormatVisitors;

import com.fasterxml.jackson.databind.BeanProperty;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.jsonFormatVisitors.JsonFormatVisitable;
import com.fasterxml.jackson.databind.jsonFormatVisitors.JsonFormatVisitorWithSerializerProvider;

public interface JsonObjectFormatVisitor extends JsonFormatVisitorWithSerializerProvider
{
    void optionalProperty(BeanProperty p0);
    void optionalProperty(String p0, JsonFormatVisitable p1, JavaType p2);
    void property(BeanProperty p0);
    void property(String p0, JsonFormatVisitable p1, JavaType p2);
}
