// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.DeserializationConfig for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind;

import java.io.Serializable;
import java.text.DateFormat;
import java.util.Locale;
import java.util.Map;
import java.util.TimeZone;
import org.apache.htrace.shaded.fasterxml.jackson.annotation.JsonAutoDetect;
import org.apache.htrace.shaded.fasterxml.jackson.annotation.PropertyAccessor;
import org.apache.htrace.shaded.fasterxml.jackson.core.Base64Variant;
import org.apache.htrace.shaded.fasterxml.jackson.databind.AnnotationIntrospector;
import org.apache.htrace.shaded.fasterxml.jackson.databind.BeanDescription;
import org.apache.htrace.shaded.fasterxml.jackson.databind.DeserializationFeature;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JavaType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.MapperFeature;
import org.apache.htrace.shaded.fasterxml.jackson.databind.PropertyNamingStrategy;
import org.apache.htrace.shaded.fasterxml.jackson.databind.cfg.BaseSettings;
import org.apache.htrace.shaded.fasterxml.jackson.databind.cfg.ConfigFeature;
import org.apache.htrace.shaded.fasterxml.jackson.databind.cfg.ContextAttributes;
import org.apache.htrace.shaded.fasterxml.jackson.databind.cfg.HandlerInstantiator;
import org.apache.htrace.shaded.fasterxml.jackson.databind.cfg.MapperConfigBase;
import org.apache.htrace.shaded.fasterxml.jackson.databind.deser.DeserializationProblemHandler;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.ClassIntrospector;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.VisibilityChecker;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsontype.SubtypeResolver;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsontype.TypeDeserializer;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsontype.TypeResolverBuilder;
import org.apache.htrace.shaded.fasterxml.jackson.databind.node.JsonNodeFactory;
import org.apache.htrace.shaded.fasterxml.jackson.databind.type.ClassKey;
import org.apache.htrace.shaded.fasterxml.jackson.databind.type.TypeFactory;
import org.apache.htrace.shaded.fasterxml.jackson.databind.util.LinkedNode;

public class DeserializationConfig extends MapperConfigBase<DeserializationFeature, DeserializationConfig> implements Serializable
{
    protected DeserializationConfig() {}
    protected BaseSettings getBaseSettings(){ return null; }
    protected DeserializationConfig(DeserializationConfig p0, ContextAttributes p1){}
    protected DeserializationConfig(DeserializationConfig p0, Map<ClassKey, Class<? extends Object>> p1){}
    protected final JsonNodeFactory _nodeFactory = null;
    protected final LinkedNode<DeserializationProblemHandler> _problemHandlers = null;
    protected final int _deserFeatures = 0;
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
    public DeserializationConfig with(HandlerInstantiator p0){ return null; }
    public DeserializationConfig with(JsonNodeFactory p0){ return null; }
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
    public DeserializationConfig withHandler(DeserializationProblemHandler p0){ return null; }
    public DeserializationConfig withInsertedAnnotationIntrospector(AnnotationIntrospector p0){ return null; }
    public DeserializationConfig withNoProblemHandlers(){ return null; }
    public DeserializationConfig withRootName(String p0){ return null; }
    public DeserializationConfig withView(Class<? extends Object> p0){ return null; }
    public DeserializationConfig withVisibility(PropertyAccessor p0, JsonAutoDetect.Visibility p1){ return null; }
    public DeserializationConfig without(DeserializationFeature p0){ return null; }
    public DeserializationConfig without(DeserializationFeature p0, DeserializationFeature... p1){ return null; }
    public DeserializationConfig without(MapperFeature... p0){ return null; }
    public DeserializationConfig withoutFeatures(DeserializationFeature... p0){ return null; }
    public DeserializationConfig(BaseSettings p0, SubtypeResolver p1, Map<ClassKey, Class<? extends Object>> p2){}
    public LinkedNode<DeserializationProblemHandler> getProblemHandlers(){ return null; }
    public TypeDeserializer findTypeDeserializer(JavaType p0){ return null; }
    public VisibilityChecker<? extends Object> getDefaultVisibilityChecker(){ return null; }
    public boolean useRootWrapping(){ return false; }
    public final JsonNodeFactory getNodeFactory(){ return null; }
    public final boolean hasDeserializationFeatures(int p0){ return false; }
    public final boolean isEnabled(DeserializationFeature p0){ return false; }
    public final int getDeserializationFeatures(){ return 0; }
}
