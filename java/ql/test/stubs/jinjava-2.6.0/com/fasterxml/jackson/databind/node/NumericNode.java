// Generated automatically from com.fasterxml.jackson.databind.node.NumericNode for testing purposes

package com.fasterxml.jackson.databind.node;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.node.JsonNodeType;
import com.fasterxml.jackson.databind.node.ValueNode;
import java.math.BigDecimal;
import java.math.BigInteger;

abstract public class NumericNode extends ValueNode
{
    protected NumericNode(){}
    public abstract BigDecimal decimalValue();
    public abstract BigInteger bigIntegerValue();
    public abstract JsonParser.NumberType numberType();
    public abstract Number numberValue();
    public abstract String asText();
    public abstract boolean canConvertToInt();
    public abstract boolean canConvertToLong();
    public abstract double doubleValue();
    public abstract int intValue();
    public abstract long longValue();
    public final JsonNodeType getNodeType(){ return null; }
    public final double asDouble(){ return 0; }
    public final double asDouble(double p0){ return 0; }
    public final int asInt(){ return 0; }
    public final int asInt(int p0){ return 0; }
    public final long asLong(){ return 0; }
    public final long asLong(long p0){ return 0; }
}
