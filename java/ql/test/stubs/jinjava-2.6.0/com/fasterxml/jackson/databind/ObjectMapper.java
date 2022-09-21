// Generated automatically from com.fasterxml.jackson.databind.ObjectMapper for testing purposes

package com.fasterxml.jackson.databind;

import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonTypeInfo;
import com.fasterxml.jackson.annotation.PropertyAccessor;
import com.fasterxml.jackson.core.Base64Variant;
import com.fasterxml.jackson.core.FormatSchema;
import com.fasterxml.jackson.core.JsonFactory;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.JsonToken;
import com.fasterxml.jackson.core.ObjectCodec;
import com.fasterxml.jackson.core.PrettyPrinter;
import com.fasterxml.jackson.core.TreeNode;
import com.fasterxml.jackson.core.Version;
import com.fasterxml.jackson.core.Versioned;
import com.fasterxml.jackson.core.io.CharacterEscapes;
import com.fasterxml.jackson.core.type.ResolvedType;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.AnnotationIntrospector;
import com.fasterxml.jackson.databind.DeserializationConfig;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.InjectableValues;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.MapperFeature;
import com.fasterxml.jackson.databind.MappingIterator;
import com.fasterxml.jackson.databind.Module;
import com.fasterxml.jackson.databind.ObjectReader;
import com.fasterxml.jackson.databind.ObjectWriter;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;
import com.fasterxml.jackson.databind.SerializationConfig;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.cfg.BaseSettings;
import com.fasterxml.jackson.databind.cfg.ContextAttributes;
import com.fasterxml.jackson.databind.cfg.HandlerInstantiator;
import com.fasterxml.jackson.databind.deser.DefaultDeserializationContext;
import com.fasterxml.jackson.databind.deser.DeserializationProblemHandler;
import com.fasterxml.jackson.databind.introspect.ClassIntrospector;
import com.fasterxml.jackson.databind.introspect.SimpleMixInResolver;
import com.fasterxml.jackson.databind.introspect.VisibilityChecker;
import com.fasterxml.jackson.databind.jsonFormatVisitors.JsonFormatVisitorWrapper;
import com.fasterxml.jackson.databind.jsonschema.JsonSchema;
import com.fasterxml.jackson.databind.jsontype.NamedType;
import com.fasterxml.jackson.databind.jsontype.SubtypeResolver;
import com.fasterxml.jackson.databind.jsontype.TypeResolverBuilder;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.JsonNodeFactory;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.fasterxml.jackson.databind.ser.DefaultSerializerProvider;
import com.fasterxml.jackson.databind.ser.FilterProvider;
import com.fasterxml.jackson.databind.ser.SerializerFactory;
import com.fasterxml.jackson.databind.type.TypeFactory;
import java.io.File;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.Reader;
import java.io.Serializable;
import java.io.Writer;
import java.lang.reflect.Type;
import java.net.URL;
import java.text.DateFormat;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.TimeZone;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicReference;

public class ObjectMapper extends ObjectCodec implements Serializable, Versioned
{
    protected ClassIntrospector defaultClassIntrospector(){ return null; }
    protected DefaultDeserializationContext _deserializationContext = null;
    protected DefaultDeserializationContext createDeserializationContext(JsonParser p0, DeserializationConfig p1){ return null; }
    protected DefaultSerializerProvider _serializerProvider = null;
    protected DefaultSerializerProvider _serializerProvider(SerializationConfig p0){ return null; }
    protected DeserializationConfig _deserializationConfig = null;
    protected InjectableValues _injectableValues = null;
    protected JsonDeserializer<Object> _findRootDeserializer(DeserializationContext p0, JavaType p1){ return null; }
    protected JsonToken _initForReading(JsonParser p0){ return null; }
    protected Object _convert(Object p0, JavaType p1){ return null; }
    protected Object _readMapAndClose(JsonParser p0, JavaType p1){ return null; }
    protected Object _readValue(DeserializationConfig p0, JsonParser p1, JavaType p2){ return null; }
    protected Object _unwrapAndDeserialize(JsonParser p0, DeserializationContext p1, DeserializationConfig p2, JavaType p3, JsonDeserializer<Object> p4){ return null; }
    protected ObjectMapper(ObjectMapper p0){}
    protected ObjectReader _newReader(DeserializationConfig p0){ return null; }
    protected ObjectReader _newReader(DeserializationConfig p0, JavaType p1, Object p2, FormatSchema p3, InjectableValues p4){ return null; }
    protected ObjectWriter _newWriter(SerializationConfig p0){ return null; }
    protected ObjectWriter _newWriter(SerializationConfig p0, FormatSchema p1){ return null; }
    protected ObjectWriter _newWriter(SerializationConfig p0, JavaType p1, PrettyPrinter p2){ return null; }
    protected PrettyPrinter _defaultPrettyPrinter(){ return null; }
    protected SerializationConfig _serializationConfig = null;
    protected SerializerFactory _serializerFactory = null;
    protected Set<Object> _registeredModuleTypes = null;
    protected SimpleMixInResolver _mixIns = null;
    protected SubtypeResolver _subtypeResolver = null;
    protected TypeFactory _typeFactory = null;
    protected final ConcurrentHashMap<JavaType, JsonDeserializer<Object>> _rootDeserializers = null;
    protected final JsonFactory _jsonFactory = null;
    protected final void _configAndWriteValue(JsonGenerator p0, Object p1){}
    protected final void _configAndWriteValue(JsonGenerator p0, Object p1, Class<? extends Object> p2){}
    protected static AnnotationIntrospector DEFAULT_ANNOTATION_INTROSPECTOR = null;
    protected static BaseSettings DEFAULT_BASE = null;
    protected static PrettyPrinter _defaultPrettyPrinter = null;
    protected static VisibilityChecker<? extends Object> STD_VISIBILITY_CHECKER = null;
    protected void _checkInvalidCopy(Class<? extends Object> p0){}
    protected void _verifySchemaType(FormatSchema p0){}
    public <T extends JsonNode> T valueToTree(Object p0){ return null; }
    public <T extends TreeNode> T readTree(JsonParser p0){ return null; }
    public <T> MappingIterator<T> readValues(JsonParser p0, Class<T> p1){ return null; }
    public <T> MappingIterator<T> readValues(JsonParser p0, JavaType p1){ return null; }
    public <T> MappingIterator<T> readValues(JsonParser p0, ResolvedType p1){ return null; }
    public <T> MappingIterator<T> readValues(JsonParser p0, TypeReference<? extends Object> p1){ return null; }
    public <T> T convertValue(Object p0, Class<T> p1){ return null; }
    public <T> T convertValue(Object p0, JavaType p1){ return null; }
    public <T> T convertValue(Object p0, TypeReference<? extends Object> p1){ return null; }
    public <T> T readValue(File p0, Class<T> p1){ return null; }
    public <T> T readValue(File p0, JavaType p1){ return null; }
    public <T> T readValue(File p0, TypeReference p1){ return null; }
    public <T> T readValue(InputStream p0, Class<T> p1){ return null; }
    public <T> T readValue(InputStream p0, JavaType p1){ return null; }
    public <T> T readValue(InputStream p0, TypeReference p1){ return null; }
    public <T> T readValue(JsonParser p0, Class<T> p1){ return null; }
    public <T> T readValue(JsonParser p0, JavaType p1){ return null; }
    public <T> T readValue(JsonParser p0, TypeReference<? extends Object> p1){ return null; }
    public <T> T readValue(Reader p0, Class<T> p1){ return null; }
    public <T> T readValue(Reader p0, JavaType p1){ return null; }
    public <T> T readValue(Reader p0, TypeReference p1){ return null; }
    public <T> T readValue(String p0, Class<T> p1){ return null; }
    public <T> T readValue(String p0, JavaType p1){ return null; }
    public <T> T readValue(String p0, TypeReference p1){ return null; }
    public <T> T readValue(URL p0, Class<T> p1){ return null; }
    public <T> T readValue(URL p0, JavaType p1){ return null; }
    public <T> T readValue(URL p0, TypeReference p1){ return null; }
    public <T> T readValue(byte[] p0, Class<T> p1){ return null; }
    public <T> T readValue(byte[] p0, JavaType p1){ return null; }
    public <T> T readValue(byte[] p0, TypeReference p1){ return null; }
    public <T> T readValue(byte[] p0, int p1, int p2, Class<T> p3){ return null; }
    public <T> T readValue(byte[] p0, int p1, int p2, JavaType p3){ return null; }
    public <T> T readValue(byte[] p0, int p1, int p2, TypeReference p3){ return null; }
    public <T> T treeToValue(TreeNode p0, Class<T> p1){ return null; }
    public ArrayNode createArrayNode(){ return null; }
    public Class<? extends Object> findMixInClassFor(Class<? extends Object> p0){ return null; }
    public DateFormat getDateFormat(){ return null; }
    public DeserializationConfig getDeserializationConfig(){ return null; }
    public DeserializationContext getDeserializationContext(){ return null; }
    public InjectableValues getInjectableValues(){ return null; }
    public JavaType constructType(Type p0){ return null; }
    public JsonFactory getFactory(){ return null; }
    public JsonFactory getJsonFactory(){ return null; }
    public JsonNode readTree(File p0){ return null; }
    public JsonNode readTree(InputStream p0){ return null; }
    public JsonNode readTree(Reader p0){ return null; }
    public JsonNode readTree(String p0){ return null; }
    public JsonNode readTree(URL p0){ return null; }
    public JsonNode readTree(byte[] p0){ return null; }
    public JsonNodeFactory getNodeFactory(){ return null; }
    public JsonParser treeAsTokens(TreeNode p0){ return null; }
    public JsonSchema generateJsonSchema(Class<? extends Object> p0){ return null; }
    public Object setHandlerInstantiator(HandlerInstantiator p0){ return null; }
    public ObjectMapper addHandler(DeserializationProblemHandler p0){ return null; }
    public ObjectMapper addMixIn(Class<? extends Object> p0, Class<? extends Object> p1){ return null; }
    public ObjectMapper clearProblemHandlers(){ return null; }
    public ObjectMapper configure(DeserializationFeature p0, boolean p1){ return null; }
    public ObjectMapper configure(JsonGenerator.Feature p0, boolean p1){ return null; }
    public ObjectMapper configure(JsonParser.Feature p0, boolean p1){ return null; }
    public ObjectMapper configure(MapperFeature p0, boolean p1){ return null; }
    public ObjectMapper configure(SerializationFeature p0, boolean p1){ return null; }
    public ObjectMapper copy(){ return null; }
    public ObjectMapper disable(DeserializationFeature p0){ return null; }
    public ObjectMapper disable(DeserializationFeature p0, DeserializationFeature... p1){ return null; }
    public ObjectMapper disable(JsonGenerator.Feature... p0){ return null; }
    public ObjectMapper disable(JsonParser.Feature... p0){ return null; }
    public ObjectMapper disable(MapperFeature... p0){ return null; }
    public ObjectMapper disable(SerializationFeature p0){ return null; }
    public ObjectMapper disable(SerializationFeature p0, SerializationFeature... p1){ return null; }
    public ObjectMapper disableDefaultTyping(){ return null; }
    public ObjectMapper enable(DeserializationFeature p0){ return null; }
    public ObjectMapper enable(DeserializationFeature p0, DeserializationFeature... p1){ return null; }
    public ObjectMapper enable(JsonGenerator.Feature... p0){ return null; }
    public ObjectMapper enable(JsonParser.Feature... p0){ return null; }
    public ObjectMapper enable(MapperFeature... p0){ return null; }
    public ObjectMapper enable(SerializationFeature p0){ return null; }
    public ObjectMapper enable(SerializationFeature p0, SerializationFeature... p1){ return null; }
    public ObjectMapper enableDefaultTyping(){ return null; }
    public ObjectMapper enableDefaultTyping(ObjectMapper.DefaultTyping p0){ return null; }
    public ObjectMapper enableDefaultTyping(ObjectMapper.DefaultTyping p0, JsonTypeInfo.As p1){ return null; }
    public ObjectMapper enableDefaultTypingAsProperty(ObjectMapper.DefaultTyping p0, String p1){ return null; }
    public ObjectMapper findAndRegisterModules(){ return null; }
    public ObjectMapper registerModule(Module p0){ return null; }
    public ObjectMapper registerModules(Iterable<Module> p0){ return null; }
    public ObjectMapper registerModules(Module... p0){ return null; }
    public ObjectMapper setAnnotationIntrospector(AnnotationIntrospector p0){ return null; }
    public ObjectMapper setAnnotationIntrospectors(AnnotationIntrospector p0, AnnotationIntrospector p1){ return null; }
    public ObjectMapper setBase64Variant(Base64Variant p0){ return null; }
    public ObjectMapper setConfig(DeserializationConfig p0){ return null; }
    public ObjectMapper setConfig(SerializationConfig p0){ return null; }
    public ObjectMapper setDateFormat(DateFormat p0){ return null; }
    public ObjectMapper setDefaultPrettyPrinter(PrettyPrinter p0){ return null; }
    public ObjectMapper setDefaultTyping(TypeResolverBuilder<? extends Object> p0){ return null; }
    public ObjectMapper setFilterProvider(FilterProvider p0){ return null; }
    public ObjectMapper setInjectableValues(InjectableValues p0){ return null; }
    public ObjectMapper setLocale(Locale p0){ return null; }
    public ObjectMapper setMixInResolver(ClassIntrospector.MixInResolver p0){ return null; }
    public ObjectMapper setMixIns(Map<Class<? extends Object>, Class<? extends Object>> p0){ return null; }
    public ObjectMapper setNodeFactory(JsonNodeFactory p0){ return null; }
    public ObjectMapper setPropertyInclusion(JsonInclude.Value p0){ return null; }
    public ObjectMapper setPropertyNamingStrategy(PropertyNamingStrategy p0){ return null; }
    public ObjectMapper setSerializationInclusion(JsonInclude.Include p0){ return null; }
    public ObjectMapper setSerializerFactory(SerializerFactory p0){ return null; }
    public ObjectMapper setSerializerProvider(DefaultSerializerProvider p0){ return null; }
    public ObjectMapper setSubtypeResolver(SubtypeResolver p0){ return null; }
    public ObjectMapper setTimeZone(TimeZone p0){ return null; }
    public ObjectMapper setTypeFactory(TypeFactory p0){ return null; }
    public ObjectMapper setVisibility(PropertyAccessor p0, JsonAutoDetect.Visibility p1){ return null; }
    public ObjectMapper setVisibility(VisibilityChecker<? extends Object> p0){ return null; }
    public ObjectMapper(){}
    public ObjectMapper(JsonFactory p0){}
    public ObjectMapper(JsonFactory p0, DefaultSerializerProvider p1, DefaultDeserializationContext p2){}
    public ObjectNode createObjectNode(){ return null; }
    public ObjectReader reader(){ return null; }
    public ObjectReader reader(Base64Variant p0){ return null; }
    public ObjectReader reader(Class<? extends Object> p0){ return null; }
    public ObjectReader reader(ContextAttributes p0){ return null; }
    public ObjectReader reader(DeserializationFeature p0){ return null; }
    public ObjectReader reader(DeserializationFeature p0, DeserializationFeature... p1){ return null; }
    public ObjectReader reader(FormatSchema p0){ return null; }
    public ObjectReader reader(InjectableValues p0){ return null; }
    public ObjectReader reader(JavaType p0){ return null; }
    public ObjectReader reader(JsonNodeFactory p0){ return null; }
    public ObjectReader reader(TypeReference<? extends Object> p0){ return null; }
    public ObjectReader readerFor(Class<? extends Object> p0){ return null; }
    public ObjectReader readerFor(JavaType p0){ return null; }
    public ObjectReader readerFor(TypeReference<? extends Object> p0){ return null; }
    public ObjectReader readerForUpdating(Object p0){ return null; }
    public ObjectReader readerWithView(Class<? extends Object> p0){ return null; }
    public ObjectWriter writer(){ return null; }
    public ObjectWriter writer(Base64Variant p0){ return null; }
    public ObjectWriter writer(CharacterEscapes p0){ return null; }
    public ObjectWriter writer(ContextAttributes p0){ return null; }
    public ObjectWriter writer(DateFormat p0){ return null; }
    public ObjectWriter writer(FilterProvider p0){ return null; }
    public ObjectWriter writer(FormatSchema p0){ return null; }
    public ObjectWriter writer(PrettyPrinter p0){ return null; }
    public ObjectWriter writer(SerializationFeature p0){ return null; }
    public ObjectWriter writer(SerializationFeature p0, SerializationFeature... p1){ return null; }
    public ObjectWriter writerFor(Class<? extends Object> p0){ return null; }
    public ObjectWriter writerFor(JavaType p0){ return null; }
    public ObjectWriter writerFor(TypeReference<? extends Object> p0){ return null; }
    public ObjectWriter writerWithDefaultPrettyPrinter(){ return null; }
    public ObjectWriter writerWithType(Class<? extends Object> p0){ return null; }
    public ObjectWriter writerWithType(JavaType p0){ return null; }
    public ObjectWriter writerWithType(TypeReference<? extends Object> p0){ return null; }
    public ObjectWriter writerWithView(Class<? extends Object> p0){ return null; }
    public PropertyNamingStrategy getPropertyNamingStrategy(){ return null; }
    public SerializationConfig getSerializationConfig(){ return null; }
    public SerializerFactory getSerializerFactory(){ return null; }
    public SerializerProvider getSerializerProvider(){ return null; }
    public SerializerProvider getSerializerProviderInstance(){ return null; }
    public String writeValueAsString(Object p0){ return null; }
    public SubtypeResolver getSubtypeResolver(){ return null; }
    public TypeFactory getTypeFactory(){ return null; }
    public Version version(){ return null; }
    public VisibilityChecker<? extends Object> getVisibilityChecker(){ return null; }
    public boolean canDeserialize(JavaType p0){ return false; }
    public boolean canDeserialize(JavaType p0, AtomicReference<Throwable> p1){ return false; }
    public boolean canSerialize(Class<? extends Object> p0){ return false; }
    public boolean canSerialize(Class<? extends Object> p0, AtomicReference<Throwable> p1){ return false; }
    public boolean isEnabled(DeserializationFeature p0){ return false; }
    public boolean isEnabled(JsonFactory.Feature p0){ return false; }
    public boolean isEnabled(JsonGenerator.Feature p0){ return false; }
    public boolean isEnabled(JsonParser.Feature p0){ return false; }
    public boolean isEnabled(MapperFeature p0){ return false; }
    public boolean isEnabled(SerializationFeature p0){ return false; }
    public byte[] writeValueAsBytes(Object p0){ return null; }
    public final <T> T readValue(JsonParser p0, ResolvedType p1){ return null; }
    public final void addMixInAnnotations(Class<? extends Object> p0, Class<? extends Object> p1){}
    public int mixInCount(){ return 0; }
    public static List<Module> findModules(){ return null; }
    public static List<Module> findModules(ClassLoader p0){ return null; }
    public void acceptJsonFormatVisitor(Class<? extends Object> p0, JsonFormatVisitorWrapper p1){}
    public void acceptJsonFormatVisitor(JavaType p0, JsonFormatVisitorWrapper p1){}
    public void registerSubtypes(Class<? extends Object>... p0){}
    public void registerSubtypes(NamedType... p0){}
    public void setFilters(FilterProvider p0){}
    public void setMixInAnnotations(Map<Class<? extends Object>, Class<? extends Object>> p0){}
    public void setVisibilityChecker(VisibilityChecker<? extends Object> p0){}
    public void writeTree(JsonGenerator p0, JsonNode p1){}
    public void writeTree(JsonGenerator p0, TreeNode p1){}
    public void writeValue(File p0, Object p1){}
    public void writeValue(JsonGenerator p0, Object p1){}
    public void writeValue(OutputStream p0, Object p1){}
    public void writeValue(Writer p0, Object p1){}
    static public enum DefaultTyping
    {
        JAVA_LANG_OBJECT, NON_CONCRETE_AND_ARRAYS, NON_FINAL, OBJECT_AND_NON_CONCRETE;
        private DefaultTyping() {}
    }
}
