// Generated automatically from com.fasterxml.jackson.databind.introspect.AnnotatedWithParams for testing purposes

package com.fasterxml.jackson.databind.introspect;

import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.introspect.AnnotatedMember;
import com.fasterxml.jackson.databind.introspect.AnnotatedParameter;
import com.fasterxml.jackson.databind.introspect.AnnotationMap;
import com.fasterxml.jackson.databind.introspect.TypeResolutionContext;
import java.lang.annotation.Annotation;
import java.lang.reflect.Type;

abstract public class AnnotatedWithParams extends AnnotatedMember
{
    protected AnnotatedWithParams() {}
    protected AnnotatedParameter replaceParameterAnnotations(int p0, AnnotationMap p1){ return null; }
    protected AnnotatedWithParams(TypeResolutionContext p0, AnnotationMap p1, AnnotationMap[] p2){}
    protected final AnnotationMap[] _paramAnnotations = null;
    public abstract Class<? extends Object> getRawParameterType(int p0);
    public abstract JavaType getParameterType(int p0);
    public abstract Object call();
    public abstract Object call(Object[] p0);
    public abstract Object call1(Object p0);
    public abstract Type getGenericParameterType(int p0);
    public abstract int getParameterCount();
    public final AnnotatedParameter getParameter(int p0){ return null; }
    public final AnnotationMap getParameterAnnotations(int p0){ return null; }
    public final int getAnnotationCount(){ return 0; }
    public final void addOrOverrideParam(int p0, Annotation p1){}
}
