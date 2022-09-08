// Generated automatically from com.fasterxml.jackson.databind.DeserializationConfig for testing purposes

package com.fasterxml.jackson.databind;

import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.PropertyAccessor;
import com.fasterxml.jackson.core.Base64Variant;
import com.fasterxml.jackson.core.FormatFeature;
import com.fasterxml.jackson.core.JsonFactory;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.AnnotationIntrospector;
import com.fasterxml.jackson.databind.BeanDescription;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.MapperFeature;
import com.fasterxml.jackson.databind.PropertyName;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;
import com.fasterxml.jackson.databind.cfg.BaseSettings;
import com.fasterxml.jackson.databind.cfg.ConfigFeature;
import com.fasterxml.jackson.databind.cfg.ContextAttributes;
import com.fasterxml.jackson.databind.cfg.HandlerInstantiator;
import com.fasterxml.jackson.databind.cfg.MapperConfigBase;
import com.fasterxml.jackson.databind.deser.DeserializationProblemHandler;
import com.fasterxml.jackson.databind.introspect.ClassIntrospector;
import com.fasterxml.jackson.databind.introspect.SimpleMixInResolver;
import com.fasterxml.jackson.databind.introspect.VisibilityChecker;
import com.fasterxml.jackson.databind.jsontype.SubtypeResolver;
import com.fasterxml.jackson.databind.jsontype.TypeDeserializer;
import com.fasterxml.jackson.databind.jsontype.TypeResolverBuilder;
import com.fasterxml.jackson.databind.node.JsonNodeFactory;
import com.fasterxml.jackson.databind.type.TypeFactory;
import com.fasterxml.jackson.databind.util.LinkedNode;
import com.fasterxml.jackson.databind.util.RootNameLookup;
import java.io.Serializable;
import java.text.DateFormat;
import java.util.Locale;
import java.util.TimeZone;

public class DeserializationConfig extends MapperConfigBase<DeserializationFeature, DeserializationConfig> implements Serializable
{
    protected DeserializationConfig() {}
    protected BaseSettings getBaseSettings(){ return null; }
    protected DeserializationConfig(DeserializationConfig p0, ContextAttributes p1){}
    protected DeserializationConfig(DeserializationConfig p0, SimpleMixInResolver p1){}
    protected DeserializationConfig(DeserializationConfig p0, SimpleMixInResolver p1, RootNameLookup p2){}
    protected final JsonNodeFactory _nodeFactory = null;
    protected final LinkedNode<DeserializationProblemHandler> _problemHandlers = null;
    protected final int _deserFeatures = 0;
    protected final int _formatReadFeatures = 0;
    protected final int _formatReadFeaturesToChange = 0;
    protected final int _parserFeatures = 0;
    protected final int _parserFeaturesToChange = 0;
    public <T extends BeanDescription> T introspect(JavaType p0){ return null; }
    public <T extends BeanDescription> T introspectForBuilder(JavaType p0){ return null; }
    public <T extends BeanDescription> T introspectForCreation(JavaType p0){ return null; }
    public AnnotationIntrospector getAnnotationIntrospector(){ return null; }
    public BeanDescription introspectClassAnnotations(JavaType p0){ return null; }
    public BeanDescription introspectDirectClassAnnotations(JavaType p0){ return null; }
    public DeserializationConfig with(AnnotationIntrospector p0){ return null; }
    public DeserializationConfig with(Base64Variant p0){ return null; }
    public DeserializationConfig with(ClassIntrospector p0){ return null; }
    public DeserializationConfig with(ContextAttributes p0){ return null; }
    public DeserializationConfig with(DateFormat p0){ return null; }
    public DeserializationConfig with(DeserializationFeature p0){ return null; }
    public DeserializationConfig with(DeserializationFeature p0, DeserializationFeature... p1){ return null; }
    public DeserializationConfig with(FormatFeature p0){ return null; }
    public DeserializationConfig with(HandlerInstantiator p0){ return null; }
    public DeserializationConfig with(JsonNodeFactory p0){ return null; }
    public DeserializationConfig with(JsonParser.Feature p0){ return null; }
    public DeserializationConfig with(Locale p0){ return null; }
    public DeserializationConfig with(MapperFeature p0, boolean p1){ return null; }
    public DeserializationConfig with(MapperFeature... p0){ return null; }
    public DeserializationConfig with(PropertyNamingStrategy p0){ return null; }
    public DeserializationConfig with(SubtypeResolver p0){ return null; }
    public DeserializationConfig with(TimeZone p0){ return null; }
    public DeserializationConfig with(TypeFactory p0){ return null; }
    public DeserializationConfig with(TypeResolverBuilder<? extends Object> p0){ return null; }
    public DeserializationConfig with(VisibilityChecker<? extends Object> p0){ return null; }
    public DeserializationConfig withAppendedAnnotationIntrospector(AnnotationIntrospector p0){ return null; }
    public DeserializationConfig withFeatures(DeserializationFeature... p0){ return null; }
    public DeserializationConfig withFeatures(FormatFeature... p0){ return null; }
    public DeserializationConfig withFeatures(JsonParser.Feature... p0){ return null; }
    public DeserializationConfig withHandler(DeserializationProblemHandler p0){ return null; }
    public DeserializationConfig withInsertedAnnotationIntrospector(AnnotationIntrospector p0){ return null; }
    public DeserializationConfig withNoProblemHandlers(){ return null; }
    public DeserializationConfig withRootName(PropertyName p0){ return null; }
    public DeserializationConfig withView(Class<? extends Object> p0){ return null; }
    public DeserializationConfig withVisibility(PropertyAccessor p0, JsonAutoDetect.Visibility p1){ return null; }
    public DeserializationConfig without(DeserializationFeature p0){ return null; }
    public DeserializationConfig without(DeserializationFeature p0, DeserializationFeature... p1){ return null; }
    public DeserializationConfig without(FormatFeature p0){ return null; }
    public DeserializationConfig without(JsonParser.Feature p0){ return null; }
    public DeserializationConfig without(MapperFeature... p0){ return null; }
    public DeserializationConfig withoutFeatures(DeserializationFeature... p0){ return null; }
    public DeserializationConfig withoutFeatures(FormatFeature... p0){ return null; }
    public DeserializationConfig withoutFeatures(JsonParser.Feature... p0){ return null; }
    public DeserializationConfig(BaseSettings p0, SubtypeResolver p1, SimpleMixInResolver p2, RootNameLookup p3){}
    public JsonFormat.Value getDefaultPropertyFormat(Class<? extends Object> p0){ return null; }
    public JsonInclude.Value getDefaultPropertyInclusion(){ return null; }
    public JsonInclude.Value getDefaultPropertyInclusion(Class<? extends Object> p0){ return null; }
    public LinkedNode<DeserializationProblemHandler> getProblemHandlers(){ return null; }
    public TypeDeserializer findTypeDeserializer(JavaType p0){ return null; }
    public VisibilityChecker<? extends Object> getDefaultVisibilityChecker(){ return null; }
    public boolean useRootWrapping(){ return false; }
    public final JsonNodeFactory getNodeFactory(){ return null; }
    public final boolean hasDeserializationFeatures(int p0){ return false; }
    public final boolean hasSomeOfFeatures(int p0){ return false; }
    public final boolean isEnabled(DeserializationFeature p0){ return false; }
    public final boolean isEnabled(JsonParser.Feature p0, JsonFactory p1){ return false; }
    public final int getDeserializationFeatures(){ return 0; }
    public void initialize(JsonParser p0){}
}
