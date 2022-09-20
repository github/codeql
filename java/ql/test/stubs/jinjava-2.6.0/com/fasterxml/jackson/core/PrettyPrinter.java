// Generated automatically from com.fasterxml.jackson.core.PrettyPrinter for testing purposes

package com.fasterxml.jackson.core;

import com.fasterxml.jackson.core.JsonGenerator;

public interface PrettyPrinter
{
    void beforeArrayValues(JsonGenerator p0);
    void beforeObjectEntries(JsonGenerator p0);
    void writeArrayValueSeparator(JsonGenerator p0);
    void writeEndArray(JsonGenerator p0, int p1);
    void writeEndObject(JsonGenerator p0, int p1);
    void writeObjectEntrySeparator(JsonGenerator p0);
    void writeObjectFieldValueSeparator(JsonGenerator p0);
    void writeRootValueSeparator(JsonGenerator p0);
    void writeStartArray(JsonGenerator p0);
    void writeStartObject(JsonGenerator p0);
}
