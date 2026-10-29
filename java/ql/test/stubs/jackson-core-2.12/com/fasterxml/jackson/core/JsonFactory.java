/*
 * Jackson JSON-processor.
 *
 * Copyright (c) 2007- Tatu Saloranta, tatu.saloranta@iki.fi
 */
package com.fasterxml.jackson.core;

import java.io.*;
import java.net.URL;

public class JsonFactory implements java.io.Serializable // since 2.1 (for Android, mostly)
{
  public JsonFactory copy() {
    return null;
  }

  public boolean canUseCharArrays() {
    return true;
  }

  public boolean requiresCustomCodec() {
    return false;
  }

  public final JsonFactory configure(JsonGenerator.Feature f, boolean state) {
    return null;
  }

  public JsonFactory enable(JsonGenerator.Feature f) {
    return null;
  }

  public JsonFactory disable(JsonGenerator.Feature f) {
    return null;
  }

  public JsonFactory setRootValueSeparator(String sep) {
    return null;
  }

  public String getRootValueSeparator() {
    return null;
  }

  public JsonParser createParser(File f) throws IOException, JsonParseException {
    return null;
  }

  public JsonParser createParser(URL url) throws IOException, JsonParseException {
    return null;
  }

  public JsonParser createParser(InputStream in) throws IOException, JsonParseException {
    return null;
  }

  public JsonParser createParser(Reader r) throws IOException, JsonParseException {
    return null;
  }

  public JsonParser createParser(byte[] data) throws IOException, JsonParseException {
    return null;
  }

  public JsonParser createParser(byte[] data, int offset, int len)
      throws IOException, JsonParseException {
    return null;
  }

  public JsonParser createParser(String content) throws IOException, JsonParseException {
    return null;
  }

  public JsonParser createParser(char[] content) throws IOException {
    return null;
  }

  public JsonParser createParser(char[] content, int offset, int len) throws IOException {
    return null;
  }

  public JsonParser createParser(DataInput in) throws IOException {
    return null;
  }

  public JsonParser createNonBlockingByteArrayParser() throws IOException {
    return null;
  }

  public JsonGenerator createGenerator(OutputStream out, JsonEncoding enc) throws IOException {
    return null;
  }

  public JsonGenerator createGenerator(OutputStream out) throws IOException {
    return null;
  }

  public JsonGenerator createGenerator(Writer w) throws IOException {
    return null;
  }

  public JsonGenerator createGenerator(File f, JsonEncoding enc) throws IOException {
    return null;
  }

  public JsonGenerator createGenerator(DataOutput out, JsonEncoding enc) throws IOException {
    return null;
  }

  public JsonGenerator createGenerator(DataOutput out) throws IOException {
    return null;
  }

  public JsonParser createJsonParser(File f) throws IOException, JsonParseException {
    return null;
  }

  public JsonParser createJsonParser(URL url) throws IOException, JsonParseException {
    return null;
  }

  public JsonParser createJsonParser(InputStream in) throws IOException, JsonParseException {
    return null;
  }

  public JsonParser createJsonParser(Reader r) throws IOException, JsonParseException {
    return null;
  }

  public JsonParser createJsonParser(byte[] data) throws IOException, JsonParseException {
    return null;
  }

  public JsonParser createJsonParser(byte[] data, int offset, int len)
      throws IOException, JsonParseException {
    return null;
  }

  public JsonParser createJsonParser(String content) throws IOException, JsonParseException {
    return null;
  }

  public JsonGenerator createJsonGenerator(OutputStream out, JsonEncoding enc) throws IOException {
    return null;
  }

  public JsonGenerator createJsonGenerator(Writer out) throws IOException {
    return null;
  }

  public JsonGenerator createJsonGenerator(OutputStream out) throws IOException {
    return null;
  }

}
