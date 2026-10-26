// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.node.BaseJsonNode for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.node;

import org.apache.htrace.shaded.fasterxml.jackson.core.JsonGenerator;
import org.apache.htrace.shaded.fasterxml.jackson.core.JsonParser;
import org.apache.htrace.shaded.fasterxml.jackson.core.JsonToken;
import org.apache.htrace.shaded.fasterxml.jackson.core.ObjectCodec;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JsonNode;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JsonSerializable;
import org.apache.htrace.shaded.fasterxml.jackson.databind.SerializerProvider;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsontype.TypeSerializer;

abstract public class BaseJsonNode extends JsonNode implements JsonSerializable
{
    protected BaseJsonNode(){}
    public JsonParser traverse(){ return null; }
    public JsonParser traverse(ObjectCodec p0){ return null; }
    public JsonParser.NumberType numberType(){ return null; }
    public abstract JsonToken asToken();
    public abstract void serialize(JsonGenerator p0, SerializerProvider p1);
    public abstract void serializeWithType(JsonGenerator p0, SerializerProvider p1, TypeSerializer p2);
    public final JsonNode findPath(String p0){ return null; }
}
