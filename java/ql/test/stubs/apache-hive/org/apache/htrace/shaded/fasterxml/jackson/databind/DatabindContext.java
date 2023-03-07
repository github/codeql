// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.DatabindContext for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind;

import java.lang.reflect.Type;
import org.apache.htrace.shaded.fasterxml.jackson.annotation.ObjectIdGenerator;
import org.apache.htrace.shaded.fasterxml.jackson.annotation.ObjectIdResolver;
import org.apache.htrace.shaded.fasterxml.jackson.databind.AnnotationIntrospector;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JavaType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.MapperFeature;
import org.apache.htrace.shaded.fasterxml.jackson.databind.cfg.MapperConfig;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.Annotated;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.ObjectIdInfo;
import org.apache.htrace.shaded.fasterxml.jackson.databind.type.TypeFactory;
import org.apache.htrace.shaded.fasterxml.jackson.databind.util.Converter;

abstract public class DatabindContext
{
    public Converter<Object, Object> converterInstance(Annotated p0, Object p1){ return null; }
    public DatabindContext(){}
    public JavaType constructSpecializedType(JavaType p0, Class<? extends Object> p1){ return null; }
    public JavaType constructType(Type p0){ return null; }
    public ObjectIdGenerator<? extends Object> objectIdGeneratorInstance(Annotated p0, ObjectIdInfo p1){ return null; }
    public ObjectIdResolver objectIdResolverInstance(Annotated p0, ObjectIdInfo p1){ return null; }
    public abstract AnnotationIntrospector getAnnotationIntrospector();
    public abstract Class<? extends Object> getActiveView();
    public abstract DatabindContext setAttribute(Object p0, Object p1);
    public abstract MapperConfig<? extends Object> getConfig();
    public abstract Object getAttribute(Object p0);
    public abstract TypeFactory getTypeFactory();
    public final boolean canOverrideAccessModifiers(){ return false; }
    public final boolean isEnabled(MapperFeature p0){ return false; }
}
