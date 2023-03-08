// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.jsonFormatVisitors.JsonFormatVisitorWrapper for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.jsonFormatVisitors;

import org.apache.htrace.shaded.fasterxml.jackson.databind.JavaType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsonFormatVisitors.JsonAnyFormatVisitor;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsonFormatVisitors.JsonArrayFormatVisitor;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsonFormatVisitors.JsonBooleanFormatVisitor;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsonFormatVisitors.JsonFormatVisitorWithSerializerProvider;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsonFormatVisitors.JsonIntegerFormatVisitor;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsonFormatVisitors.JsonMapFormatVisitor;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsonFormatVisitors.JsonNullFormatVisitor;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsonFormatVisitors.JsonNumberFormatVisitor;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsonFormatVisitors.JsonObjectFormatVisitor;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsonFormatVisitors.JsonStringFormatVisitor;

public interface JsonFormatVisitorWrapper extends JsonFormatVisitorWithSerializerProvider
{
    JsonAnyFormatVisitor expectAnyFormat(JavaType p0);
    JsonArrayFormatVisitor expectArrayFormat(JavaType p0);
    JsonBooleanFormatVisitor expectBooleanFormat(JavaType p0);
    JsonIntegerFormatVisitor expectIntegerFormat(JavaType p0);
    JsonMapFormatVisitor expectMapFormat(JavaType p0);
    JsonNullFormatVisitor expectNullFormat(JavaType p0);
    JsonNumberFormatVisitor expectNumberFormat(JavaType p0);
    JsonObjectFormatVisitor expectObjectFormat(JavaType p0);
    JsonStringFormatVisitor expectStringFormat(JavaType p0);
}
