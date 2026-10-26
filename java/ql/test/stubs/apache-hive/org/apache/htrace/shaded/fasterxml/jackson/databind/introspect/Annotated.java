// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.Annotated for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.introspect;

import java.lang.annotation.Annotation;
import java.lang.reflect.AnnotatedElement;
import java.lang.reflect.Type;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JavaType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.AnnotationMap;
import org.apache.htrace.shaded.fasterxml.jackson.databind.type.TypeBindings;

abstract public class Annotated
{
    protected Annotated(){}
    protected abstract AnnotationMap getAllAnnotations();
    protected abstract int getModifiers();
    public JavaType getType(TypeBindings p0){ return null; }
    public abstract <A extends Annotation> A getAnnotation(java.lang.Class<A> p0);
    public abstract Annotated withAnnotations(AnnotationMap p0);
    public abstract AnnotatedElement getAnnotated();
    public abstract Class<? extends Object> getRawType();
    public abstract Iterable<Annotation> annotations();
    public abstract String getName();
    public abstract Type getGenericType();
    public final <A extends Annotation> boolean hasAnnotation(java.lang.Class<A> p0){ return false; }
    public final Annotated withFallBackAnnotationsFrom(Annotated p0){ return null; }
    public final boolean isPublic(){ return false; }
}
