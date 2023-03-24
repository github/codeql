// Generated automatically from com.fasterxml.jackson.databind.jsonFormatVisitors.JsonFormatVisitorWrapper for testing purposes

package com.fasterxml.jackson.databind.jsonFormatVisitors;

import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.jsonFormatVisitors.JsonAnyFormatVisitor;
import com.fasterxml.jackson.databind.jsonFormatVisitors.JsonArrayFormatVisitor;
import com.fasterxml.jackson.databind.jsonFormatVisitors.JsonBooleanFormatVisitor;
import com.fasterxml.jackson.databind.jsonFormatVisitors.JsonFormatVisitorWithSerializerProvider;
import com.fasterxml.jackson.databind.jsonFormatVisitors.JsonIntegerFormatVisitor;
import com.fasterxml.jackson.databind.jsonFormatVisitors.JsonMapFormatVisitor;
import com.fasterxml.jackson.databind.jsonFormatVisitors.JsonNullFormatVisitor;
import com.fasterxml.jackson.databind.jsonFormatVisitors.JsonNumberFormatVisitor;
import com.fasterxml.jackson.databind.jsonFormatVisitors.JsonObjectFormatVisitor;
import com.fasterxml.jackson.databind.jsonFormatVisitors.JsonStringFormatVisitor;

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
