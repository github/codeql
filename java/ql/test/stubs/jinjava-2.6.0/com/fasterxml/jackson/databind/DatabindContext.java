// Generated automatically from com.fasterxml.jackson.databind.DatabindContext for testing purposes

package com.fasterxml.jackson.databind;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.ObjectIdGenerator;
import com.fasterxml.jackson.annotation.ObjectIdResolver;
import com.fasterxml.jackson.databind.AnnotationIntrospector;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.MapperFeature;
import com.fasterxml.jackson.databind.cfg.MapperConfig;
import com.fasterxml.jackson.databind.introspect.Annotated;
import com.fasterxml.jackson.databind.introspect.ObjectIdInfo;
import com.fasterxml.jackson.databind.type.TypeFactory;
import com.fasterxml.jackson.databind.util.Converter;
import java.lang.reflect.Type;
import java.util.Locale;
import java.util.TimeZone;

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
    public abstract JsonFormat.Value getDefaultPropertyFormat(Class<? extends Object> p0);
    public abstract Locale getLocale();
    public abstract MapperConfig<? extends Object> getConfig();
    public abstract Object getAttribute(Object p0);
    public abstract TimeZone getTimeZone();
    public abstract TypeFactory getTypeFactory();
    public abstract boolean canOverrideAccessModifiers();
    public abstract boolean isEnabled(MapperFeature p0);
}
