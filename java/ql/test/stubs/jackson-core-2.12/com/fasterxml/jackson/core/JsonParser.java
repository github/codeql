/*
 * Jackson JSON-processor.
 *
 * Copyright (c) 2007- Tatu Saloranta, tatu.saloranta@iki.fi
 */

package com.fasterxml.jackson.core;

import java.io.*;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.Iterator;
import com.fasterxml.jackson.core.type.TypeReference;

public abstract class JsonParser implements Closeable {
  public enum NumberType {
  }

  public Object getInputSource() {
    return null;
  }

  public Object getCurrentValue() {
    return null;
  }

  public void setCurrentValue(Object v) {}

  public void setRequestPayloadOnError(byte[] payload, String charset) {}

  public void setRequestPayloadOnError(String payload) {}

  public boolean requiresCustomCodec() {
    return false;
  }

  public boolean canParseAsync() {
    return false;
  }

  @Override
  public abstract void close() throws IOException;

  public abstract boolean isClosed();

  public int releaseBuffered(OutputStream out) throws IOException {
    return 0;
  }

  public int releaseBuffered(Writer w) throws IOException {
    return -1;
  }

  public JsonParser setFeatureMask(int mask) {
    return null;
  }

  public JsonParser overrideStdFeatures(int values, int mask) {
    return null;
  }

  public int getFormatFeatures() {
    return 0;
  }

  public JsonParser overrideFormatFeatures(int values, int mask) {
    return null;
  }

  public String nextFieldName() throws IOException {
    return null;
  }

  public String nextTextValue() throws IOException {
    return null;
  }

  public int nextIntValue(int defaultValue) throws IOException {
    return 0;
  }

  public long nextLongValue(long defaultValue) throws IOException {
    return 0;
  }

  public Boolean nextBooleanValue() throws IOException {
    return null;
  }

  public abstract JsonParser skipChildren() throws IOException;

  public void finishToken() throws IOException {}

  public int currentTokenId() {
    return 0;
  }

  public abstract int getCurrentTokenId();

  public abstract boolean hasCurrentToken();

  public abstract boolean hasTokenId(int id);

  public boolean isNaN() throws IOException {
    return false;
  }

  public abstract void clearCurrentToken();

  public abstract void overrideCurrentName(String name);

  public abstract String getCurrentName() throws IOException;

  public String currentName() throws IOException {
    return null;
  }

  public abstract String getText() throws IOException;

  public int getText(Writer writer) throws IOException, UnsupportedOperationException {
    return 0;
  }

  public abstract char[] getTextCharacters() throws IOException;

  public abstract int getTextLength() throws IOException;

  public abstract int getTextOffset() throws IOException;

  public abstract boolean hasTextCharacters();

  public abstract Number getNumberValue() throws IOException;

  public abstract NumberType getNumberType() throws IOException;

  public byte getByteValue() throws IOException {
    return 0;
  }

  public short getShortValue() throws IOException {
    return 0;
  }

  public abstract int getIntValue() throws IOException;

  public abstract long getLongValue() throws IOException;

  public abstract BigInteger getBigIntegerValue() throws IOException;

  public abstract float getFloatValue() throws IOException;

  public abstract double getDoubleValue() throws IOException;

  public abstract BigDecimal getDecimalValue() throws IOException;

  public boolean getBooleanValue() throws IOException {
    return false;
  }

  public Object getEmbeddedObject() throws IOException {
    return null;
  }

  public byte[] getBinaryValue() throws IOException {
    return null;
  }

  public int readBinaryValue(OutputStream out) throws IOException {
    return 0;
  }

  public int getValueAsInt() throws IOException {
    return 0;
  }

  public int getValueAsInt(int def) throws IOException {
    return def;
  }

  public long getValueAsLong() throws IOException {
    return 0;
  }

  public long getValueAsLong(long def) throws IOException {
    return 0;
  }

  public double getValueAsDouble() throws IOException {
    return 0;
  }

  public double getValueAsDouble(double def) throws IOException {
    return 0;
  }

  public boolean getValueAsBoolean() throws IOException {
    return false;
  }

  public boolean getValueAsBoolean(boolean def) throws IOException {
    return false;
  }

  public String getValueAsString() throws IOException {
    return null;
  }

  public abstract String getValueAsString(String def) throws IOException;

  public boolean canReadObjectId() {
    return false;
  }

  public boolean canReadTypeId() {
    return false;
  }

  public Object getObjectId() throws IOException {
    return null;
  }

  public Object getTypeId() throws IOException {
    return null;
  }

  public <T> T readValueAs(Class<T> valueType) throws IOException {
    return null;
  }

  public <T> T readValueAs(TypeReference<?> valueTypeRef) throws IOException {
    return null;
  }

  public <T> Iterator<T> readValuesAs(Class<T> valueType) throws IOException {
    return null;
  }

  public <T> Iterator<T> readValuesAs(TypeReference<T> valueTypeRef) throws IOException {
    return null;
  }

  public <T extends TreeNode> T readValueAsTree() throws IOException {
    return null;
  }

}
