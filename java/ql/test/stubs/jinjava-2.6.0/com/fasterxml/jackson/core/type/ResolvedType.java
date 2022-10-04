// Generated automatically from com.fasterxml.jackson.core.type.ResolvedType for testing purposes

package com.fasterxml.jackson.core.type;


abstract public class ResolvedType
{
    public Class<? extends Object> getParameterSource(){ return null; }
    public ResolvedType(){}
    public abstract Class<? extends Object> getRawClass();
    public abstract ResolvedType containedType(int p0);
    public abstract ResolvedType getContentType();
    public abstract ResolvedType getKeyType();
    public abstract ResolvedType getReferencedType();
    public abstract String containedTypeName(int p0);
    public abstract String toCanonical();
    public abstract boolean hasGenericTypes();
    public abstract boolean hasRawClass(Class<? extends Object> p0);
    public abstract boolean isAbstract();
    public abstract boolean isArrayType();
    public abstract boolean isCollectionLikeType();
    public abstract boolean isConcrete();
    public abstract boolean isContainerType();
    public abstract boolean isEnumType();
    public abstract boolean isFinal();
    public abstract boolean isInterface();
    public abstract boolean isMapLikeType();
    public abstract boolean isPrimitive();
    public abstract boolean isThrowable();
    public abstract int containedTypeCount();
    public boolean isReferenceType(){ return false; }
}
