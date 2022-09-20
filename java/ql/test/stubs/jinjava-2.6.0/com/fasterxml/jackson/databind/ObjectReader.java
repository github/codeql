// Generated automatically from com.fasterxml.jackson.databind.ObjectReader for testing purposes

package com.fasterxml.jackson.databind;

import com.fasterxml.jackson.core.Base64Variant;
import com.fasterxml.jackson.core.FormatFeature;
import com.fasterxml.jackson.core.FormatSchema;
import com.fasterxml.jackson.core.JsonFactory;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.JsonPointer;
import com.fasterxml.jackson.core.JsonToken;
import com.fasterxml.jackson.core.ObjectCodec;
import com.fasterxml.jackson.core.TreeNode;
import com.fasterxml.jackson.core.Version;
import com.fasterxml.jackson.core.Versioned;
import com.fasterxml.jackson.core.filter.TokenFilter;
import com.fasterxml.jackson.core.type.ResolvedType;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.DeserializationConfig;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.InjectableValues;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.MapperFeature;
import com.fasterxml.jackson.databind.MappingIterator;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyName;
import com.fasterxml.jackson.databind.cfg.ContextAttributes;
import com.fasterxml.jackson.databind.deser.DataFormatReaders;
import com.fasterxml.jackson.databind.deser.DefaultDeserializationContext;
import com.fasterxml.jackson.databind.deser.DeserializationProblemHandler;
import com.fasterxml.jackson.databind.node.JsonNodeFactory;
import com.fasterxml.jackson.databind.type.TypeFactory;
import java.io.File;
import java.io.InputStream;
import java.io.Reader;
import java.io.Serializable;
import java.lang.reflect.Type;
import java.net.URL;
import java.util.Iterator;
import java.util.Locale;
import java.util.Map;
import java.util.TimeZone;
import java.util.concurrent.ConcurrentHashMap;

public class ObjectReader extends ObjectCodec implements Serializable, Versioned
{
    protected ObjectReader() {}
    protected <T> MappingIterator<T> _bindAndReadValues(JsonParser p0){ return null; }
    protected <T> MappingIterator<T> _detectBindAndReadValues(DataFormatReaders.Match p0, boolean p1){ return null; }
    protected <T> MappingIterator<T> _newIterator(JsonParser p0, DeserializationContext p1, JsonDeserializer<? extends Object> p2, boolean p3){ return null; }
    protected DefaultDeserializationContext createDeserializationContext(JsonParser p0){ return null; }
    protected InputStream _inputStream(File p0){ return null; }
    protected InputStream _inputStream(URL p0){ return null; }
    protected JsonDeserializer<Object> _findRootDeserializer(DeserializationContext p0){ return null; }
    protected JsonDeserializer<Object> _findTreeDeserializer(DeserializationContext p0){ return null; }
    protected JsonDeserializer<Object> _prefetchRootDeserializer(JavaType p0){ return null; }
    protected JsonNode _bindAndCloseAsTree(JsonParser p0){ return null; }
    protected JsonNode _bindAsTree(JsonParser p0){ return null; }
    protected JsonNode _detectBindAndCloseAsTree(InputStream p0){ return null; }
    protected JsonParser _considerFilter(JsonParser p0, boolean p1){ return null; }
    protected JsonToken _initForReading(JsonParser p0){ return null; }
    protected Object _bind(JsonParser p0, Object p1){ return null; }
    protected Object _bindAndClose(JsonParser p0){ return null; }
    protected Object _detectBindAndClose(DataFormatReaders.Match p0, boolean p1){ return null; }
    protected Object _detectBindAndClose(byte[] p0, int p1, int p2){ return null; }
    protected Object _unwrapAndDeserialize(JsonParser p0, DeserializationContext p1, JavaType p2, JsonDeserializer<Object> p3){ return null; }
    protected ObjectReader _new(ObjectReader p0, DeserializationConfig p1){ return null; }
    protected ObjectReader _new(ObjectReader p0, DeserializationConfig p1, JavaType p2, JsonDeserializer<Object> p3, Object p4, FormatSchema p5, InjectableValues p6, DataFormatReaders p7){ return null; }
    protected ObjectReader _new(ObjectReader p0, JsonFactory p1){ return null; }
    protected ObjectReader _with(DeserializationConfig p0){ return null; }
    protected ObjectReader(ObjectMapper p0, DeserializationConfig p1){}
    protected ObjectReader(ObjectMapper p0, DeserializationConfig p1, JavaType p2, Object p3, FormatSchema p4, InjectableValues p5){}
    protected ObjectReader(ObjectReader p0, DeserializationConfig p1){}
    protected ObjectReader(ObjectReader p0, DeserializationConfig p1, JavaType p2, JsonDeserializer<Object> p3, Object p4, FormatSchema p5, InjectableValues p6, DataFormatReaders p7){}
    protected ObjectReader(ObjectReader p0, JsonFactory p1){}
    protected ObjectReader(ObjectReader p0, TokenFilter p1){}
    protected final ConcurrentHashMap<JavaType, JsonDeserializer<Object>> _rootDeserializers = null;
    protected final DataFormatReaders _dataFormatReaders = null;
    protected final DefaultDeserializationContext _context = null;
    protected final DeserializationConfig _config = null;
    protected final FormatSchema _schema = null;
    protected final InjectableValues _injectableValues = null;
    protected final JavaType _valueType = null;
    protected final JsonDeserializer<Object> _rootDeserializer = null;
    protected final JsonFactory _parserFactory = null;
    protected final Object _valueToUpdate = null;
    protected final boolean _unwrapRoot = false;
    protected void _initForMultiRead(JsonParser p0){}
    protected void _reportUndetectableSource(Object p0){}
    protected void _reportUnkownFormat(DataFormatReaders p0, DataFormatReaders.Match p1){}
    protected void _verifySchemaType(FormatSchema p0){}
    public <T extends TreeNode> T readTree(JsonParser p0){ return null; }
    public <T> Iterator<T> readValues(JsonParser p0, Class<T> p1){ return null; }
    public <T> Iterator<T> readValues(JsonParser p0, JavaType p1){ return null; }
    public <T> Iterator<T> readValues(JsonParser p0, ResolvedType p1){ return null; }
    public <T> Iterator<T> readValues(JsonParser p0, TypeReference<? extends Object> p1){ return null; }
    public <T> MappingIterator<T> readValues(File p0){ return null; }
    public <T> MappingIterator<T> readValues(InputStream p0){ return null; }
    public <T> MappingIterator<T> readValues(JsonParser p0){ return null; }
    public <T> MappingIterator<T> readValues(Reader p0){ return null; }
    public <T> MappingIterator<T> readValues(String p0){ return null; }
    public <T> MappingIterator<T> readValues(URL p0){ return null; }
    public <T> MappingIterator<T> readValues(byte[] p0, int p1, int p2){ return null; }
    public <T> T readValue(File p0){ return null; }
    public <T> T readValue(InputStream p0){ return null; }
    public <T> T readValue(JsonNode p0){ return null; }
    public <T> T readValue(JsonParser p0){ return null; }
    public <T> T readValue(JsonParser p0, Class<T> p1){ return null; }
    public <T> T readValue(JsonParser p0, JavaType p1){ return null; }
    public <T> T readValue(JsonParser p0, ResolvedType p1){ return null; }
    public <T> T readValue(JsonParser p0, TypeReference<? extends Object> p1){ return null; }
    public <T> T readValue(Reader p0){ return null; }
    public <T> T readValue(String p0){ return null; }
    public <T> T readValue(URL p0){ return null; }
    public <T> T readValue(byte[] p0){ return null; }
    public <T> T readValue(byte[] p0, int p1, int p2){ return null; }
    public <T> T treeToValue(TreeNode p0, Class<T> p1){ return null; }
    public ContextAttributes getAttributes(){ return null; }
    public DeserializationConfig getConfig(){ return null; }
    public InjectableValues getInjectableValues(){ return null; }
    public JsonFactory getFactory(){ return null; }
    public JsonNode createArrayNode(){ return null; }
    public JsonNode createObjectNode(){ return null; }
    public JsonNode readTree(InputStream p0){ return null; }
    public JsonNode readTree(Reader p0){ return null; }
    public JsonNode readTree(String p0){ return null; }
    public JsonParser treeAsTokens(TreeNode p0){ return null; }
    public ObjectReader at(JsonPointer p0){ return null; }
    public ObjectReader at(String p0){ return null; }
    public ObjectReader forType(Class<? extends Object> p0){ return null; }
    public ObjectReader forType(JavaType p0){ return null; }
    public ObjectReader forType(TypeReference<? extends Object> p0){ return null; }
    public ObjectReader with(Base64Variant p0){ return null; }
    public ObjectReader with(ContextAttributes p0){ return null; }
    public ObjectReader with(DeserializationConfig p0){ return null; }
    public ObjectReader with(DeserializationFeature p0){ return null; }
    public ObjectReader with(DeserializationFeature p0, DeserializationFeature... p1){ return null; }
    public ObjectReader with(FormatFeature p0){ return null; }
    public ObjectReader with(FormatSchema p0){ return null; }
    public ObjectReader with(InjectableValues p0){ return null; }
    public ObjectReader with(JsonFactory p0){ return null; }
    public ObjectReader with(JsonNodeFactory p0){ return null; }
    public ObjectReader with(JsonParser.Feature p0){ return null; }
    public ObjectReader with(Locale p0){ return null; }
    public ObjectReader with(TimeZone p0){ return null; }
    public ObjectReader withAttribute(Object p0, Object p1){ return null; }
    public ObjectReader withAttributes(Map<? extends Object, ? extends Object> p0){ return null; }
    public ObjectReader withFeatures(DeserializationFeature... p0){ return null; }
    public ObjectReader withFeatures(FormatFeature... p0){ return null; }
    public ObjectReader withFeatures(JsonParser.Feature... p0){ return null; }
    public ObjectReader withFormatDetection(DataFormatReaders p0){ return null; }
    public ObjectReader withFormatDetection(ObjectReader... p0){ return null; }
    public ObjectReader withHandler(DeserializationProblemHandler p0){ return null; }
    public ObjectReader withRootName(PropertyName p0){ return null; }
    public ObjectReader withRootName(String p0){ return null; }
    public ObjectReader withType(Class<? extends Object> p0){ return null; }
    public ObjectReader withType(JavaType p0){ return null; }
    public ObjectReader withType(Type p0){ return null; }
    public ObjectReader withType(TypeReference<? extends Object> p0){ return null; }
    public ObjectReader withValueToUpdate(Object p0){ return null; }
    public ObjectReader withView(Class<? extends Object> p0){ return null; }
    public ObjectReader without(DeserializationFeature p0){ return null; }
    public ObjectReader without(DeserializationFeature p0, DeserializationFeature... p1){ return null; }
    public ObjectReader without(FormatFeature p0){ return null; }
    public ObjectReader without(JsonParser.Feature p0){ return null; }
    public ObjectReader withoutAttribute(Object p0){ return null; }
    public ObjectReader withoutFeatures(DeserializationFeature... p0){ return null; }
    public ObjectReader withoutFeatures(FormatFeature... p0){ return null; }
    public ObjectReader withoutFeatures(JsonParser.Feature... p0){ return null; }
    public ObjectReader withoutRootName(){ return null; }
    public TypeFactory getTypeFactory(){ return null; }
    public Version version(){ return null; }
    public boolean isEnabled(DeserializationFeature p0){ return false; }
    public boolean isEnabled(JsonParser.Feature p0){ return false; }
    public boolean isEnabled(MapperFeature p0){ return false; }
    public final <T> MappingIterator<T> readValues(byte[] p0){ return null; }
    public void writeTree(JsonGenerator p0, TreeNode p1){}
    public void writeValue(JsonGenerator p0, Object p1){}
}
