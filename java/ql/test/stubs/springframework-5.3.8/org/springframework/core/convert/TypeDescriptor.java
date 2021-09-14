// Generated automatically from org.springframework.core.convert.TypeDescriptor for testing purposes

package org.springframework.core.convert;

import java.io.Serializable;
import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import org.springframework.core.MethodParameter;
import org.springframework.core.ResolvableType;
import org.springframework.core.convert.Property;

public class TypeDescriptor implements Serializable
{
    protected TypeDescriptor() {}
    public <T extends Annotation> T getAnnotation(Class<T> p0){ return null; }
    public Annotation[] getAnnotations(){ return null; }
    public Class<? extends Object> getObjectType(){ return null; }
    public Class<? extends Object> getType(){ return null; }
    public Object getSource(){ return null; }
    public ResolvableType getResolvableType(){ return null; }
    public String getName(){ return null; }
    public String toString(){ return null; }
    public TypeDescriptor elementTypeDescriptor(Object p0){ return null; }
    public TypeDescriptor getElementTypeDescriptor(){ return null; }
    public TypeDescriptor getMapKeyTypeDescriptor(){ return null; }
    public TypeDescriptor getMapKeyTypeDescriptor(Object p0){ return null; }
    public TypeDescriptor getMapValueTypeDescriptor(){ return null; }
    public TypeDescriptor getMapValueTypeDescriptor(Object p0){ return null; }
    public TypeDescriptor narrow(Object p0){ return null; }
    public TypeDescriptor upcast(Class<? extends Object> p0){ return null; }
    public TypeDescriptor(Field p0){}
    public TypeDescriptor(MethodParameter p0){}
    public TypeDescriptor(Property p0){}
    public TypeDescriptor(ResolvableType p0, Class<? extends Object> p1, Annotation[] p2){}
    public boolean equals(Object p0){ return false; }
    public boolean hasAnnotation(Class<? extends Annotation> p0){ return false; }
    public boolean isArray(){ return false; }
    public boolean isAssignableTo(TypeDescriptor p0){ return false; }
    public boolean isCollection(){ return false; }
    public boolean isMap(){ return false; }
    public boolean isPrimitive(){ return false; }
    public int hashCode(){ return 0; }
    public static TypeDescriptor array(TypeDescriptor p0){ return null; }
    public static TypeDescriptor collection(Class<? extends Object> p0, TypeDescriptor p1){ return null; }
    public static TypeDescriptor forObject(Object p0){ return null; }
    public static TypeDescriptor map(Class<? extends Object> p0, TypeDescriptor p1, TypeDescriptor p2){ return null; }
    public static TypeDescriptor nested(Field p0, int p1){ return null; }
    public static TypeDescriptor nested(MethodParameter p0, int p1){ return null; }
    public static TypeDescriptor nested(Property p0, int p1){ return null; }
    public static TypeDescriptor valueOf(Class<? extends Object> p0){ return null; }
}
