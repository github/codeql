// Generated automatically from com.fasterxml.jackson.databind.type.TypeFactory for testing purposes

package com.fasterxml.jackson.databind.type;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.type.ArrayType;
import com.fasterxml.jackson.databind.type.ClassStack;
import com.fasterxml.jackson.databind.type.CollectionLikeType;
import com.fasterxml.jackson.databind.type.CollectionType;
import com.fasterxml.jackson.databind.type.MapLikeType;
import com.fasterxml.jackson.databind.type.MapType;
import com.fasterxml.jackson.databind.type.SimpleType;
import com.fasterxml.jackson.databind.type.TypeBindings;
import com.fasterxml.jackson.databind.type.TypeModifier;
import com.fasterxml.jackson.databind.type.TypeParser;
import com.fasterxml.jackson.databind.util.LRUMap;
import java.io.Serializable;
import java.lang.reflect.GenericArrayType;
import java.lang.reflect.GenericDeclaration;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.lang.reflect.TypeVariable;
import java.lang.reflect.WildcardType;
import java.util.Collection;
import java.util.Map;

public class TypeFactory implements Serializable
{
    protected TypeFactory() {}
    protected Class<? extends Object> _findPrimitive(String p0){ return null; }
    protected Class<? extends Object> classForName(String p0){ return null; }
    protected Class<? extends Object> classForName(String p0, boolean p1, ClassLoader p2){ return null; }
    protected JavaType _constructSimple(Class<? extends Object> p0, TypeBindings p1, JavaType p2, JavaType[] p3){ return null; }
    protected JavaType _findWellKnownSimple(Class<? extends Object> p0){ return null; }
    protected JavaType _fromAny(ClassStack p0, Type p1, TypeBindings p2){ return null; }
    protected JavaType _fromArrayType(ClassStack p0, GenericArrayType p1, TypeBindings p2){ return null; }
    protected JavaType _fromClass(ClassStack p0, Class<? extends Object> p1, TypeBindings p2){ return null; }
    protected JavaType _fromParamType(ClassStack p0, ParameterizedType p1, TypeBindings p2){ return null; }
    protected JavaType _fromVariable(ClassStack p0, TypeVariable<? extends Object> p1, TypeBindings p2){ return null; }
    protected JavaType _fromWellKnownClass(ClassStack p0, Class<? extends Object> p1, TypeBindings p2, JavaType p3, JavaType[] p4){ return null; }
    protected JavaType _fromWellKnownInterface(ClassStack p0, Class<? extends Object> p1, TypeBindings p2, JavaType p3, JavaType[] p4){ return null; }
    protected JavaType _fromWildcard(ClassStack p0, WildcardType p1, TypeBindings p2){ return null; }
    protected JavaType _newSimpleType(Class<? extends Object> p0, TypeBindings p1, JavaType p2, JavaType[] p3){ return null; }
    protected JavaType _resolveSuperClass(ClassStack p0, Class<? extends Object> p1, TypeBindings p2){ return null; }
    protected JavaType _unknownType(){ return null; }
    protected JavaType[] _resolveSuperInterfaces(ClassStack p0, Class<? extends Object> p1, TypeBindings p2){ return null; }
    protected TypeFactory(TypeParser p0, TypeModifier[] p1){}
    protected TypeFactory(TypeParser p0, TypeModifier[] p1, ClassLoader p2){}
    protected final ClassLoader _classLoader = null;
    protected final LRUMap<Object, JavaType> _typeCache = null;
    protected final TypeModifier[] _modifiers = null;
    protected final TypeParser _parser = null;
    protected static SimpleType CORE_TYPE_BOOL = null;
    protected static SimpleType CORE_TYPE_CLASS = null;
    protected static SimpleType CORE_TYPE_COMPARABLE = null;
    protected static SimpleType CORE_TYPE_ENUM = null;
    protected static SimpleType CORE_TYPE_INT = null;
    protected static SimpleType CORE_TYPE_LONG = null;
    protected static SimpleType CORE_TYPE_OBJECT = null;
    protected static SimpleType CORE_TYPE_STRING = null;
    protected static TypeBindings EMPTY_BINDINGS = null;
    protected static TypeFactory instance = null;
    public ArrayType constructArrayType(Class<? extends Object> p0){ return null; }
    public ArrayType constructArrayType(JavaType p0){ return null; }
    public Class<? extends Object> findClass(String p0){ return null; }
    public ClassLoader getClassLoader(){ return null; }
    public CollectionLikeType constructCollectionLikeType(Class<? extends Object> p0, Class<? extends Object> p1){ return null; }
    public CollectionLikeType constructCollectionLikeType(Class<? extends Object> p0, JavaType p1){ return null; }
    public CollectionLikeType constructRawCollectionLikeType(Class<? extends Object> p0){ return null; }
    public CollectionType constructCollectionType(Class<? extends Collection> p0, Class<? extends Object> p1){ return null; }
    public CollectionType constructCollectionType(Class<? extends Collection> p0, JavaType p1){ return null; }
    public CollectionType constructRawCollectionType(Class<? extends Collection> p0){ return null; }
    public JavaType constructFromCanonical(String p0){ return null; }
    public JavaType constructGeneralizedType(JavaType p0, Class<? extends Object> p1){ return null; }
    public JavaType constructParametricType(Class<? extends Object> p0, Class<? extends Object>... p1){ return null; }
    public JavaType constructParametricType(Class<? extends Object> p0, JavaType... p1){ return null; }
    public JavaType constructParametrizedType(Class<? extends Object> p0, Class<? extends Object> p1, Class<? extends Object>... p2){ return null; }
    public JavaType constructParametrizedType(Class<? extends Object> p0, Class<? extends Object> p1, JavaType... p2){ return null; }
    public JavaType constructReferenceType(Class<? extends Object> p0, JavaType p1){ return null; }
    public JavaType constructSimpleType(Class<? extends Object> p0, Class<? extends Object> p1, JavaType[] p2){ return null; }
    public JavaType constructSimpleType(Class<? extends Object> p0, JavaType[] p1){ return null; }
    public JavaType constructSpecializedType(JavaType p0, Class<? extends Object> p1){ return null; }
    public JavaType constructType(Type p0){ return null; }
    public JavaType constructType(Type p0, Class<? extends Object> p1){ return null; }
    public JavaType constructType(Type p0, JavaType p1){ return null; }
    public JavaType constructType(Type p0, TypeBindings p1){ return null; }
    public JavaType constructType(TypeReference<? extends Object> p0){ return null; }
    public JavaType moreSpecificType(JavaType p0, JavaType p1){ return null; }
    public JavaType uncheckedSimpleType(Class<? extends Object> p0){ return null; }
    public JavaType[] findTypeParameters(Class<? extends Object> p0, Class<? extends Object> p1){ return null; }
    public JavaType[] findTypeParameters(Class<? extends Object> p0, Class<? extends Object> p1, TypeBindings p2){ return null; }
    public JavaType[] findTypeParameters(JavaType p0, Class<? extends Object> p1){ return null; }
    public MapLikeType constructMapLikeType(Class<? extends Object> p0, Class<? extends Object> p1, Class<? extends Object> p2){ return null; }
    public MapLikeType constructMapLikeType(Class<? extends Object> p0, JavaType p1, JavaType p2){ return null; }
    public MapLikeType constructRawMapLikeType(Class<? extends Object> p0){ return null; }
    public MapType constructMapType(Class<? extends Map> p0, Class<? extends Object> p1, Class<? extends Object> p2){ return null; }
    public MapType constructMapType(Class<? extends Map> p0, JavaType p1, JavaType p2){ return null; }
    public MapType constructRawMapType(Class<? extends Map> p0){ return null; }
    public TypeFactory withClassLoader(ClassLoader p0){ return null; }
    public TypeFactory withModifier(TypeModifier p0){ return null; }
    public static Class<? extends Object> rawClass(Type p0){ return null; }
    public static JavaType unknownType(){ return null; }
    public static TypeFactory defaultInstance(){ return null; }
    public void clearCache(){}
}
