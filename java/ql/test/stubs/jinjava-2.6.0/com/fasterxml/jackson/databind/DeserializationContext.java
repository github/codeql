// Generated automatically from com.fasterxml.jackson.databind.DeserializationContext for testing purposes

package com.fasterxml.jackson.databind;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.ObjectIdGenerator;
import com.fasterxml.jackson.annotation.ObjectIdResolver;
import com.fasterxml.jackson.core.Base64Variant;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.JsonToken;
import com.fasterxml.jackson.databind.AnnotationIntrospector;
import com.fasterxml.jackson.databind.BeanProperty;
import com.fasterxml.jackson.databind.DatabindContext;
import com.fasterxml.jackson.databind.DeserializationConfig;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.InjectableValues;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.KeyDeserializer;
import com.fasterxml.jackson.databind.MapperFeature;
import com.fasterxml.jackson.databind.cfg.ContextAttributes;
import com.fasterxml.jackson.databind.deser.DeserializerCache;
import com.fasterxml.jackson.databind.deser.DeserializerFactory;
import com.fasterxml.jackson.databind.deser.impl.ReadableObjectId;
import com.fasterxml.jackson.databind.introspect.Annotated;
import com.fasterxml.jackson.databind.node.JsonNodeFactory;
import com.fasterxml.jackson.databind.type.TypeFactory;
import com.fasterxml.jackson.databind.util.ArrayBuilders;
import com.fasterxml.jackson.databind.util.LinkedNode;
import com.fasterxml.jackson.databind.util.ObjectBuffer;
import java.io.Serializable;
import java.text.DateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;
import java.util.TimeZone;
import java.util.concurrent.atomic.AtomicReference;

abstract public class DeserializationContext extends DatabindContext implements Serializable
{
    protected DeserializationContext() {}
    protected ArrayBuilders _arrayBuilders = null;
    protected ContextAttributes _attributes = null;
    protected DateFormat _dateFormat = null;
    protected DateFormat getDateFormat(){ return null; }
    protected DeserializationContext(DeserializationContext p0){}
    protected DeserializationContext(DeserializationContext p0, DeserializationConfig p1, JsonParser p2, InjectableValues p3){}
    protected DeserializationContext(DeserializationContext p0, DeserializerFactory p1){}
    protected DeserializationContext(DeserializerFactory p0){}
    protected DeserializationContext(DeserializerFactory p0, DeserializerCache p1){}
    protected JsonParser _parser = null;
    protected LinkedNode<JavaType> _currentType = null;
    protected ObjectBuffer _objectBuffer = null;
    protected String _calcName(Class<? extends Object> p0){ return null; }
    protected String _desc(String p0){ return null; }
    protected String _quotedString(String p0){ return null; }
    protected String _valueDesc(){ return null; }
    protected String determineClassName(Object p0){ return null; }
    protected final Class<? extends Object> _view = null;
    protected final DeserializationConfig _config = null;
    protected final DeserializerCache _cache = null;
    protected final DeserializerFactory _factory = null;
    protected final InjectableValues _injectableValues = null;
    protected final int _featureFlags = 0;
    public <T> T readPropertyValue(JsonParser p0, BeanProperty p1, Class<T> p2){ return null; }
    public <T> T readPropertyValue(JsonParser p0, BeanProperty p1, JavaType p2){ return null; }
    public <T> T readValue(JsonParser p0, Class<T> p1){ return null; }
    public <T> T readValue(JsonParser p0, JavaType p1){ return null; }
    public <T> T reportEndOfInputException(Class<? extends Object> p0){ return null; }
    public <T> T reportUnknownTypeException(JavaType p0, String p1, String p2){ return null; }
    public <T> T reportWeirdKeyException(Class<? extends Object> p0, String p1, String p2, Object... p3){ return null; }
    public <T> T reportWeirdNumberException(Number p0, Class<? extends Object> p1, String p2, Object... p3){ return null; }
    public <T> T reportWeirdStringException(String p0, Class<? extends Object> p1, String p2, Object... p3){ return null; }
    public <T> T reportWrongTokenException(JsonParser p0, JsonToken p1, String p2, Object... p3){ return null; }
    public Calendar constructCalendar(Date p0){ return null; }
    public Class<? extends Object> findClass(String p0){ return null; }
    public Date parseDate(String p0){ return null; }
    public DeserializationConfig getConfig(){ return null; }
    public DeserializationContext setAttribute(Object p0, Object p1){ return null; }
    public DeserializerFactory getFactory(){ return null; }
    public JavaType getContextualType(){ return null; }
    public JsonDeserializer<? extends Object> handlePrimaryContextualization(JsonDeserializer<? extends Object> p0, BeanProperty p1){ return null; }
    public JsonDeserializer<? extends Object> handlePrimaryContextualization(JsonDeserializer<? extends Object> p0, BeanProperty p1, JavaType p2){ return null; }
    public JsonDeserializer<? extends Object> handleSecondaryContextualization(JsonDeserializer<? extends Object> p0, BeanProperty p1){ return null; }
    public JsonDeserializer<? extends Object> handleSecondaryContextualization(JsonDeserializer<? extends Object> p0, BeanProperty p1, JavaType p2){ return null; }
    public JsonMappingException endOfInputException(Class<? extends Object> p0){ return null; }
    public JsonMappingException instantiationException(Class<? extends Object> p0, String p1){ return null; }
    public JsonMappingException instantiationException(Class<? extends Object> p0, Throwable p1){ return null; }
    public JsonMappingException mappingException(Class<? extends Object> p0){ return null; }
    public JsonMappingException mappingException(Class<? extends Object> p0, JsonToken p1){ return null; }
    public JsonMappingException mappingException(String p0){ return null; }
    public JsonMappingException mappingException(String p0, Object... p1){ return null; }
    public JsonMappingException reportInstantiationException(Class<? extends Object> p0, String p1, Object... p2){ return null; }
    public JsonMappingException reportInstantiationException(Class<? extends Object> p0, Throwable p1){ return null; }
    public JsonMappingException reportMappingException(String p0, Object... p1){ return null; }
    public JsonMappingException unknownTypeException(JavaType p0, String p1){ return null; }
    public JsonMappingException unknownTypeException(JavaType p0, String p1, String p2){ return null; }
    public JsonMappingException weirdKeyException(Class<? extends Object> p0, String p1, String p2){ return null; }
    public JsonMappingException weirdNumberException(Number p0, Class<? extends Object> p1, String p2){ return null; }
    public JsonMappingException weirdStringException(String p0, Class<? extends Object> p1, String p2){ return null; }
    public JsonMappingException wrongTokenException(JsonParser p0, JsonToken p1, String p2){ return null; }
    public Locale getLocale(){ return null; }
    public Object getAttribute(Object p0){ return null; }
    public TimeZone getTimeZone(){ return null; }
    public abstract JsonDeserializer<Object> deserializerInstance(Annotated p0, Object p1);
    public abstract KeyDeserializer keyDeserializerInstance(Annotated p0, Object p1);
    public abstract ReadableObjectId findObjectId(Object p0, ObjectIdGenerator<? extends Object> p1);
    public abstract ReadableObjectId findObjectId(Object p0, ObjectIdGenerator<? extends Object> p1, ObjectIdResolver p2);
    public abstract void checkUnresolvedObjectId();
    public boolean handleUnknownProperty(JsonParser p0, JsonDeserializer<? extends Object> p1, Object p2, String p3){ return false; }
    public boolean hasValueDeserializerFor(JavaType p0){ return false; }
    public boolean hasValueDeserializerFor(JavaType p0, AtomicReference<Throwable> p1){ return false; }
    public final AnnotationIntrospector getAnnotationIntrospector(){ return null; }
    public final ArrayBuilders getArrayBuilders(){ return null; }
    public final Base64Variant getBase64Variant(){ return null; }
    public final Class<? extends Object> getActiveView(){ return null; }
    public final JavaType constructType(Class<? extends Object> p0){ return null; }
    public final JsonDeserializer<Object> findContextualValueDeserializer(JavaType p0, BeanProperty p1){ return null; }
    public final JsonDeserializer<Object> findNonContextualValueDeserializer(JavaType p0){ return null; }
    public final JsonDeserializer<Object> findRootValueDeserializer(JavaType p0){ return null; }
    public final JsonFormat.Value getDefaultPropertyFormat(Class<? extends Object> p0){ return null; }
    public final JsonNodeFactory getNodeFactory(){ return null; }
    public final JsonParser getParser(){ return null; }
    public final KeyDeserializer findKeyDeserializer(JavaType p0, BeanProperty p1){ return null; }
    public final Object findInjectableValue(Object p0, BeanProperty p1, Object p2){ return null; }
    public final ObjectBuffer leaseObjectBuffer(){ return null; }
    public final TypeFactory getTypeFactory(){ return null; }
    public final boolean canOverrideAccessModifiers(){ return false; }
    public final boolean hasDeserializationFeatures(int p0){ return false; }
    public final boolean hasSomeOfFeatures(int p0){ return false; }
    public final boolean isEnabled(DeserializationFeature p0){ return false; }
    public final boolean isEnabled(MapperFeature p0){ return false; }
    public final int getDeserializationFeatures(){ return 0; }
    public final void returnObjectBuffer(ObjectBuffer p0){}
    public void reportUnknownProperty(Object p0, String p1, JsonDeserializer<? extends Object> p2){}
}
