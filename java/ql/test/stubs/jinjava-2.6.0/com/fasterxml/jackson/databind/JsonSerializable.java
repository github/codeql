// Generated automatically from com.fasterxml.jackson.databind.JsonSerializable for testing purposes

package com.fasterxml.jackson.databind;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.jsontype.TypeSerializer;

public interface JsonSerializable
{
    abstract static public class Base implements JsonSerializable
    {
        public Base(){}
        public boolean isEmpty(SerializerProvider p0){ return false; }
    }
    void serialize(JsonGenerator p0, SerializerProvider p1);
    void serializeWithType(JsonGenerator p0, SerializerProvider p1, TypeSerializer p2);
}
