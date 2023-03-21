// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.node.ContainerNode for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.node;

import java.math.BigDecimal;
import java.math.BigInteger;
import org.apache.htrace.shaded.fasterxml.jackson.core.JsonToken;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JsonNode;
import org.apache.htrace.shaded.fasterxml.jackson.databind.node.ArrayNode;
import org.apache.htrace.shaded.fasterxml.jackson.databind.node.BaseJsonNode;
import org.apache.htrace.shaded.fasterxml.jackson.databind.node.BinaryNode;
import org.apache.htrace.shaded.fasterxml.jackson.databind.node.BooleanNode;
import org.apache.htrace.shaded.fasterxml.jackson.databind.node.JsonNodeCreator;
import org.apache.htrace.shaded.fasterxml.jackson.databind.node.JsonNodeFactory;
import org.apache.htrace.shaded.fasterxml.jackson.databind.node.NullNode;
import org.apache.htrace.shaded.fasterxml.jackson.databind.node.NumericNode;
import org.apache.htrace.shaded.fasterxml.jackson.databind.node.ObjectNode;
import org.apache.htrace.shaded.fasterxml.jackson.databind.node.POJONode;
import org.apache.htrace.shaded.fasterxml.jackson.databind.node.TextNode;
import org.apache.htrace.shaded.fasterxml.jackson.databind.node.ValueNode;

abstract public class ContainerNode<T extends ContainerNode<T>> extends BaseJsonNode implements JsonNodeCreator
{
    protected ContainerNode() {}
    protected ContainerNode(JsonNodeFactory p0){}
    protected final JsonNodeFactory _nodeFactory = null;
    public String asText(){ return null; }
    public abstract JsonNode get(String p0);
    public abstract JsonNode get(int p0);
    public abstract JsonToken asToken();
    public abstract T removeAll();
    public abstract int size();
    public final ArrayNode arrayNode(){ return null; }
    public final BinaryNode binaryNode(byte[] p0){ return null; }
    public final BinaryNode binaryNode(byte[] p0, int p1, int p2){ return null; }
    public final BooleanNode booleanNode(boolean p0){ return null; }
    public final NullNode nullNode(){ return null; }
    public final NumericNode numberNode(BigDecimal p0){ return null; }
    public final NumericNode numberNode(BigInteger p0){ return null; }
    public final NumericNode numberNode(byte p0){ return null; }
    public final NumericNode numberNode(double p0){ return null; }
    public final NumericNode numberNode(float p0){ return null; }
    public final NumericNode numberNode(int p0){ return null; }
    public final NumericNode numberNode(long p0){ return null; }
    public final NumericNode numberNode(short p0){ return null; }
    public final ObjectNode objectNode(){ return null; }
    public final POJONode POJONode(Object p0){ return null; }
    public final TextNode textNode(String p0){ return null; }
    public final ValueNode numberNode(Byte p0){ return null; }
    public final ValueNode numberNode(Double p0){ return null; }
    public final ValueNode numberNode(Float p0){ return null; }
    public final ValueNode numberNode(Integer p0){ return null; }
    public final ValueNode numberNode(Long p0){ return null; }
    public final ValueNode numberNode(Short p0){ return null; }
    public final ValueNode pojoNode(Object p0){ return null; }
}
