package com.fasterxml.jackson.databind;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.TreeNode;
import com.fasterxml.jackson.databind.jsontype.PolymorphicTypeValidator;
import java.lang.reflect.Type;
import java.io.*;
import java.util.*;

public class ObjectMapper {
  public ObjectMapper() {
  }

  public void writeValue(File resultFile, Object value) {
  }

  public void writeValue(com.fasterxml.jackson.core.JsonGenerator jgen, Object value) {
  }

  public void writeValue(OutputStream out, Object value) {
  }

  public void writeValue(Writer w, Object value) {
  }

  public byte[] writeValueAsBytes(Object value) {
    return null;
  }

  public String writeValueAsString(Object value) {
    return null;
  }

  public ObjectReader readerFor(Class<?> type) {
    return null;
  }

  public <T extends JsonNode> T valueToTree(Object fromValue) throws IllegalArgumentException {
    return null;
  }

  public <T> T convertValue(Object fromValue, Class<T> toValueType) throws IllegalArgumentException {
    return null;
  }

  public ObjectMapper setPolymorphicTypeValidator(PolymorphicTypeValidator ptv) {
    return null;
  }

  public ObjectMapper enableDefaultTyping() {
    return null;
  }

  public <T> T readValue(String content, Class<T> valueType) {
    return null;
  }

  public <T> T readValue(String content, JavaType valueType) {
    return null;
  }

  public <T> MappingIterator<T> readValues(JsonParser p, Class<T> valueType) {
    return null;
  }

  public <T> T treeToValue(TreeNode n, Class<T> valueType) {
    return null;
  }

  public JsonNode readTree(String content) {
    return null;
  }

  public JavaType constructType(Type t) {
    return null;
  }
}
