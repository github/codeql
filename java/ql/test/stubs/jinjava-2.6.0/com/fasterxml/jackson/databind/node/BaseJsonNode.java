// Generated automatically from com.fasterxml.jackson.databind.node.BaseJsonNode for testing purposes

package com.fasterxml.jackson.databind.node;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.JsonToken;
import com.fasterxml.jackson.core.ObjectCodec;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.JsonSerializable;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.jsontype.TypeSerializer;

abstract public class BaseJsonNode extends JsonNode implements JsonSerializable
{
    protected BaseJsonNode(){}
    public JsonParser traverse(){ return null; }
    public JsonParser traverse(ObjectCodec p0){ return null; }
    public JsonParser.NumberType numberType(){ return null; }
    public abstract JsonToken asToken();
    public abstract int hashCode();
    public abstract void serialize(JsonGenerator p0, SerializerProvider p1);
    public abstract void serializeWithType(JsonGenerator p0, SerializerProvider p1, TypeSerializer p2);
    public final JsonNode findPath(String p0){ return null; }
}
