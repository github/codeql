// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.JsonNode for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind;

import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.apache.htrace.shaded.fasterxml.jackson.core.JsonPointer;
import org.apache.htrace.shaded.fasterxml.jackson.core.TreeNode;
import org.apache.htrace.shaded.fasterxml.jackson.databind.node.JsonNodeType;

abstract public class JsonNode implements Iterable<JsonNode>, TreeNode
{
    protected JsonNode(){}
    protected abstract JsonNode _at(JsonPointer p0);
    public BigDecimal decimalValue(){ return null; }
    public BigInteger bigIntegerValue(){ return null; }
    public Iterator<JsonNode> elements(){ return null; }
    public Iterator<Map.Entry<String, JsonNode>> fields(){ return null; }
    public Iterator<String> fieldNames(){ return null; }
    public JsonNode get(String p0){ return null; }
    public JsonNode with(String p0){ return null; }
    public JsonNode withArray(String p0){ return null; }
    public Number numberValue(){ return null; }
    public String asText(String p0){ return null; }
    public String textValue(){ return null; }
    public abstract <T extends JsonNode> T deepCopy();
    public abstract JsonNode findParent(String p0);
    public abstract JsonNode findPath(String p0);
    public abstract JsonNode findValue(String p0);
    public abstract JsonNode get(int p0);
    public abstract JsonNode path(String p0);
    public abstract JsonNode path(int p0);
    public abstract JsonNodeType getNodeType();
    public abstract List<JsonNode> findParents(String p0, List<JsonNode> p1);
    public abstract List<JsonNode> findValues(String p0, List<JsonNode> p1);
    public abstract List<String> findValuesAsText(String p0, List<String> p1);
    public abstract String asText();
    public abstract String toString();
    public abstract boolean equals(Object p0);
    public boolean asBoolean(){ return false; }
    public boolean asBoolean(boolean p0){ return false; }
    public boolean booleanValue(){ return false; }
    public boolean canConvertToInt(){ return false; }
    public boolean canConvertToLong(){ return false; }
    public boolean has(String p0){ return false; }
    public boolean has(int p0){ return false; }
    public boolean hasNonNull(String p0){ return false; }
    public boolean hasNonNull(int p0){ return false; }
    public boolean isBigDecimal(){ return false; }
    public boolean isBigInteger(){ return false; }
    public boolean isDouble(){ return false; }
    public boolean isFloat(){ return false; }
    public boolean isFloatingPointNumber(){ return false; }
    public boolean isInt(){ return false; }
    public boolean isIntegralNumber(){ return false; }
    public boolean isLong(){ return false; }
    public boolean isShort(){ return false; }
    public byte[] binaryValue(){ return null; }
    public double asDouble(){ return 0; }
    public double asDouble(double p0){ return 0; }
    public double doubleValue(){ return 0; }
    public final Iterator<JsonNode> iterator(){ return null; }
    public final JsonNode at(JsonPointer p0){ return null; }
    public final JsonNode at(String p0){ return null; }
    public final List<JsonNode> findParents(String p0){ return null; }
    public final List<JsonNode> findValues(String p0){ return null; }
    public final List<String> findValuesAsText(String p0){ return null; }
    public final boolean isArray(){ return false; }
    public final boolean isBinary(){ return false; }
    public final boolean isBoolean(){ return false; }
    public final boolean isContainerNode(){ return false; }
    public final boolean isMissingNode(){ return false; }
    public final boolean isNull(){ return false; }
    public final boolean isNumber(){ return false; }
    public final boolean isObject(){ return false; }
    public final boolean isPojo(){ return false; }
    public final boolean isTextual(){ return false; }
    public final boolean isValueNode(){ return false; }
    public float floatValue(){ return 0; }
    public int asInt(){ return 0; }
    public int asInt(int p0){ return 0; }
    public int intValue(){ return 0; }
    public int size(){ return 0; }
    public long asLong(){ return 0; }
    public long asLong(long p0){ return 0; }
    public long longValue(){ return 0; }
    public short shortValue(){ return 0; }
}
