// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.jsonFormatVisitors.JsonArrayFormatVisitor for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.jsonFormatVisitors;

import org.apache.htrace.shaded.fasterxml.jackson.databind.JavaType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsonFormatVisitors.JsonFormatTypes;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsonFormatVisitors.JsonFormatVisitable;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsonFormatVisitors.JsonFormatVisitorWithSerializerProvider;

public interface JsonArrayFormatVisitor extends JsonFormatVisitorWithSerializerProvider
{
    void itemsFormat(JsonFormatTypes p0);
    void itemsFormat(JsonFormatVisitable p0, JavaType p1);
}
