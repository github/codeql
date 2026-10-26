// Generated automatically from com.fasterxml.jackson.databind.introspect.AnnotatedMember for testing purposes

package com.fasterxml.jackson.databind.introspect;

import com.fasterxml.jackson.databind.introspect.Annotated;
import com.fasterxml.jackson.databind.introspect.AnnotationMap;
import com.fasterxml.jackson.databind.introspect.TypeResolutionContext;
import java.io.Serializable;
import java.lang.annotation.Annotation;
import java.lang.reflect.Member;

abstract public class AnnotatedMember extends Annotated implements Serializable
{
    protected AnnotatedMember() {}
    protected AnnotatedMember(AnnotatedMember p0){}
    protected AnnotatedMember(TypeResolutionContext p0, AnnotationMap p1){}
    protected AnnotationMap getAllAnnotations(){ return null; }
    protected final AnnotationMap _annotations = null;
    protected final TypeResolutionContext _typeContext = null;
    public Iterable<Annotation> annotations(){ return null; }
    public TypeResolutionContext getTypeContext(){ return null; }
    public abstract Class<? extends Object> getDeclaringClass();
    public abstract Member getMember();
    public abstract Object getValue(Object p0);
    public abstract void setValue(Object p0, Object p1);
    public boolean hasOneOf(Class<? extends Annotation>[] p0){ return false; }
    public final <A extends Annotation> A getAnnotation(Class<A> p0){ return null; }
    public final boolean addIfNotPresent(Annotation p0){ return false; }
    public final boolean addOrOverride(Annotation p0){ return false; }
    public final boolean hasAnnotation(Class<? extends Object> p0){ return false; }
    public final void fixAccess(){}
    public final void fixAccess(boolean p0){}
}
