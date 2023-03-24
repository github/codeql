// Generated automatically from com.fasterxml.jackson.databind.BeanDescription for testing purposes

package com.fasterxml.jackson.databind;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.annotation.JsonPOJOBuilder;
import com.fasterxml.jackson.databind.introspect.AnnotatedClass;
import com.fasterxml.jackson.databind.introspect.AnnotatedConstructor;
import com.fasterxml.jackson.databind.introspect.AnnotatedMember;
import com.fasterxml.jackson.databind.introspect.AnnotatedMethod;
import com.fasterxml.jackson.databind.introspect.BeanPropertyDefinition;
import com.fasterxml.jackson.databind.introspect.ObjectIdInfo;
import com.fasterxml.jackson.databind.type.TypeBindings;
import com.fasterxml.jackson.databind.util.Annotations;
import com.fasterxml.jackson.databind.util.Converter;
import java.lang.reflect.Constructor;
import java.lang.reflect.Method;
import java.lang.reflect.Type;
import java.util.List;
import java.util.Map;
import java.util.Set;

abstract public class BeanDescription
{
    protected BeanDescription() {}
    protected BeanDescription(JavaType p0){}
    protected final JavaType _type = null;
    public Class<? extends Object> getBeanClass(){ return null; }
    public JavaType getType(){ return null; }
    public String findClassDescription(){ return null; }
    public abstract AnnotatedClass getClassInfo();
    public abstract AnnotatedConstructor findDefaultConstructor();
    public abstract AnnotatedMember findAnyGetter();
    public abstract AnnotatedMethod findAnySetter();
    public abstract AnnotatedMethod findJsonValueMethod();
    public abstract AnnotatedMethod findMethod(String p0, Class<? extends Object>[] p1);
    public abstract Annotations getClassAnnotations();
    public abstract Class<? extends Object> findPOJOBuilder();
    public abstract Constructor<? extends Object> findSingleArgConstructor(Class<? extends Object>... p0);
    public abstract Converter<Object, Object> findDeserializationConverter();
    public abstract Converter<Object, Object> findSerializationConverter();
    public abstract JavaType resolveType(Type p0);
    public abstract JsonFormat.Value findExpectedFormat(JsonFormat.Value p0);
    public abstract JsonInclude.Value findPropertyInclusion(JsonInclude.Value p0);
    public abstract JsonPOJOBuilder.Value findPOJOBuilderConfig();
    public abstract List<AnnotatedConstructor> getConstructors();
    public abstract List<AnnotatedMethod> getFactoryMethods();
    public abstract List<BeanPropertyDefinition> findProperties();
    public abstract Map<Object, AnnotatedMember> findInjectables();
    public abstract Map<String, AnnotatedMember> findBackReferenceProperties();
    public abstract Method findFactoryMethod(Class<? extends Object>... p0);
    public abstract Object instantiateBean(boolean p0);
    public abstract ObjectIdInfo getObjectIdInfo();
    public abstract Set<String> getIgnoredPropertyNames();
    public abstract TypeBindings bindingsForBeanType();
    public abstract boolean hasKnownClassAnnotations();
}
