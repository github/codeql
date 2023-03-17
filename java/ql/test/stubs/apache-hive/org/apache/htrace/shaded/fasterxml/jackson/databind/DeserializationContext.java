// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.DeserializationContext for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind;

import java.io.Serializable;
import java.text.DateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;
import java.util.TimeZone;
import java.util.concurrent.atomic.AtomicReference;
import org.apache.htrace.shaded.fasterxml.jackson.annotation.ObjectIdGenerator;
import org.apache.htrace.shaded.fasterxml.jackson.annotation.ObjectIdResolver;
import org.apache.htrace.shaded.fasterxml.jackson.core.Base64Variant;
import org.apache.htrace.shaded.fasterxml.jackson.core.JsonParser;
import org.apache.htrace.shaded.fasterxml.jackson.core.JsonToken;
import org.apache.htrace.shaded.fasterxml.jackson.databind.AnnotationIntrospector;
import org.apache.htrace.shaded.fasterxml.jackson.databind.BeanProperty;
import org.apache.htrace.shaded.fasterxml.jackson.databind.DatabindContext;
import org.apache.htrace.shaded.fasterxml.jackson.databind.DeserializationConfig;
import org.apache.htrace.shaded.fasterxml.jackson.databind.DeserializationFeature;
import org.apache.htrace.shaded.fasterxml.jackson.databind.InjectableValues;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JavaType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JsonDeserializer;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JsonMappingException;
import org.apache.htrace.shaded.fasterxml.jackson.databind.KeyDeserializer;
import org.apache.htrace.shaded.fasterxml.jackson.databind.cfg.ContextAttributes;
import org.apache.htrace.shaded.fasterxml.jackson.databind.deser.DeserializerCache;
import org.apache.htrace.shaded.fasterxml.jackson.databind.deser.DeserializerFactory;
import org.apache.htrace.shaded.fasterxml.jackson.databind.deser.impl.ReadableObjectId;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.Annotated;
import org.apache.htrace.shaded.fasterxml.jackson.databind.node.JsonNodeFactory;
import org.apache.htrace.shaded.fasterxml.jackson.databind.type.TypeFactory;
import org.apache.htrace.shaded.fasterxml.jackson.databind.util.ArrayBuilders;
import org.apache.htrace.shaded.fasterxml.jackson.databind.util.ObjectBuffer;

abstract public class DeserializationContext extends DatabindContext implements Serializable
{
    protected DeserializationContext() {}
    protected ArrayBuilders _arrayBuilders = null;
    protected ContextAttributes _attributes = null;
    protected DateFormat _dateFormat = null;
    protected DateFormat getDateFormat(){ return null; }
    protected DeserializationContext(DeserializationContext p0, DeserializationConfig p1, JsonParser p2, InjectableValues p3){}
    protected DeserializationContext(DeserializationContext p0, DeserializerFactory p1){}
    protected DeserializationContext(DeserializerFactory p0){}
    protected DeserializationContext(DeserializerFactory p0, DeserializerCache p1){}
    protected JsonParser _parser = null;
    protected ObjectBuffer _objectBuffer = null;
    protected String _calcName(Class<? extends Object> p0){ return null; }
    protected String _desc(String p0){ return null; }
    protected String _valueDesc(){ return null; }
    protected String determineClassName(Object p0){ return null; }
    protected final Class<? extends Object> _view = null;
    protected final DeserializationConfig _config = null;
    protected final DeserializerCache _cache = null;
    protected final DeserializerFactory _factory = null;
    protected final InjectableValues _injectableValues = null;
    protected final int _featureFlags = 0;
    public <T> T readPropertyValue(JsonParser p0, BeanProperty p1, JavaType p2){ return null; }
    public <T> T readPropertyValue(JsonParser p0, BeanProperty p1, java.lang.Class<T> p2){ return null; }
    public <T> T readValue(JsonParser p0, JavaType p1){ return null; }
    public <T> T readValue(JsonParser p0, java.lang.Class<T> p1){ return null; }
    public Calendar constructCalendar(Date p0){ return null; }
    public Class<? extends Object> findClass(String p0){ return null; }
    public Date parseDate(String p0){ return null; }
    public DeserializationConfig getConfig(){ return null; }
    public DeserializationContext setAttribute(Object p0, Object p1){ return null; }
    public DeserializerFactory getFactory(){ return null; }
    public JsonDeserializer<? extends Object> handlePrimaryContextualization(JsonDeserializer<? extends Object> p0, BeanProperty p1){ return null; }
    public JsonDeserializer<? extends Object> handleSecondaryContextualization(JsonDeserializer<? extends Object> p0, BeanProperty p1){ return null; }
    public JsonMappingException endOfInputException(Class<? extends Object> p0){ return null; }
    public JsonMappingException instantiationException(Class<? extends Object> p0, String p1){ return null; }
    public JsonMappingException instantiationException(Class<? extends Object> p0, Throwable p1){ return null; }
    public JsonMappingException mappingException(Class<? extends Object> p0){ return null; }
    public JsonMappingException mappingException(Class<? extends Object> p0, JsonToken p1){ return null; }
    public JsonMappingException mappingException(String p0){ return null; }
    public JsonMappingException unknownTypeException(JavaType p0, String p1){ return null; }
    public JsonMappingException weirdKeyException(Class<? extends Object> p0, String p1, String p2){ return null; }
    public JsonMappingException weirdNumberException(Class<? extends Object> p0, String p1){ return null; }
    public JsonMappingException weirdNumberException(Number p0, Class<? extends Object> p1, String p2){ return null; }
    public JsonMappingException weirdStringException(Class<? extends Object> p0, String p1){ return null; }
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
    public final JsonDeserializer<Object> findRootValueDeserializer(JavaType p0){ return null; }
    public final JsonNodeFactory getNodeFactory(){ return null; }
    public final JsonParser getParser(){ return null; }
    public final KeyDeserializer findKeyDeserializer(JavaType p0, BeanProperty p1){ return null; }
    public final Object findInjectableValue(Object p0, BeanProperty p1, Object p2){ return null; }
    public final ObjectBuffer leaseObjectBuffer(){ return null; }
    public final TypeFactory getTypeFactory(){ return null; }
    public final boolean hasDeserializationFeatures(int p0){ return false; }
    public final boolean isEnabled(DeserializationFeature p0){ return false; }
    public final void returnObjectBuffer(ObjectBuffer p0){}
    public void reportUnknownProperty(Object p0, String p1, JsonDeserializer<? extends Object> p2){}
}
