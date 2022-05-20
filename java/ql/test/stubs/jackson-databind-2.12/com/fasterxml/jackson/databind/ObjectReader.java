package com.fasterxml.jackson.databind;

import java.io.*;
import java.net.URL;
import java.util.*;
import com.fasterxml.jackson.core.*;
import com.fasterxml.jackson.core.type.TypeReference;

public class ObjectReader implements java.io.Serializable // since 2.1
{

  public ObjectReader with(JsonFactory f) {
    return null;
  }

  public ObjectReader withRootName(String rootName) {
    return null;
  }


  public ObjectReader withoutRootName() {
    return null;
  }

  public ObjectReader forType(JavaType valueType) {
    return null;
  }

  public ObjectReader forType(Class<?> valueType) {
    return null;
  }

  public ObjectReader forType(TypeReference<?> valueTypeRef) {
    return null;
  }

  public ObjectReader withType(JavaType valueType) {
    return null;
  }

  public ObjectReader withType(Class<?> valueType) {
    return null;
  }

  public ObjectReader withType(java.lang.reflect.Type valueType) {
    return null;
  }

  public ObjectReader withType(TypeReference<?> valueTypeRef) {
    return null;
  }

  public ObjectReader withValueToUpdate(Object value) {
    return null;
  }

  public ObjectReader withView(Class<?> activeView) {
    return null;
  }

  public ObjectReader with(Locale l) {
    return null;
  }

  public ObjectReader with(TimeZone tz) {
    return null;
  }


  public ObjectReader withFormatDetection(ObjectReader... readers) {
    return null;
  }


  public ObjectReader withAttributes(Map<?, ?> attrs) {
    return null;
  }

  public ObjectReader withAttribute(Object key, Object value) {
    return null;
  }

  public ObjectReader withoutAttribute(Object key) {
    return null;
  }


  public JavaType getValueType() {
    return null;
  }

  public JsonParser createParser(File src) throws IOException {
    return null;
  }

  public JsonParser createParser(URL src) throws IOException {
    return null;
  }

  public JsonParser createParser(InputStream in) throws IOException {
    return null;
  }

  public JsonParser createParser(Reader r) throws IOException {
    return null;
  }

  public JsonParser createParser(byte[] content) throws IOException {
    return null;
  }

  public JsonParser createParser(byte[] content, int offset, int len) throws IOException {
    return null;
  }

  public JsonParser createParser(String content) throws IOException {
    return null;
  }

  public JsonParser createParser(char[] content) throws IOException {
    return null;
  }

  public JsonParser createParser(char[] content, int offset, int len) throws IOException {
    return null;
  }

  public JsonParser createParser(DataInput content) throws IOException {
    return null;
  }

  public JsonParser createNonBlockingByteArrayParser() throws IOException {
    return null;
  }

  public <T> T readValue(JsonParser p) throws IOException {
    return null;
  }

  public <T> T readValue(JsonParser p, JavaType valueType) throws IOException {
    return null;
  }

  public <T> Iterator<T> readValues(JsonParser p, JavaType valueType) throws IOException {
    return null;
  }

  public JsonNode createArrayNode() {
    return null;
  }

  public JsonNode createObjectNode() {
    return null;
  }

  public JsonNode missingNode() {
    return null;
  }

  public JsonNode nullNode() {
    return null;
  }

  public JsonParser treeAsTokens(TreeNode n) {
    return null;
  }

  public <T extends TreeNode> T readTree(JsonParser p) throws IOException {
    return null;
  }

  public void writeTree(JsonGenerator g, TreeNode rootNode) {}

  public <T> T readValue(InputStream src) throws IOException {
    return null;
  }

  public <T> T readValue(InputStream src, Class<T> valueType) throws IOException {
    return null;
  }

  public <T> T readValue(Reader src) throws IOException {
    return null;
  }

  public <T> T readValue(Reader src, Class<T> valueType) throws IOException {
    return null;
  }

  public <T> T readValue(String src) throws JsonProcessingException, JsonMappingException {
    return null;
  }

  public <T> T readValue(String src, Class<T> valueType) throws IOException {
    return null;
  }

  public <T> T readValue(byte[] content) throws IOException {
    return null;
  }

  public <T> T readValue(byte[] content, Class<T> valueType) throws IOException {
    return null;
  }

  public <T> T readValue(byte[] buffer, int offset, int length) throws IOException {
    return null;
  }

  public <T> T readValue(byte[] buffer, int offset, int length, Class<T> valueType)
      throws IOException {
    return null;
  }

  public <T> T readValue(File src) throws IOException {
    return null;
  }

  public <T> T readValue(File src, Class<T> valueType) throws IOException {
    return null;
  }

  public <T> T readValue(URL src) throws IOException {
    return null;
  }

  public <T> T readValue(URL src, Class<T> valueType) throws IOException {
    return null;
  }

  public <T> T readValue(JsonNode content) throws IOException {
    return null;
  }

  public <T> T readValue(JsonNode content, Class<T> valueType) throws IOException {
    return null;
  }

  public <T> T readValue(DataInput src) throws IOException {
    return null;
  }

  public <T> T readValue(DataInput content, Class<T> valueType) throws IOException {
    return null;
  }

  public JsonNode readTree(InputStream src) throws IOException {
    return null;
  }

  public JsonNode readTree(Reader src) throws IOException {
    return null;
  }

  public JsonNode readTree(String json) throws JsonProcessingException, JsonMappingException {
    return null;
  }

  public JsonNode readTree(byte[] json) throws IOException {
    return null;
  }

  public JsonNode readTree(byte[] json, int offset, int len) throws IOException {
    return null;
  }

  public JsonNode readTree(DataInput src) throws IOException {
    return null;
  }

  public <T> MappingIterator<T> readValues(JsonParser p) throws IOException {
    return null;
  }

  public <T> MappingIterator<T> readValues(InputStream src) throws IOException {
    return null;
  }

  public <T> MappingIterator<T> readValues(Reader src) throws IOException {
    return null;
  }

  public <T> MappingIterator<T> readValues(String json) throws IOException {
    return null;
  }

  public <T> MappingIterator<T> readValues(byte[] src, int offset, int length) throws IOException {
    return null;
  }

  public final <T> MappingIterator<T> readValues(byte[] src) throws IOException {
    return null;
  }

  public <T> MappingIterator<T> readValues(File src) throws IOException {
    return null;
  }

  public <T> MappingIterator<T> readValues(URL src) throws IOException {
    return null;
  }

  public <T> MappingIterator<T> readValues(DataInput src) throws IOException {
    return null;
  }

  public <T> T treeToValue(TreeNode n, Class<T> valueType) throws JsonProcessingException {
    return null;
  }

  public void writeValue(JsonGenerator gen, Object value) throws IOException {}

}
