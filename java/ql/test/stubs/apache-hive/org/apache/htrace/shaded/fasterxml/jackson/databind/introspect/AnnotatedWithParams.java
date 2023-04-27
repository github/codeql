// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.AnnotatedWithParams for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.introspect;

import java.lang.annotation.Annotation;
import java.lang.reflect.GenericDeclaration;
import java.lang.reflect.Type;
import java.lang.reflect.TypeVariable;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JavaType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.AnnotatedMember;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.AnnotatedParameter;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.AnnotationMap;
import org.apache.htrace.shaded.fasterxml.jackson.databind.type.TypeBindings;

abstract public class AnnotatedWithParams extends AnnotatedMember
{
    protected AnnotatedWithParams() {}
    protected AnnotatedParameter replaceParameterAnnotations(int p0, AnnotationMap p1){ return null; }
    protected AnnotatedWithParams(AnnotationMap p0, AnnotationMap[] p1){}
    protected JavaType getType(TypeBindings p0, TypeVariable<? extends Object>[] p1){ return null; }
    protected final AnnotationMap[] _paramAnnotations = null;
    public abstract Class<? extends Object> getRawParameterType(int p0);
    public abstract Object call();
    public abstract Object call(Object[] p0);
    public abstract Object call1(Object p0);
    public abstract Type getGenericParameterType(int p0);
    public abstract int getParameterCount();
    public final <A extends Annotation> A getAnnotation(java.lang.Class<A> p0){ return null; }
    public final AnnotatedParameter getParameter(int p0){ return null; }
    public final AnnotationMap getParameterAnnotations(int p0){ return null; }
    public final JavaType resolveParameterType(int p0, TypeBindings p1){ return null; }
    public final int getAnnotationCount(){ return 0; }
    public final void addOrOverrideParam(int p0, Annotation p1){}
}
