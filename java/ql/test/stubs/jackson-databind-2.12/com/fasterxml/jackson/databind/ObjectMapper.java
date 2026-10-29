package com.fasterxml.jackson.databind;

import java.io.*;
import java.lang.reflect.Type;
import java.net.URL;
import java.text.DateFormat;
import java.util.*;
import java.util.concurrent.atomic.AtomicReference;
import com.fasterxml.jackson.core.*;
import com.fasterxml.jackson.core.type.ResolvedType;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.jsontype.PolymorphicTypeValidator;

public class ObjectMapper implements java.io.Serializable // as of 2.1
{
  public enum DefaultTyping {
  }
  public static class DefaultTypeResolverBuilder implements java.io.Serializable {
    public DefaultTypeResolverBuilder(DefaultTyping t) {}

    public boolean useForType(JavaType t) {
      return false;
    }

  }

  public ObjectMapper() {}

  public ObjectMapper(JsonFactory jf) {}

  public ObjectMapper copy() {
    return null;
  }

  public ObjectMapper registerModule(Module module) {
    return null;
  }

  public ObjectMapper registerModules(Module... modules) {
    return null;
  }

  public ObjectMapper registerModules(Iterable<? extends Module> modules) {
    return null;
  }

  public Set<Object> getRegisteredModuleIds() {
    return null;
  }

  public static List<Module> findModules() {
    return null;
  }

  public static List<Module> findModules(ClassLoader classLoader) {
    return null;
  }

  public ObjectMapper findAndRegisterModules() {
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

  public ObjectMapper setMixIns(Map<Class<?>, Class<?>> sourceMixins) {
    return null;
  }

  public ObjectMapper addMixIn(Class<?> target, Class<?> mixinSource) {
    return null;
  }

  public Class<?> findMixInClassFor(Class<?> cls) {
    return null;
  }

  public int mixInCount() {
    return 0;
  }

  public void setMixInAnnotations(Map<Class<?>, Class<?>> sourceMixins) {}

  public final void addMixInAnnotations(Class<?> target, Class<?> mixinSource) {}

  public ObjectMapper setDefaultMergeable(Boolean b) {
    return null;
  }

  public ObjectMapper setDefaultLeniency(Boolean b) {
    return null;
  }

  public void registerSubtypes(Class<?>... classes) {}

  public void registerSubtypes(Collection<Class<?>> subtypes) {}

  public ObjectMapper deactivateDefaultTyping() {
    return null;
  }

  public ObjectMapper enableDefaultTyping() {
    return null;
  }

  public ObjectMapper enableDefaultTyping(DefaultTyping dti) {
    return null;
  }

  public ObjectMapper enableDefaultTypingAsProperty(DefaultTyping applicability,
      String propertyName) {
    return null;
  }

  public ObjectMapper disableDefaultTyping() {
    return null;
  }

  public JavaType constructType(Type t) {
    return null;
  }

  public JavaType constructType(TypeReference<?> typeRef) {
    return null;
  }

  public JsonFactory tokenStreamFactory() {
    return null;
  }

  public JsonFactory getFactory() {
    return null;
  }

  public JsonFactory getJsonFactory() {
    return getFactory();
  }

  public ObjectMapper setDateFormat(DateFormat dateFormat) {
    return null;
  }

  public DateFormat getDateFormat() {
    return null;
  }

  public ObjectMapper setLocale(Locale l) {
    return null;
  }

  public ObjectMapper setTimeZone(TimeZone tz) {
    return null;
  }

  public boolean isEnabled(JsonGenerator.Feature f) {
    return false;
  }

  public ObjectMapper configure(JsonGenerator.Feature f, boolean state) {
    return null;
  }

  public ObjectMapper enable(JsonGenerator.Feature... features) {
    return null;
  }

  public ObjectMapper disable(JsonGenerator.Feature... features) {
    return null;
  }

  public <T> T readValue(JsonParser p, Class<T> valueType)
      throws IOException, JsonParseException, JsonMappingException {
    return null;
  }

  public <T> T readValue(JsonParser p, TypeReference<T> valueTypeRef)
      throws IOException, JsonParseException, JsonMappingException {
    return null;
  }

  public final <T> T readValue(JsonParser p, ResolvedType valueType)
      throws IOException, JsonParseException, JsonMappingException {
    return null;
  }

  public <T> T readValue(JsonParser p, JavaType valueType)
      throws IOException, JsonParseException, JsonMappingException {
    return null;
  }

  public <T extends TreeNode> T readTree(JsonParser p) throws IOException, JsonProcessingException {
    return null;
  }

  public <T> MappingIterator<T> readValues(JsonParser p, ResolvedType valueType)
      throws IOException, JsonProcessingException {
    return null;
  }

  public <T> MappingIterator<T> readValues(JsonParser p, JavaType valueType)
      throws IOException, JsonProcessingException {
    return null;
  }

  public <T> MappingIterator<T> readValues(JsonParser p, Class<T> valueType)
      throws IOException, JsonProcessingException {
    return null;
  }

  public <T> MappingIterator<T> readValues(JsonParser p, TypeReference<T> valueTypeRef)
      throws IOException, JsonProcessingException {
    return null;
  }

  public JsonNode readTree(InputStream in) throws IOException {
    return null;
  }

  public JsonNode readTree(Reader r) throws IOException {
    return null;
  }

  public JsonNode readTree(String content) throws JsonProcessingException, JsonMappingException {
    return null;
  }

  public JsonNode readTree(byte[] content) throws IOException {
    return null;
  }

  public JsonNode readTree(byte[] content, int offset, int len) throws IOException {
    return null;
  }

  public JsonNode readTree(File file) throws IOException, JsonProcessingException {
    return null;
  }

  public JsonNode readTree(URL source) throws IOException {
    return null;
  }

  public void writeValue(JsonGenerator g, Object value)
      throws IOException, JsonGenerationException, JsonMappingException {}

  public void writeTree(JsonGenerator g, TreeNode rootNode)
      throws IOException, JsonProcessingException {}

  public void writeTree(JsonGenerator g, JsonNode rootNode)
      throws IOException, JsonProcessingException {}

  public JsonNode missingNode() {
    return null;
  }

  public JsonNode nullNode() {
    return null;
  }

  public JsonParser treeAsTokens(TreeNode n) {
    return null;
  }

  public <T> T treeToValue(TreeNode n, Class<T> valueType)
      throws IllegalArgumentException, JsonProcessingException {
    return null;
  }

  public <T extends JsonNode> T valueToTree(Object fromValue) throws IllegalArgumentException {
    return null;
  }

  public boolean canSerialize(Class<?> type) {
    return false;
  }

  public boolean canSerialize(Class<?> type, AtomicReference<Throwable> cause) {
    return false;
  }

  public boolean canDeserialize(JavaType type) {
    return false;
  }

  public boolean canDeserialize(JavaType type, AtomicReference<Throwable> cause) {
    return false;
  }

  public <T> T readValue(File src, Class<T> valueType)
      throws IOException, JsonParseException, JsonMappingException {
    return null;
  }

  public <T> T readValue(File src, TypeReference<T> valueTypeRef)
      throws IOException, JsonParseException, JsonMappingException {
    return null;
  }

  public <T> T readValue(File src, JavaType valueType)
      throws IOException, JsonParseException, JsonMappingException {
    return null;
  }

  public <T> T readValue(URL src, Class<T> valueType)
      throws IOException, JsonParseException, JsonMappingException {
    return null;
  }

  public <T> T readValue(URL src, TypeReference<T> valueTypeRef)
      throws IOException, JsonParseException, JsonMappingException {
    return null;
  }

  public <T> T readValue(URL src, JavaType valueType)
      throws IOException, JsonParseException, JsonMappingException {
    return null;
  }

  public <T> T readValue(String content, Class<T> valueType)
      throws JsonProcessingException, JsonMappingException {
    return null;
  }

  public <T> T readValue(String content, TypeReference<T> valueTypeRef)
      throws JsonProcessingException, JsonMappingException {
    return null;
  }

  public <T> T readValue(String content, JavaType valueType)
      throws JsonProcessingException, JsonMappingException {
    return null;
  }

  public <T> T readValue(Reader src, Class<T> valueType)
      throws IOException, JsonParseException, JsonMappingException {
    return null;
  }

  public <T> T readValue(Reader src, TypeReference<T> valueTypeRef)
      throws IOException, JsonParseException, JsonMappingException {
    return null;
  }

  public <T> T readValue(Reader src, JavaType valueType)
      throws IOException, JsonParseException, JsonMappingException {
    return null;
  }

  public <T> T readValue(InputStream src, Class<T> valueType)
      throws IOException, JsonParseException, JsonMappingException {
    return null;
  }

  public <T> T readValue(InputStream src, TypeReference<T> valueTypeRef)
      throws IOException, JsonParseException, JsonMappingException {
    return null;
  }

  public <T> T readValue(InputStream src, JavaType valueType)
      throws IOException, JsonParseException, JsonMappingException {
    return null;
  }

  public <T> T readValue(byte[] src, Class<T> valueType)
      throws IOException, JsonParseException, JsonMappingException {
    return null;
  }

  public <T> T readValue(byte[] src, int offset, int len, Class<T> valueType)
      throws IOException, JsonParseException, JsonMappingException {
    return null;
  }

  public <T> T readValue(byte[] src, TypeReference<T> valueTypeRef)
      throws IOException, JsonParseException, JsonMappingException {
    return null;
  }

  public <T> T readValue(byte[] src, int offset, int len, TypeReference<T> valueTypeRef)
      throws IOException, JsonParseException, JsonMappingException {
    return null;
  }

  public <T> T readValue(byte[] src, JavaType valueType)
      throws IOException, JsonParseException, JsonMappingException {
    return null;
  }

  public <T> T readValue(byte[] src, int offset, int len, JavaType valueType)
      throws IOException, JsonParseException, JsonMappingException {
    return null;
  }

  public <T> T readValue(DataInput src, Class<T> valueType) throws IOException {
    return null;
  }

  public <T> T readValue(DataInput src, JavaType valueType) throws IOException {
    return null;
  }

  public void writeValue(File resultFile, Object value)
      throws IOException, JsonGenerationException, JsonMappingException {}

  public void writeValue(OutputStream out, Object value)
      throws IOException, JsonGenerationException, JsonMappingException {}

  public void writeValue(DataOutput out, Object value) throws IOException {}

  public void writeValue(Writer w, Object value)
      throws IOException, JsonGenerationException, JsonMappingException {}

  public String writeValueAsString(Object value) throws JsonProcessingException {
    return null;
  }

  public byte[] writeValueAsBytes(Object value) throws JsonProcessingException {
    return null;
  }

  public ObjectWriter writer() {
    return null;
  }

  public ObjectWriter writer(DateFormat df) {
    return null;
  }

  public ObjectWriter writerWithView(Class<?> serializationView) {
    return null;
  }

  public ObjectWriter writerFor(Class<?> rootType) {
    return null;
  }

  public ObjectWriter writerFor(TypeReference<?> rootType) {
    return null;
  }

  public ObjectWriter writerFor(JavaType rootType) {
    return null;
  }


  public ObjectWriter writerWithDefaultPrettyPrinter() {
    return null;
  }

  public ObjectWriter writerWithType(Class<?> rootType) {
    return null;
  }

  public ObjectWriter writerWithType(TypeReference<?> rootType) {
    return null;
  }

  public ObjectWriter writerWithType(JavaType rootType) {
    return null;
  }

  public ObjectReader reader() {
    return null;
  }

  public ObjectReader readerForUpdating(Object valueToUpdate) {
    return null;
  }

  public ObjectReader readerFor(JavaType type) {
    return null;
  }

  public ObjectReader readerFor(Class<?> type) {
    return null;
  }

  public ObjectReader readerFor(TypeReference<?> type) {
    return null;
  }

  public ObjectReader readerForArrayOf(Class<?> type) {
    return null;
  }

  public ObjectReader readerForListOf(Class<?> type) {
    return null;
  }

  public ObjectReader readerForMapOf(Class<?> type) {
    return null;
  }


  public ObjectReader readerWithView(Class<?> view) {
    return null;
  }

  public ObjectReader reader(JavaType type) {
    return null;
  }

  public ObjectReader reader(Class<?> type) {
    return null;
  }

  public ObjectReader reader(TypeReference<?> type) {
    return null;
  }

  public <T> T convertValue(Object fromValue, Class<T> toValueType)
      throws IllegalArgumentException {
    return null;
  }

  public <T> T convertValue(Object fromValue, TypeReference<T> toValueTypeRef)
      throws IllegalArgumentException {
    return null;
  }

  public <T> T convertValue(Object fromValue, JavaType toValueType)
      throws IllegalArgumentException {
    return null;
  }

  public <T> T updateValue(T valueToUpdate, Object overrides) throws JsonMappingException {
    return null;
  }

  public void setPolymorphicTypeValidator(PolymorphicTypeValidator ptv) {}

}
