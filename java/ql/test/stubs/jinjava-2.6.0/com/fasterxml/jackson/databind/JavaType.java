// Generated automatically from com.fasterxml.jackson.databind.JavaType for testing purposes

package com.fasterxml.jackson.databind;

import com.fasterxml.jackson.core.type.ResolvedType;
import com.fasterxml.jackson.databind.type.TypeBindings;
import java.io.Serializable;
import java.lang.reflect.Type;
import java.util.List;

abstract public class JavaType extends ResolvedType implements Serializable, Type
{
    protected JavaType() {}
    protected JavaType(Class<? extends Object> p0, int p1, Object p2, Object p3, boolean p4){}
    protected JavaType(JavaType p0){}
    protected abstract JavaType _narrow(Class<? extends Object> p0);
    protected final Class<? extends Object> _class = null;
    protected final Object _typeHandler = null;
    protected final Object _valueHandler = null;
    protected final boolean _asStatic = false;
    protected final int _hash = 0;
    public <T> T getTypeHandler(){ return null; }
    public <T> T getValueHandler(){ return null; }
    public Class<? extends Object> getParameterSource(){ return null; }
    public JavaType containedTypeOrUnknown(int p0){ return null; }
    public JavaType forcedNarrowBy(Class<? extends Object> p0){ return null; }
    public JavaType getContentType(){ return null; }
    public JavaType getKeyType(){ return null; }
    public JavaType getReferencedType(){ return null; }
    public Object getContentTypeHandler(){ return null; }
    public Object getContentValueHandler(){ return null; }
    public String getErasedSignature(){ return null; }
    public String getGenericSignature(){ return null; }
    public abstract JavaType containedType(int p0);
    public abstract JavaType findSuperType(Class<? extends Object> p0);
    public abstract JavaType getSuperClass();
    public abstract JavaType refine(Class<? extends Object> p0, TypeBindings p1, JavaType p2, JavaType[] p3);
    public abstract JavaType withContentType(JavaType p0);
    public abstract JavaType withContentTypeHandler(Object p0);
    public abstract JavaType withContentValueHandler(Object p0);
    public abstract JavaType withStaticTyping();
    public abstract JavaType withTypeHandler(Object p0);
    public abstract JavaType withValueHandler(Object p0);
    public abstract JavaType[] findTypeParameters(Class<? extends Object> p0);
    public abstract List<JavaType> getInterfaces();
    public abstract String containedTypeName(int p0);
    public abstract String toString();
    public abstract StringBuilder getErasedSignature(StringBuilder p0);
    public abstract StringBuilder getGenericSignature(StringBuilder p0);
    public abstract TypeBindings getBindings();
    public abstract boolean equals(Object p0);
    public abstract boolean isContainerType();
    public abstract int containedTypeCount();
    public boolean hasGenericTypes(){ return false; }
    public boolean hasValueHandler(){ return false; }
    public boolean isAbstract(){ return false; }
    public boolean isArrayType(){ return false; }
    public boolean isCollectionLikeType(){ return false; }
    public boolean isConcrete(){ return false; }
    public boolean isMapLikeType(){ return false; }
    public boolean isThrowable(){ return false; }
    public final Class<? extends Object> getRawClass(){ return null; }
    public final boolean hasRawClass(Class<? extends Object> p0){ return false; }
    public final boolean isEnumType(){ return false; }
    public final boolean isFinal(){ return false; }
    public final boolean isInterface(){ return false; }
    public final boolean isJavaLangObject(){ return false; }
    public final boolean isPrimitive(){ return false; }
    public final boolean isTypeOrSubTypeOf(Class<? extends Object> p0){ return false; }
    public final boolean useStaticType(){ return false; }
    public final int hashCode(){ return 0; }
}
