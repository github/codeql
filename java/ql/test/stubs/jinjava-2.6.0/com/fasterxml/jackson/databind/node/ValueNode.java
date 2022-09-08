// Generated automatically from com.fasterxml.jackson.databind.node.ValueNode for testing purposes

package com.fasterxml.jackson.databind.node;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.core.JsonPointer;
import com.fasterxml.jackson.core.JsonToken;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.jsontype.TypeSerializer;
import com.fasterxml.jackson.databind.node.BaseJsonNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import java.util.List;

abstract public class ValueNode extends BaseJsonNode
{
    protected JsonNode _at(JsonPointer p0){ return null; }
    protected ValueNode(){}
    public <T extends JsonNode> T deepCopy(){ return null; }
    public String toString(){ return null; }
    public abstract JsonToken asToken();
    public final JsonNode findValue(String p0){ return null; }
    public final JsonNode get(String p0){ return null; }
    public final JsonNode get(int p0){ return null; }
    public final JsonNode path(String p0){ return null; }
    public final JsonNode path(int p0){ return null; }
    public final List<JsonNode> findParents(String p0, List<JsonNode> p1){ return null; }
    public final List<JsonNode> findValues(String p0, List<JsonNode> p1){ return null; }
    public final List<String> findValuesAsText(String p0, List<String> p1){ return null; }
    public final ObjectNode findParent(String p0){ return null; }
    public final boolean has(String p0){ return false; }
    public final boolean has(int p0){ return false; }
    public final boolean hasNonNull(String p0){ return false; }
    public final boolean hasNonNull(int p0){ return false; }
    public void serializeWithType(JsonGenerator p0, SerializerProvider p1, TypeSerializer p2){}
}
