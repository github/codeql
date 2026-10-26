// Generated automatically from com.fasterxml.jackson.databind.jsonschema.SchemaAware for testing purposes

package com.fasterxml.jackson.databind.jsonschema;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.SerializerProvider;
import java.lang.reflect.Type;

public interface SchemaAware
{
    JsonNode getSchema(SerializerProvider p0, Type p1);
    JsonNode getSchema(SerializerProvider p0, Type p1, boolean p2);
}
