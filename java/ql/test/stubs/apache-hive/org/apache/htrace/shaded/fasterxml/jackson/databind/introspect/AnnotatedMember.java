// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.AnnotatedMember for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.introspect;

import java.io.Serializable;
import java.lang.annotation.Annotation;
import java.lang.reflect.Member;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.Annotated;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.AnnotationMap;

abstract public class AnnotatedMember extends Annotated implements Serializable
{
    protected AnnotatedMember() {}
    protected AnnotatedMember(AnnotationMap p0){}
    protected AnnotationMap getAllAnnotations(){ return null; }
    protected final AnnotationMap _annotations = null;
    public Iterable<Annotation> annotations(){ return null; }
    public abstract Class<? extends Object> getDeclaringClass();
    public abstract Member getMember();
    public abstract Object getValue(Object p0);
    public abstract void setValue(Object p0, Object p1);
    public final void addIfNotPresent(Annotation p0){}
    public final void addOrOverride(Annotation p0){}
    public final void fixAccess(){}
}
