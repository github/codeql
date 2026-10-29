// Generated automatically from com.fasterxml.jackson.databind.cfg.MapperConfig for testing purposes

package com.fasterxml.jackson.databind.cfg;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.core.Base64Variant;
import com.fasterxml.jackson.core.SerializableString;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.AnnotationIntrospector;
import com.fasterxml.jackson.databind.BeanDescription;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.MapperFeature;
import com.fasterxml.jackson.databind.PropertyName;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;
import com.fasterxml.jackson.databind.cfg.BaseSettings;
import com.fasterxml.jackson.databind.cfg.ConfigFeature;
import com.fasterxml.jackson.databind.cfg.ContextAttributes;
import com.fasterxml.jackson.databind.cfg.HandlerInstantiator;
import com.fasterxml.jackson.databind.introspect.Annotated;
import com.fasterxml.jackson.databind.introspect.ClassIntrospector;
import com.fasterxml.jackson.databind.introspect.VisibilityChecker;
import com.fasterxml.jackson.databind.jsontype.SubtypeResolver;
import com.fasterxml.jackson.databind.jsontype.TypeIdResolver;
import com.fasterxml.jackson.databind.jsontype.TypeResolverBuilder;
import com.fasterxml.jackson.databind.type.TypeFactory;
import java.io.Serializable;
import java.text.DateFormat;
import java.util.Locale;
import java.util.TimeZone;

abstract public class MapperConfig<T extends MapperConfig<T>> implements ClassIntrospector.MixInResolver, Serializable
{
    protected MapperConfig() {}
    protected MapperConfig(BaseSettings p0, int p1){}
    protected MapperConfig(MapperConfig<T> p0){}
    protected MapperConfig(MapperConfig<T> p0, BaseSettings p1){}
    protected MapperConfig(MapperConfig<T> p0, int p1){}
    protected final BaseSettings _base = null;
    protected final int _mapperFeatures = 0;
    protected static JsonFormat.Value EMPTY_FORMAT = null;
    protected static JsonInclude.Value EMPTY_INCLUDE = null;
    public AnnotationIntrospector getAnnotationIntrospector(){ return null; }
    public Base64Variant getBase64Variant(){ return null; }
    public BeanDescription introspectClassAnnotations(Class<? extends Object> p0){ return null; }
    public BeanDescription introspectDirectClassAnnotations(Class<? extends Object> p0){ return null; }
    public ClassIntrospector getClassIntrospector(){ return null; }
    public JavaType constructSpecializedType(JavaType p0, Class<? extends Object> p1){ return null; }
    public SerializableString compileString(String p0){ return null; }
    public TypeIdResolver typeIdResolverInstance(Annotated p0, Class<? extends TypeIdResolver> p1){ return null; }
    public TypeResolverBuilder<? extends Object> typeResolverBuilderInstance(Annotated p0, Class<? extends TypeResolverBuilder<? extends Object>> p1){ return null; }
    public VisibilityChecker<? extends Object> getDefaultVisibilityChecker(){ return null; }
    public abstract BeanDescription introspectClassAnnotations(JavaType p0);
    public abstract BeanDescription introspectDirectClassAnnotations(JavaType p0);
    public abstract Class<? extends Object> getActiveView();
    public abstract ContextAttributes getAttributes();
    public abstract JsonFormat.Value getDefaultPropertyFormat(Class<? extends Object> p0);
    public abstract JsonInclude.Value getDefaultPropertyInclusion();
    public abstract JsonInclude.Value getDefaultPropertyInclusion(Class<? extends Object> p0);
    public abstract PropertyName findRootName(Class<? extends Object> p0);
    public abstract PropertyName findRootName(JavaType p0);
    public abstract SubtypeResolver getSubtypeResolver();
    public abstract T with(MapperFeature p0, boolean p1);
    public abstract T with(MapperFeature... p0);
    public abstract T without(MapperFeature... p0);
    public abstract boolean useRootWrapping();
    public final DateFormat getDateFormat(){ return null; }
    public final HandlerInstantiator getHandlerInstantiator(){ return null; }
    public final JavaType constructType(Class<? extends Object> p0){ return null; }
    public final JavaType constructType(TypeReference<? extends Object> p0){ return null; }
    public final Locale getLocale(){ return null; }
    public final PropertyNamingStrategy getPropertyNamingStrategy(){ return null; }
    public final TimeZone getTimeZone(){ return null; }
    public final TypeFactory getTypeFactory(){ return null; }
    public final TypeResolverBuilder<? extends Object> getDefaultTyper(JavaType p0){ return null; }
    public final boolean canOverrideAccessModifiers(){ return false; }
    public final boolean hasMapperFeatures(int p0){ return false; }
    public final boolean isAnnotationProcessingEnabled(){ return false; }
    public final boolean isEnabled(MapperFeature p0){ return false; }
    public final boolean shouldSortPropertiesAlphabetically(){ return false; }
    public static <F extends Enum<F> & ConfigFeature> int collectFeatureDefaults(Class<F> p0){ return 0; }
}
