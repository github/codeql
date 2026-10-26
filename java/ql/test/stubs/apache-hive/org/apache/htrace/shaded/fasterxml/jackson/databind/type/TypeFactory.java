// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.type.TypeFactory for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.type;

import java.io.Serializable;
import java.lang.reflect.GenericArrayType;
import java.lang.reflect.GenericDeclaration;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.lang.reflect.TypeVariable;
import java.lang.reflect.WildcardType;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import org.apache.htrace.shaded.fasterxml.jackson.core.type.TypeReference;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JavaType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.type.ArrayType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.type.ClassKey;
import org.apache.htrace.shaded.fasterxml.jackson.databind.type.CollectionLikeType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.type.CollectionType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.type.HierarchicType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.type.MapLikeType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.type.MapType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.type.SimpleType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.type.TypeBindings;
import org.apache.htrace.shaded.fasterxml.jackson.databind.type.TypeModifier;
import org.apache.htrace.shaded.fasterxml.jackson.databind.type.TypeParser;
import org.apache.htrace.shaded.fasterxml.jackson.databind.util.LRUMap;

public class TypeFactory implements Serializable
{
    protected TypeFactory() {}
    protected HierarchicType _arrayListSuperInterfaceChain(HierarchicType p0){ return null; }
    protected HierarchicType _cachedArrayListType = null;
    protected HierarchicType _cachedHashMapType = null;
    protected HierarchicType _doFindSuperInterfaceChain(HierarchicType p0, Class<? extends Object> p1){ return null; }
    protected HierarchicType _findSuperClassChain(Type p0, Class<? extends Object> p1){ return null; }
    protected HierarchicType _findSuperInterfaceChain(Type p0, Class<? extends Object> p1){ return null; }
    protected HierarchicType _findSuperTypeChain(Class<? extends Object> p0, Class<? extends Object> p1){ return null; }
    protected HierarchicType _hashMapSuperInterfaceChain(HierarchicType p0){ return null; }
    protected JavaType _constructType(Type p0, TypeBindings p1){ return null; }
    protected JavaType _fromArrayType(GenericArrayType p0, TypeBindings p1){ return null; }
    protected JavaType _fromClass(Class<? extends Object> p0, TypeBindings p1){ return null; }
    protected JavaType _fromParamType(ParameterizedType p0, TypeBindings p1){ return null; }
    protected JavaType _fromParameterizedClass(Class<? extends Object> p0, List<JavaType> p1){ return null; }
    protected JavaType _fromVariable(TypeVariable<? extends Object> p0, TypeBindings p1){ return null; }
    protected JavaType _fromWildcard(WildcardType p0, TypeBindings p1){ return null; }
    protected JavaType _resolveVariableViaSubTypes(HierarchicType p0, String p1, TypeBindings p2){ return null; }
    protected JavaType _unknownType(){ return null; }
    protected TypeFactory(TypeParser p0, TypeModifier[] p1){}
    protected final LRUMap<ClassKey, JavaType> _typeCache = null;
    protected final TypeModifier[] _modifiers = null;
    protected final TypeParser _parser = null;
    protected static SimpleType CORE_TYPE_BOOL = null;
    protected static SimpleType CORE_TYPE_INT = null;
    protected static SimpleType CORE_TYPE_LONG = null;
    protected static SimpleType CORE_TYPE_STRING = null;
    protected static TypeFactory instance = null;
    public ArrayType constructArrayType(Class<? extends Object> p0){ return null; }
    public ArrayType constructArrayType(JavaType p0){ return null; }
    public CollectionLikeType constructCollectionLikeType(Class<? extends Object> p0, Class<? extends Object> p1){ return null; }
    public CollectionLikeType constructCollectionLikeType(Class<? extends Object> p0, JavaType p1){ return null; }
    public CollectionLikeType constructRawCollectionLikeType(Class<? extends Object> p0){ return null; }
    public CollectionType constructCollectionType(Class<? extends Collection> p0, Class<? extends Object> p1){ return null; }
    public CollectionType constructCollectionType(Class<? extends Collection> p0, JavaType p1){ return null; }
    public CollectionType constructRawCollectionType(Class<? extends Collection> p0){ return null; }
    public JavaType constructFromCanonical(String p0){ return null; }
    public JavaType constructParametricType(Class<? extends Object> p0, Class<? extends Object>... p1){ return null; }
    public JavaType constructParametricType(Class<? extends Object> p0, JavaType... p1){ return null; }
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
    public TypeFactory withModifier(TypeModifier p0){ return null; }
    public static Class<? extends Object> rawClass(Type p0){ return null; }
    public static JavaType unknownType(){ return null; }
    public static TypeFactory defaultInstance(){ return null; }
}
