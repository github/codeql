// Generated automatically from com.fasterxml.jackson.databind.cfg.MapperConfigBase for testing purposes

package com.fasterxml.jackson.databind.cfg;

import com.fasterxml.jackson.annotation.JsonAutoDetect;
import com.fasterxml.jackson.annotation.PropertyAccessor;
import com.fasterxml.jackson.core.Base64Variant;
import com.fasterxml.jackson.databind.AnnotationIntrospector;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.PropertyName;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;
import com.fasterxml.jackson.databind.cfg.BaseSettings;
import com.fasterxml.jackson.databind.cfg.ConfigFeature;
import com.fasterxml.jackson.databind.cfg.ContextAttributes;
import com.fasterxml.jackson.databind.cfg.HandlerInstantiator;
import com.fasterxml.jackson.databind.cfg.MapperConfig;
import com.fasterxml.jackson.databind.introspect.ClassIntrospector;
import com.fasterxml.jackson.databind.introspect.SimpleMixInResolver;
import com.fasterxml.jackson.databind.introspect.VisibilityChecker;
import com.fasterxml.jackson.databind.jsontype.SubtypeResolver;
import com.fasterxml.jackson.databind.jsontype.TypeResolverBuilder;
import com.fasterxml.jackson.databind.type.TypeFactory;
import com.fasterxml.jackson.databind.util.RootNameLookup;
import java.io.Serializable;
import java.text.DateFormat;
import java.util.Locale;
import java.util.Map;
import java.util.TimeZone;

abstract public class MapperConfigBase<CFG extends ConfigFeature, T extends MapperConfigBase<CFG, T>> extends MapperConfig<T> implements Serializable
{
    protected MapperConfigBase() {}
    protected MapperConfigBase(BaseSettings p0, SubtypeResolver p1, SimpleMixInResolver p2, RootNameLookup p3){}
    protected MapperConfigBase(MapperConfigBase<CFG, T> p0){}
    protected MapperConfigBase(MapperConfigBase<CFG, T> p0, BaseSettings p1){}
    protected MapperConfigBase(MapperConfigBase<CFG, T> p0, Class<? extends Object> p1){}
    protected MapperConfigBase(MapperConfigBase<CFG, T> p0, ContextAttributes p1){}
    protected MapperConfigBase(MapperConfigBase<CFG, T> p0, PropertyName p1){}
    protected MapperConfigBase(MapperConfigBase<CFG, T> p0, SimpleMixInResolver p1){}
    protected MapperConfigBase(MapperConfigBase<CFG, T> p0, SimpleMixInResolver p1, RootNameLookup p2){}
    protected MapperConfigBase(MapperConfigBase<CFG, T> p0, SubtypeResolver p1){}
    protected MapperConfigBase(MapperConfigBase<CFG, T> p0, int p1){}
    protected final Class<? extends Object> _view = null;
    protected final ContextAttributes _attributes = null;
    protected final PropertyName _rootName = null;
    protected final RootNameLookup _rootNames = null;
    protected final SimpleMixInResolver _mixIns = null;
    protected final SubtypeResolver _subtypeResolver = null;
    public ClassIntrospector.MixInResolver copy(){ return null; }
    public PropertyName findRootName(Class<? extends Object> p0){ return null; }
    public PropertyName findRootName(JavaType p0){ return null; }
    public T withAttribute(Object p0, Object p1){ return null; }
    public T withAttributes(Map<? extends Object, ? extends Object> p0){ return null; }
    public T withRootName(String p0){ return null; }
    public T withoutAttribute(Object p0){ return null; }
    public abstract T with(AnnotationIntrospector p0);
    public abstract T with(Base64Variant p0);
    public abstract T with(ClassIntrospector p0);
    public abstract T with(ContextAttributes p0);
    public abstract T with(DateFormat p0);
    public abstract T with(HandlerInstantiator p0);
    public abstract T with(Locale p0);
    public abstract T with(PropertyNamingStrategy p0);
    public abstract T with(SubtypeResolver p0);
    public abstract T with(TimeZone p0);
    public abstract T with(TypeFactory p0);
    public abstract T with(TypeResolverBuilder<? extends Object> p0);
    public abstract T with(VisibilityChecker<? extends Object> p0);
    public abstract T withAppendedAnnotationIntrospector(AnnotationIntrospector p0);
    public abstract T withInsertedAnnotationIntrospector(AnnotationIntrospector p0);
    public abstract T withRootName(PropertyName p0);
    public abstract T withView(Class<? extends Object> p0);
    public abstract T withVisibility(PropertyAccessor p0, JsonAutoDetect.Visibility p1);
    public final Class<? extends Object> findMixInClassFor(Class<? extends Object> p0){ return null; }
    public final Class<? extends Object> getActiveView(){ return null; }
    public final ContextAttributes getAttributes(){ return null; }
    public final PropertyName getFullRootName(){ return null; }
    public final String getRootName(){ return null; }
    public final SubtypeResolver getSubtypeResolver(){ return null; }
    public final int mixInCount(){ return 0; }
}
