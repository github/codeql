package com.fasterxml.jackson.databind;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.*;
import com.fasterxml.jackson.core.*;

public abstract class JsonNode implements TreeNode, Iterable<JsonNode> {
  public abstract <T extends JsonNode> T deepCopy();

  public int size() {
    return 0;
  }

  public boolean isEmpty() {
    return size() == 0;
  }

  public final boolean isValueNode() {
    return false;
  }

  public final boolean isContainerNode() {
    return false;
  }

  public boolean isMissingNode() {
    return false;
  }

  public boolean isArray() {
    return false;
  }

  public boolean isObject() {
    return false;
  }

  public abstract JsonNode get(int index);

  public JsonNode get(String fieldName) {
    return null;
  }

  public abstract JsonNode path(String fieldName);

  public abstract JsonNode path(int index);

  public Iterator<String> fieldNames() {
    return null;
  }

  public final JsonNode at(String jsonPtrExpr) {
    return null;
  }

  public final boolean isPojo() {
    return false;
  }

  public final boolean isNumber() {
    return false;
  }

  public boolean isIntegralNumber() {
    return false;
  }

  public boolean isFloatingPointNumber() {
    return false;
  }

  public boolean isShort() {
    return false;
  }

  public boolean isInt() {
    return false;
  }

  public boolean isLong() {
    return false;
  }

  public boolean isFloat() {
    return false;
  }

  public boolean isDouble() {
    return false;
  }

  public boolean isBigDecimal() {
    return false;
  }

  public boolean isBigInteger() {
    return false;
  }

  public final boolean isTextual() {
    return false;
  }

  public final boolean isBoolean() {
    return false;
  }

  public final boolean isNull() {
    return false;
  }

  public final boolean isBinary() {
    return false;
  }

  public boolean canConvertToInt() {
    return false;
  }

  public boolean canConvertToLong() {
    return false;
  }

  public boolean canConvertToExactIntegral() {
    return false;
  }

  public String textValue() {
    return null;
  }

  public byte[] binaryValue() throws IOException {
    return null;
  }

  public boolean booleanValue() {
    return false;
  }

  public Number numberValue() {
    return null;
  }

  public short shortValue() {
    return 0;
  }

  public int intValue() {
    return 0;
  }

  public long longValue() {
    return 0L;
  }

  public float floatValue() {
    return 0.0f;
  }

  public double doubleValue() {
    return 0.0;
  }

  public BigDecimal decimalValue() {
    return BigDecimal.ZERO;
  }

  public BigInteger bigIntegerValue() {
    return BigInteger.ZERO;
  }

  public abstract String asText();

  public String asText(String defaultValue) {
    return null;
  }

  public int asInt() {
    return 0;
  }

  public int asInt(int defaultValue) {
    return 0;
  }

  public long asLong() {
    return 0;
  }

  public long asLong(long defaultValue) {
    return 0;
  }

  public double asDouble() {
    return 0;
  }

  public double asDouble(double defaultValue) {
    return 0;
  }

  public boolean asBoolean() {
    return false;
  }

  public boolean asBoolean(boolean defaultValue) {
    return false;
  }

  public <T extends JsonNode> T require() throws IllegalArgumentException {
    return null;
  }

  public <T extends JsonNode> T requireNonNull() throws IllegalArgumentException {
    return null;
  }

  public JsonNode required(String propertyName) throws IllegalArgumentException {
    return null;
  }

  public JsonNode required(int index) throws IllegalArgumentException {
    return null;
  }

  public JsonNode requiredAt(String pathExpr) throws IllegalArgumentException {
    return null;
  }

  public boolean has(String fieldName) {
    return false;
  }

  public boolean has(int index) {
    return false;
  }

  public boolean hasNonNull(String fieldName) {
    return false;
  }

  public boolean hasNonNull(int index) {
    return false;
  }

  public final Iterator<JsonNode> iterator() {
    return elements();
  }

  public Iterator<JsonNode> elements() {
    return null;
  }

  public Iterator<Map.Entry<String, JsonNode>> fields() {
    return null;
  }

  public abstract JsonNode findValue(String fieldName);

  public final List<JsonNode> findValues(String fieldName) {
    return null;
  }

  public final List<String> findValuesAsText(String fieldName) {
    return null;
  }

  public abstract JsonNode findPath(String fieldName);

  public abstract JsonNode findParent(String fieldName);

  public final List<JsonNode> findParents(String fieldName) {
    return null;
  }

  public abstract List<JsonNode> findValues(String fieldName, List<JsonNode> foundSoFar);

  public abstract List<String> findValuesAsText(String fieldName, List<String> foundSoFar);

  public abstract List<JsonNode> findParents(String fieldName, List<JsonNode> foundSoFar);

  public <T extends JsonNode> T with(String propertyName) {
    return null;
  }

  public <T extends JsonNode> T withArray(String propertyName) {
    return null;
  }

  public boolean equals(Comparator<JsonNode> comparator, JsonNode other) {
    return false;
  }

  public abstract String toString();

  public String toPrettyString() {
    return null;
  }

  public abstract boolean equals(Object o);

}
