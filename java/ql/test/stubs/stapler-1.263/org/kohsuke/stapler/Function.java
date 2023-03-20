// Generated automatically from org.kohsuke.stapler.Function for testing purposes

package org.kohsuke.stapler;

import java.lang.annotation.Annotation;
import java.lang.reflect.Type;
import org.kohsuke.stapler.StaplerRequest;
import org.kohsuke.stapler.StaplerResponse;

abstract public class Function
{
    public Function contextualize(Object p0){ return null; }
    public Function(){}
    public abstract <A extends Annotation> A getAnnotation(java.lang.Class<A> p0);
    public abstract Annotation[] getAnnotations();
    public abstract Annotation[][] getParameterAnnotations();
    public abstract Class getDeclaringClass();
    public abstract Class getReturnType();
    public abstract Class[] getCheckedExceptionTypes();
    public abstract Class[] getParameterTypes();
    public abstract Object invoke(StaplerRequest p0, StaplerResponse p1, Object p2, Object... p3);
    public abstract String getDisplayName();
    public abstract String getName();
    public abstract String getQualifiedName();
    public abstract String getSignature();
    public abstract String[] getParameterNames();
    public abstract Type[] getGenericParameterTypes();
    public abstract boolean isStatic();
    public static Object returnNull(){ return null; }
}
