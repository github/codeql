// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.SerializationConfig for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind;

import java.io.Serializable;
import java.text.DateFormat;
import java.util.Locale;
import java.util.Map;
import java.util.TimeZone;
import org.apache.htrace.shaded.fasterxml.jackson.annotation.JsonAutoDetect;
import org.apache.htrace.shaded.fasterxml.jackson.annotation.JsonInclude;
import org.apache.htrace.shaded.fasterxml.jackson.annotation.PropertyAccessor;
import org.apache.htrace.shaded.fasterxml.jackson.core.Base64Variant;
import org.apache.htrace.shaded.fasterxml.jackson.databind.AnnotationIntrospector;
import org.apache.htrace.shaded.fasterxml.jackson.databind.BeanDescription;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JavaType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.MapperFeature;
import org.apache.htrace.shaded.fasterxml.jackson.databind.PropertyNamingStrategy;
import org.apache.htrace.shaded.fasterxml.jackson.databind.SerializationFeature;
import org.apache.htrace.shaded.fasterxml.jackson.databind.cfg.BaseSettings;
import org.apache.htrace.shaded.fasterxml.jackson.databind.cfg.ConfigFeature;
import org.apache.htrace.shaded.fasterxml.jackson.databind.cfg.ContextAttributes;
import org.apache.htrace.shaded.fasterxml.jackson.databind.cfg.HandlerInstantiator;
import org.apache.htrace.shaded.fasterxml.jackson.databind.cfg.MapperConfigBase;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.ClassIntrospector;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.VisibilityChecker;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsontype.SubtypeResolver;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsontype.TypeResolverBuilder;
import org.apache.htrace.shaded.fasterxml.jackson.databind.ser.FilterProvider;
import org.apache.htrace.shaded.fasterxml.jackson.databind.type.ClassKey;
import org.apache.htrace.shaded.fasterxml.jackson.databind.type.TypeFactory;

public class SerializationConfig extends MapperConfigBase<SerializationFeature, SerializationConfig> implements Serializable
{
    protected SerializationConfig() {}
    protected JsonInclude.Include _serializationInclusion = null;
    protected SerializationConfig(SerializationConfig p0, ContextAttributes p1){}
    protected SerializationConfig(SerializationConfig p0, Map<ClassKey, Class<? extends Object>> p1){}
    protected final FilterProvider _filterProvider = null;
    protected final int _serFeatures = 0;
    public <T extends BeanDescription> T introspect(JavaType p0){ return null; }
    public AnnotationIntrospector getAnnotationIntrospector(){ return null; }
    public BeanDescription introspectClassAnnotations(JavaType p0){ return null; }
    public BeanDescription introspectDirectClassAnnotations(JavaType p0){ return null; }
    public FilterProvider getFilterProvider(){ return null; }
    public JsonInclude.Include getSerializationInclusion(){ return null; }
    public SerializationConfig with(AnnotationIntrospector p0){ return null; }
    public SerializationConfig with(Base64Variant p0){ return null; }
    public SerializationConfig with(ClassIntrospector p0){ return null; }
    public SerializationConfig with(ContextAttributes p0){ return null; }
    public SerializationConfig with(DateFormat p0){ return null; }
    public SerializationConfig with(HandlerInstantiator p0){ return null; }
    public SerializationConfig with(Locale p0){ return null; }
    public SerializationConfig with(MapperFeature p0, boolean p1){ return null; }
    public SerializationConfig with(MapperFeature... p0){ return null; }
    public SerializationConfig with(PropertyNamingStrategy p0){ return null; }
    public SerializationConfig with(SerializationFeature p0, SerializationFeature... p1){ return null; }
    public SerializationConfig with(SubtypeResolver p0){ return null; }
    public SerializationConfig with(TimeZone p0){ return null; }
    public SerializationConfig with(TypeFactory p0){ return null; }
    public SerializationConfig with(TypeResolverBuilder<? extends Object> p0){ return null; }
    public SerializationConfig with(VisibilityChecker<? extends Object> p0){ return null; }
    public SerializationConfig withAppendedAnnotationIntrospector(AnnotationIntrospector p0){ return null; }
    public SerializationConfig withFeatures(SerializationFeature... p0){ return null; }
    public SerializationConfig withFilters(FilterProvider p0){ return null; }
    public SerializationConfig withInsertedAnnotationIntrospector(AnnotationIntrospector p0){ return null; }
    public SerializationConfig withRootName(String p0){ return null; }
    public SerializationConfig withSerializationInclusion(JsonInclude.Include p0){ return null; }
    public SerializationConfig withView(Class<? extends Object> p0){ return null; }
    public SerializationConfig withVisibility(PropertyAccessor p0, JsonAutoDetect.Visibility p1){ return null; }
    public SerializationConfig without(MapperFeature... p0){ return null; }
    public SerializationConfig without(SerializationFeature p0){ return null; }
    public SerializationConfig without(SerializationFeature p0, SerializationFeature... p1){ return null; }
    public SerializationConfig withoutFeatures(SerializationFeature... p0){ return null; }
    public SerializationConfig(BaseSettings p0, SubtypeResolver p1, Map<ClassKey, Class<? extends Object>> p2){}
    public String toString(){ return null; }
    public VisibilityChecker<? extends Object> getDefaultVisibilityChecker(){ return null; }
    public boolean useRootWrapping(){ return false; }
    public final boolean hasSerializationFeatures(int p0){ return false; }
    public final boolean isEnabled(SerializationFeature p0){ return false; }
    public final int getSerializationFeatures(){ return 0; }
}
