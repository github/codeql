// Generated automatically from com.fasterxml.jackson.databind.introspect.Annotated for testing purposes

package com.fasterxml.jackson.databind.introspect;

import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.introspect.AnnotationMap;
import com.fasterxml.jackson.databind.type.TypeBindings;
import java.lang.annotation.Annotation;
import java.lang.reflect.AnnotatedElement;
import java.lang.reflect.Type;

abstract public class Annotated
{
    protected Annotated(){}
    protected abstract AnnotationMap getAllAnnotations();
    protected abstract int getModifiers();
    public Type getGenericType(){ return null; }
    public abstract <A extends Annotation> A getAnnotation(Class<A> p0);
    public abstract Annotated withAnnotations(AnnotationMap p0);
    public abstract AnnotatedElement getAnnotated();
    public abstract Class<? extends Object> getRawType();
    public abstract Iterable<Annotation> annotations();
    public abstract JavaType getType();
    public abstract String getName();
    public abstract String toString();
    public abstract boolean equals(Object p0);
    public abstract boolean hasAnnotation(Class<? extends Object> p0);
    public abstract boolean hasOneOf(Class<? extends Annotation>[] p0);
    public abstract int hashCode();
    public final Annotated withFallBackAnnotationsFrom(Annotated p0){ return null; }
    public final JavaType getType(TypeBindings p0){ return null; }
    public final boolean isPublic(){ return false; }
}
