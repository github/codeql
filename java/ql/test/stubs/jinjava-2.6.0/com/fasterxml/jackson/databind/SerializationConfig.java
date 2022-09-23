// Generated automatically from com.fasterxml.jackson.databind.SerializationConfig for testing purposes

package com.fasterxml.jackson.databind;

import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.PropertyAccessor;
import com.fasterxml.jackson.core.Base64Variant;
import com.fasterxml.jackson.core.FormatFeature;
import com.fasterxml.jackson.core.JsonFactory;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.core.PrettyPrinter;
import com.fasterxml.jackson.databind.AnnotationIntrospector;
import com.fasterxml.jackson.databind.BeanDescription;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.MapperFeature;
import com.fasterxml.jackson.databind.PropertyName;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.databind.cfg.BaseSettings;
import com.fasterxml.jackson.databind.cfg.ConfigFeature;
import com.fasterxml.jackson.databind.cfg.ContextAttributes;
import com.fasterxml.jackson.databind.cfg.HandlerInstantiator;
import com.fasterxml.jackson.databind.cfg.MapperConfigBase;
import com.fasterxml.jackson.databind.introspect.ClassIntrospector;
import com.fasterxml.jackson.databind.introspect.SimpleMixInResolver;
import com.fasterxml.jackson.databind.introspect.VisibilityChecker;
import com.fasterxml.jackson.databind.jsontype.SubtypeResolver;
import com.fasterxml.jackson.databind.jsontype.TypeResolverBuilder;
import com.fasterxml.jackson.databind.ser.FilterProvider;
import com.fasterxml.jackson.databind.type.TypeFactory;
import com.fasterxml.jackson.databind.util.RootNameLookup;
import java.io.Serializable;
import java.text.DateFormat;
import java.util.Locale;
import java.util.TimeZone;

public class SerializationConfig extends MapperConfigBase<SerializationFeature, SerializationConfig> implements Serializable
{
    protected SerializationConfig() {}
    protected SerializationConfig(SerializationConfig p0, ContextAttributes p1){}
    protected SerializationConfig(SerializationConfig p0, PrettyPrinter p1){}
    protected SerializationConfig(SerializationConfig p0, SimpleMixInResolver p1){}
    protected SerializationConfig(SerializationConfig p0, SimpleMixInResolver p1, RootNameLookup p2){}
    protected final FilterProvider _filterProvider = null;
    protected final JsonInclude.Value _serializationInclusion = null;
    protected final PrettyPrinter _defaultPrettyPrinter = null;
    protected final int _formatWriteFeatures = 0;
    protected final int _formatWriteFeaturesToChange = 0;
    protected final int _generatorFeatures = 0;
    protected final int _generatorFeaturesToChange = 0;
    protected final int _serFeatures = 0;
    protected static JsonInclude.Value DEFAULT_INCLUSION = null;
    protected static PrettyPrinter DEFAULT_PRETTY_PRINTER = null;
    public <T extends BeanDescription> T introspect(JavaType p0){ return null; }
    public AnnotationIntrospector getAnnotationIntrospector(){ return null; }
    public BeanDescription introspectClassAnnotations(JavaType p0){ return null; }
    public BeanDescription introspectDirectClassAnnotations(JavaType p0){ return null; }
    public FilterProvider getFilterProvider(){ return null; }
    public JsonFormat.Value getDefaultPropertyFormat(Class<? extends Object> p0){ return null; }
    public JsonInclude.Include getSerializationInclusion(){ return null; }
    public JsonInclude.Value getDefaultPropertyInclusion(){ return null; }
    public JsonInclude.Value getDefaultPropertyInclusion(Class<? extends Object> p0){ return null; }
    public PrettyPrinter constructDefaultPrettyPrinter(){ return null; }
    public PrettyPrinter getDefaultPrettyPrinter(){ return null; }
    public SerializationConfig with(AnnotationIntrospector p0){ return null; }
    public SerializationConfig with(Base64Variant p0){ return null; }
    public SerializationConfig with(ClassIntrospector p0){ return null; }
    public SerializationConfig with(ContextAttributes p0){ return null; }
    public SerializationConfig with(DateFormat p0){ return null; }
    public SerializationConfig with(FormatFeature p0){ return null; }
    public SerializationConfig with(HandlerInstantiator p0){ return null; }
    public SerializationConfig with(JsonGenerator.Feature p0){ return null; }
    public SerializationConfig with(Locale p0){ return null; }
    public SerializationConfig with(MapperFeature p0, boolean p1){ return null; }
    public SerializationConfig with(MapperFeature... p0){ return null; }
    public SerializationConfig with(PropertyNamingStrategy p0){ return null; }
    public SerializationConfig with(SerializationFeature p0){ return null; }
    public SerializationConfig with(SerializationFeature p0, SerializationFeature... p1){ return null; }
    public SerializationConfig with(SubtypeResolver p0){ return null; }
    public SerializationConfig with(TimeZone p0){ return null; }
    public SerializationConfig with(TypeFactory p0){ return null; }
    public SerializationConfig with(TypeResolverBuilder<? extends Object> p0){ return null; }
    public SerializationConfig with(VisibilityChecker<? extends Object> p0){ return null; }
    public SerializationConfig withAppendedAnnotationIntrospector(AnnotationIntrospector p0){ return null; }
    public SerializationConfig withDefaultPrettyPrinter(PrettyPrinter p0){ return null; }
    public SerializationConfig withFeatures(FormatFeature... p0){ return null; }
    public SerializationConfig withFeatures(JsonGenerator.Feature... p0){ return null; }
    public SerializationConfig withFeatures(SerializationFeature... p0){ return null; }
    public SerializationConfig withFilters(FilterProvider p0){ return null; }
    public SerializationConfig withInsertedAnnotationIntrospector(AnnotationIntrospector p0){ return null; }
    public SerializationConfig withPropertyInclusion(JsonInclude.Value p0){ return null; }
    public SerializationConfig withRootName(PropertyName p0){ return null; }
    public SerializationConfig withSerializationInclusion(JsonInclude.Include p0){ return null; }
    public SerializationConfig withView(Class<? extends Object> p0){ return null; }
    public SerializationConfig withVisibility(PropertyAccessor p0, JsonAutoDetect.Visibility p1){ return null; }
    public SerializationConfig without(FormatFeature p0){ return null; }
    public SerializationConfig without(JsonGenerator.Feature p0){ return null; }
    public SerializationConfig without(MapperFeature... p0){ return null; }
    public SerializationConfig without(SerializationFeature p0){ return null; }
    public SerializationConfig without(SerializationFeature p0, SerializationFeature... p1){ return null; }
    public SerializationConfig withoutFeatures(FormatFeature... p0){ return null; }
    public SerializationConfig withoutFeatures(JsonGenerator.Feature... p0){ return null; }
    public SerializationConfig withoutFeatures(SerializationFeature... p0){ return null; }
    public SerializationConfig(BaseSettings p0, SubtypeResolver p1, SimpleMixInResolver p2, RootNameLookup p3){}
    public String toString(){ return null; }
    public VisibilityChecker<? extends Object> getDefaultVisibilityChecker(){ return null; }
    public boolean useRootWrapping(){ return false; }
    public final boolean hasSerializationFeatures(int p0){ return false; }
    public final boolean isEnabled(JsonGenerator.Feature p0, JsonFactory p1){ return false; }
    public final boolean isEnabled(SerializationFeature p0){ return false; }
    public final int getSerializationFeatures(){ return 0; }
    public void initialize(JsonGenerator p0){}
}
