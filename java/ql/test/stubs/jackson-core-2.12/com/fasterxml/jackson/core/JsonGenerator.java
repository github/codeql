/*
 * Jackson JSON-processor.
 *
 * Copyright (c) 2007- Tatu Saloranta, tatu.saloranta@iki.fi
 */
package com.fasterxml.jackson.core;

import java.io.*;
import java.math.BigDecimal;
import java.math.BigInteger;

public abstract class JsonGenerator implements Closeable, Flushable {
  public enum Feature {
  }

  public Object getOutputTarget() {
    return null;
  }

  public Object getCurrentValue() {
    return null;
  }

  public void setCurrentValue(Object v) {}

  public abstract JsonGenerator enable(Feature f);

  public abstract JsonGenerator disable(Feature f);

  public final JsonGenerator configure(Feature f, boolean state) {
    return null;
  }

  public abstract boolean isEnabled(Feature f);

  public abstract int getFeatureMask();

  public abstract JsonGenerator setFeatureMask(int values);

  public JsonGenerator overrideStdFeatures(int values, int mask) {
    return null;
  }

  public int getFormatFeatures() {
    return 0;
  }

  public JsonGenerator overrideFormatFeatures(int values, int mask) {
    return null;
  }

  public abstract JsonGenerator useDefaultPrettyPrinter();

  public JsonGenerator setHighestNonEscapedChar(int charCode) {
    return this;
  }

  public int getHighestEscapedChar() {
    return 0;
  }

  public int getOutputBuffered() {
    return 0;
  }

  public boolean canWriteObjectId() {
    return false;
  }

  public boolean canWriteTypeId() {
    return false;
  }

  public boolean canWriteBinaryNatively() {
    return false;
  }

  public boolean canOmitFields() {
    return true;
  }

  public boolean canWriteFormattedNumbers() {
    return false;
  }

  public abstract void writeStartArray() throws IOException;

  public void writeStartArray(int size) throws IOException {}

  public void writeStartArray(Object forValue) throws IOException {}

  public void writeStartArray(Object forValue, int size) throws IOException {}

  public abstract void writeEndArray() throws IOException;

  public abstract void writeStartObject() throws IOException;

  public void writeStartObject(Object forValue) throws IOException {}

  public void writeStartObject(Object forValue, int size) throws IOException {}

  public abstract void writeEndObject() throws IOException;

  public abstract void writeFieldName(String name) throws IOException;

  public void writeFieldId(long id) throws IOException {}

  public void writeArray(int[] array, int offset, int length) throws IOException {}

  public void writeArray(long[] array, int offset, int length) throws IOException {}

  public void writeArray(double[] array, int offset, int length) throws IOException {}

  public void writeArray(String[] array, int offset, int length) throws IOException {}

  public abstract void writeString(String text) throws IOException;

  public void writeString(Reader reader, int len) throws IOException {}

  public abstract void writeString(char[] buffer, int offset, int len) throws IOException;

  public abstract void writeRawUTF8String(byte[] buffer, int offset, int len) throws IOException;

  public abstract void writeUTF8String(byte[] buffer, int offset, int len) throws IOException;

  public abstract void writeRaw(String text) throws IOException;

  public abstract void writeRaw(String text, int offset, int len) throws IOException;

  public abstract void writeRaw(char[] text, int offset, int len) throws IOException;

  public abstract void writeRaw(char c) throws IOException;

  public abstract void writeRawValue(String text) throws IOException;

  public abstract void writeRawValue(String text, int offset, int len) throws IOException;

  public abstract void writeRawValue(char[] text, int offset, int len) throws IOException;

  public void writeBinary(byte[] data, int offset, int len) throws IOException {}

  public void writeBinary(byte[] data) throws IOException {}

  public int writeBinary(InputStream data, int dataLength) throws IOException {
    return 0;
  }

  public void writeNumber(short v) throws IOException {
    writeNumber((int) v);
  }

  public abstract void writeNumber(int v) throws IOException;

  public abstract void writeNumber(long v) throws IOException;

  public abstract void writeNumber(BigInteger v) throws IOException;

  public abstract void writeNumber(double v) throws IOException;

  public abstract void writeNumber(float v) throws IOException;

  public abstract void writeNumber(BigDecimal v) throws IOException;

  public abstract void writeNumber(String encodedValue) throws IOException;

  public void writeNumber(char[] encodedValueBuffer, int offset, int len) throws IOException {}

  public abstract void writeBoolean(boolean state) throws IOException;

  public abstract void writeNull() throws IOException;

  public void writeEmbeddedObject(Object object) throws IOException {}

  public void writeObjectId(Object id) throws IOException {}

  public void writeObjectRef(Object referenced) throws IOException {}

  public void writeTypeId(Object id) throws IOException {}

  public abstract void writeObject(Object pojo) throws IOException;

  public abstract void writeTree(TreeNode rootNode) throws IOException;

  public void writeBinaryField(String fieldName, byte[] data) throws IOException {}

  public void writeBooleanField(String fieldName, boolean value) throws IOException {}

  public void writeNullField(String fieldName) throws IOException {}

  public void writeStringField(String fieldName, String value) throws IOException {}

  public void writeNumberField(String fieldName, short value) throws IOException {}

  public void writeNumberField(String fieldName, int value) throws IOException {}

  public void writeNumberField(String fieldName, long value) throws IOException {}

  public void writeNumberField(String fieldName, BigInteger value) throws IOException {}

  public void writeNumberField(String fieldName, float value) throws IOException {}

  public void writeNumberField(String fieldName, double value) throws IOException {}

  public void writeNumberField(String fieldName, BigDecimal value) throws IOException {}

  public void writeArrayFieldStart(String fieldName) throws IOException {}

  public void writeObjectFieldStart(String fieldName) throws IOException {}

  public void writeObjectField(String fieldName, Object pojo) throws IOException {}

  public void writeOmittedField(String fieldName) throws IOException {}

  public void copyCurrentEvent(JsonParser p) throws IOException {}

  public void copyCurrentStructure(JsonParser p) throws IOException {}

  @Override
  public abstract void flush() throws IOException;

  public abstract boolean isClosed();

  @Override
  public abstract void close() throws IOException;

}
