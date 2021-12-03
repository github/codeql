package com.fasterxml.jackson.databind;

import java.io.*;
import java.text.*;
import java.util.Locale;
import java.util.Map;
import java.util.TimeZone;
import java.util.concurrent.atomic.AtomicReference;
import com.fasterxml.jackson.core.*;
import com.fasterxml.jackson.core.type.TypeReference;

public class ObjectWriter implements java.io.Serializable // since 2.1
{
  public ObjectWriter with(JsonGenerator.Feature feature) {
    return null;
  }

  public ObjectWriter withFeatures(JsonGenerator.Feature... features) {
    return null;
  }

  public ObjectWriter without(JsonGenerator.Feature feature) {
    return null;
  }

  public ObjectWriter withoutFeatures(JsonGenerator.Feature... features) {
    return null;
  }

  public ObjectWriter forType(JavaType rootType) {
    return null;
  }

  public ObjectWriter forType(Class<?> rootType) {
    return null;
  }

  public ObjectWriter forType(TypeReference<?> rootType) {
    return null;
  }

  public ObjectWriter withType(JavaType rootType) {
    return null;
  }

  public ObjectWriter withType(Class<?> rootType) {
    return null;
  }

  public ObjectWriter withType(TypeReference<?> rootType) {
    return null;
  }

  public ObjectWriter with(DateFormat df) {
    return null;
  }

  public ObjectWriter withDefaultPrettyPrinter() {
    return null;
  }

  public ObjectWriter withRootName(String rootName) {
    return null;
  }

  public ObjectWriter withoutRootName() {
    return null;
  }

  public ObjectWriter withView(Class<?> view) {
    return null;
  }

  public ObjectWriter with(Locale l) {
    return null;
  }

  public ObjectWriter with(TimeZone tz) {
    return null;
  }

  public ObjectWriter with(JsonFactory f) {
    return null;
  }

  public ObjectWriter withAttributes(Map<?, ?> attrs) {
    return null;
  }

  public ObjectWriter withAttribute(Object key, Object value) {
    return null;
  }

  public ObjectWriter withoutAttribute(Object key) {
    return null;
  }

  public ObjectWriter withRootValueSeparator(String sep) {
    return null;
  }

  public JsonGenerator createGenerator(OutputStream out) throws IOException {
    return null;
  }

  public JsonGenerator createGenerator(OutputStream out, JsonEncoding enc) throws IOException {
    return null;
  }

  public JsonGenerator createGenerator(Writer w) throws IOException {
    return null;
  }

  public JsonGenerator createGenerator(File outputFile, JsonEncoding enc) throws IOException {
    return null;
  }

  public JsonGenerator createGenerator(DataOutput out) throws IOException {
    return null;
  }

  public boolean isEnabled(JsonGenerator.Feature f) {
    return false;
  }

  public JsonFactory getFactory() {
    return null;
  }

  public boolean hasPrefetchedSerializer() {
    return false;
  }

  public void writeValue(JsonGenerator g, Object value) throws IOException {}

  public void writeValue(File resultFile, Object value)
      throws IOException, JsonGenerationException, JsonMappingException {}

  public void writeValue(OutputStream out, Object value)
      throws IOException, JsonGenerationException, JsonMappingException {}

  public void writeValue(Writer w, Object value)
      throws IOException, JsonGenerationException, JsonMappingException {}

  public void writeValue(DataOutput out, Object value) throws IOException {}

  public String writeValueAsString(Object value) throws JsonProcessingException {
    return null;
  }

  public byte[] writeValueAsBytes(Object value) throws JsonProcessingException {
    return null;
  }

  public boolean canSerialize(Class<?> type) {
    return false;
  }

  public boolean canSerialize(Class<?> type, AtomicReference<Throwable> cause) {
    return false;
  }

  public final static class GeneratorSettings implements java.io.Serializable {
    public GeneratorSettings withRootValueSeparator(String sep) {
      return null;
    }

    public void initialize(JsonGenerator gen) {}

  }
  public final static class Prefetch implements java.io.Serializable {

    public Prefetch forRootType(ObjectWriter parent, JavaType newType) {
      return null;
    }

    public boolean hasSerializer() {
      return false;
    }
  }
}
