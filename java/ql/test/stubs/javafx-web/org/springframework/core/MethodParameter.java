// Generated automatically from org.springframework.core.MethodParameter for testing purposes

package org.springframework.core;

import java.lang.annotation.Annotation;
import java.lang.reflect.AnnotatedElement;
import java.lang.reflect.Constructor;
import java.lang.reflect.Executable;
import java.lang.reflect.Member;
import java.lang.reflect.Method;
import java.lang.reflect.Parameter;
import java.lang.reflect.Type;
import org.springframework.core.ParameterNameDiscoverer;

public class MethodParameter
{
    protected MethodParameter() {}
    protected <A extends Annotation> A adaptAnnotation(A p0){ return null; }
    protected Annotation[] adaptAnnotationArray(Annotation[] p0){ return null; }
    protected static int findParameterIndex(Parameter p0){ return 0; }
    public <A extends Annotation> A getMethodAnnotation(java.lang.Class<A> p0){ return null; }
    public <A extends Annotation> A getParameterAnnotation(java.lang.Class<A> p0){ return null; }
    public <A extends Annotation> boolean hasMethodAnnotation(java.lang.Class<A> p0){ return false; }
    public <A extends Annotation> boolean hasParameterAnnotation(java.lang.Class<A> p0){ return false; }
    public AnnotatedElement getAnnotatedElement(){ return null; }
    public Annotation[] getMethodAnnotations(){ return null; }
    public Annotation[] getParameterAnnotations(){ return null; }
    public Class<? extends Object> getContainingClass(){ return null; }
    public Class<? extends Object> getDeclaringClass(){ return null; }
    public Class<? extends Object> getNestedParameterType(){ return null; }
    public Class<? extends Object> getParameterType(){ return null; }
    public Constructor<? extends Object> getConstructor(){ return null; }
    public Executable getExecutable(){ return null; }
    public Integer getTypeIndexForCurrentLevel(){ return null; }
    public Integer getTypeIndexForLevel(int p0){ return null; }
    public Member getMember(){ return null; }
    public Method getMethod(){ return null; }
    public MethodParameter clone(){ return null; }
    public MethodParameter nested(){ return null; }
    public MethodParameter nested(Integer p0){ return null; }
    public MethodParameter nestedIfOptional(){ return null; }
    public MethodParameter withContainingClass(Class<? extends Object> p0){ return null; }
    public MethodParameter withTypeIndex(int p0){ return null; }
    public MethodParameter(Constructor<? extends Object> p0, int p1){}
    public MethodParameter(Constructor<? extends Object> p0, int p1, int p2){}
    public MethodParameter(Method p0, int p1){}
    public MethodParameter(Method p0, int p1, int p2){}
    public MethodParameter(MethodParameter p0){}
    public Parameter getParameter(){ return null; }
    public String getParameterName(){ return null; }
    public String toString(){ return null; }
    public Type getGenericParameterType(){ return null; }
    public Type getNestedGenericParameterType(){ return null; }
    public boolean equals(Object p0){ return false; }
    public boolean hasParameterAnnotations(){ return false; }
    public boolean isOptional(){ return false; }
    public int getNestingLevel(){ return 0; }
    public int getParameterIndex(){ return 0; }
    public int hashCode(){ return 0; }
    public static MethodParameter forExecutable(Executable p0, int p1){ return null; }
    public static MethodParameter forMethodOrConstructor(Object p0, int p1){ return null; }
    public static MethodParameter forParameter(Parameter p0){ return null; }
    public void decreaseNestingLevel(){}
    public void increaseNestingLevel(){}
    public void initParameterNameDiscovery(ParameterNameDiscoverer p0){}
    public void setTypeIndexForCurrentLevel(int p0){}
}
