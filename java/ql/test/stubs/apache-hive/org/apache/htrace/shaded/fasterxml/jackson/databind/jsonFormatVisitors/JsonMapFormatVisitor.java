// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.jsonFormatVisitors.JsonMapFormatVisitor for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.jsonFormatVisitors;

import org.apache.htrace.shaded.fasterxml.jackson.databind.JavaType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsonFormatVisitors.JsonFormatVisitable;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsonFormatVisitors.JsonFormatVisitorWithSerializerProvider;

public interface JsonMapFormatVisitor extends JsonFormatVisitorWithSerializerProvider
{
    void keyFormat(JsonFormatVisitable p0, JavaType p1);
    void valueFormat(JsonFormatVisitable p0, JavaType p1);
}
