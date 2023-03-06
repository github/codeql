// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.cfg.MapperConfigBase for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.cfg;

import java.io.Serializable;
import java.text.DateFormat;
import java.util.Locale;
import java.util.Map;
import java.util.TimeZone;
import org.apache.htrace.shaded.fasterxml.jackson.annotation.JsonAutoDetect;
import org.apache.htrace.shaded.fasterxml.jackson.annotation.PropertyAccessor;
import org.apache.htrace.shaded.fasterxml.jackson.core.Base64Variant;
import org.apache.htrace.shaded.fasterxml.jackson.databind.AnnotationIntrospector;
import org.apache.htrace.shaded.fasterxml.jackson.databind.PropertyNamingStrategy;
import org.apache.htrace.shaded.fasterxml.jackson.databind.cfg.BaseSettings;
import org.apache.htrace.shaded.fasterxml.jackson.databind.cfg.ConfigFeature;
import org.apache.htrace.shaded.fasterxml.jackson.databind.cfg.ContextAttributes;
import org.apache.htrace.shaded.fasterxml.jackson.databind.cfg.HandlerInstantiator;
import org.apache.htrace.shaded.fasterxml.jackson.databind.cfg.MapperConfig;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.ClassIntrospector;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.VisibilityChecker;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsontype.SubtypeResolver;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsontype.TypeResolverBuilder;
import org.apache.htrace.shaded.fasterxml.jackson.databind.type.ClassKey;
import org.apache.htrace.shaded.fasterxml.jackson.databind.type.TypeFactory;

abstract public class MapperConfigBase<CFG extends ConfigFeature, T extends MapperConfigBase<CFG, T>> extends MapperConfig<T> implements Serializable
{
    protected MapperConfigBase() {}
    protected MapperConfigBase(BaseSettings p0, SubtypeResolver p1, Map<ClassKey, Class<? extends Object>> p2){}
    protected MapperConfigBase(MapperConfigBase<CFG, T> p0){}
    protected MapperConfigBase(MapperConfigBase<CFG, T> p0, BaseSettings p1){}
    protected MapperConfigBase(MapperConfigBase<CFG, T> p0, Class<? extends Object> p1){}
    protected MapperConfigBase(MapperConfigBase<CFG, T> p0, ContextAttributes p1){}
    protected MapperConfigBase(MapperConfigBase<CFG, T> p0, Map<ClassKey, Class<? extends Object>> p1){}
    protected MapperConfigBase(MapperConfigBase<CFG, T> p0, String p1){}
    protected MapperConfigBase(MapperConfigBase<CFG, T> p0, SubtypeResolver p1){}
    protected MapperConfigBase(MapperConfigBase<CFG, T> p0, int p1){}
    protected final Class<? extends Object> _view = null;
    protected final ContextAttributes _attributes = null;
    protected final Map<ClassKey, Class<? extends Object>> _mixInAnnotations = null;
    protected final String _rootName = null;
    protected final SubtypeResolver _subtypeResolver = null;
    public T withAttribute(Object p0, Object p1){ return null; }
    public T withAttributes(Map<Object, Object> p0){ return null; }
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
    public abstract T withRootName(String p0);
    public abstract T withView(Class<? extends Object> p0);
    public abstract T withVisibility(PropertyAccessor p0, JsonAutoDetect.Visibility p1);
    public final Class<? extends Object> findMixInClassFor(Class<? extends Object> p0){ return null; }
    public final Class<? extends Object> getActiveView(){ return null; }
    public final ContextAttributes getAttributes(){ return null; }
    public final String getRootName(){ return null; }
    public final SubtypeResolver getSubtypeResolver(){ return null; }
    public final int mixInCount(){ return 0; }
}
