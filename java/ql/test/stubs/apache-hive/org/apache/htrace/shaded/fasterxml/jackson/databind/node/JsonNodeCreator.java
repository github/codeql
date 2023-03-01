// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.node.JsonNodeCreator for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.node;

import java.math.BigDecimal;
import java.math.BigInteger;
import org.apache.htrace.shaded.fasterxml.jackson.databind.node.ArrayNode;
import org.apache.htrace.shaded.fasterxml.jackson.databind.node.ObjectNode;
import org.apache.htrace.shaded.fasterxml.jackson.databind.node.ValueNode;

public interface JsonNodeCreator
{
    ArrayNode arrayNode();
    ObjectNode objectNode();
    ValueNode binaryNode(byte[] p0);
    ValueNode binaryNode(byte[] p0, int p1, int p2);
    ValueNode booleanNode(boolean p0);
    ValueNode nullNode();
    ValueNode numberNode(BigDecimal p0);
    ValueNode numberNode(BigInteger p0);
    ValueNode numberNode(Byte p0);
    ValueNode numberNode(Double p0);
    ValueNode numberNode(Float p0);
    ValueNode numberNode(Integer p0);
    ValueNode numberNode(Long p0);
    ValueNode numberNode(Short p0);
    ValueNode numberNode(byte p0);
    ValueNode numberNode(double p0);
    ValueNode numberNode(float p0);
    ValueNode numberNode(int p0);
    ValueNode numberNode(long p0);
    ValueNode numberNode(short p0);
    ValueNode pojoNode(Object p0);
    ValueNode textNode(String p0);
}
