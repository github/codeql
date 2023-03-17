// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.jsonschema.SchemaAware for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.jsonschema;

import java.lang.reflect.Type;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JsonNode;
import org.apache.htrace.shaded.fasterxml.jackson.databind.SerializerProvider;

public interface SchemaAware
{
    JsonNode getSchema(SerializerProvider p0, Type p1);
    JsonNode getSchema(SerializerProvider p0, Type p1, boolean p2);
}
