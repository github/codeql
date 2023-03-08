// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.JsonSerializable for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind;

import org.apache.htrace.shaded.fasterxml.jackson.core.JsonGenerator;
import org.apache.htrace.shaded.fasterxml.jackson.databind.SerializerProvider;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsontype.TypeSerializer;

public interface JsonSerializable
{
    void serialize(JsonGenerator p0, SerializerProvider p1);
    void serializeWithType(JsonGenerator p0, SerializerProvider p1, TypeSerializer p2);
}
