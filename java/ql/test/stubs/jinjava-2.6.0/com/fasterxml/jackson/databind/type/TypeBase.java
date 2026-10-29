// Generated automatically from com.fasterxml.jackson.databind.type.TypeBase for testing purposes

package com.fasterxml.jackson.databind.type;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.JsonSerializable;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.jsontype.TypeSerializer;
import com.fasterxml.jackson.databind.type.TypeBindings;
import java.util.List;

abstract public class TypeBase extends JavaType implements JsonSerializable
{
    protected TypeBase() {}
    protected String buildCanonicalName(){ return null; }
    protected TypeBase(Class<? extends Object> p0, TypeBindings p1, JavaType p2, JavaType[] p3, int p4, Object p5, Object p6, boolean p7){}
    protected TypeBase(TypeBase p0){}
    protected final JavaType _superClass = null;
    protected final JavaType[] _superInterfaces = null;
    protected final TypeBindings _bindings = null;
    protected static JavaType _bogusSuperClass(Class<? extends Object> p0){ return null; }
    protected static StringBuilder _classSignature(Class<? extends Object> p0, StringBuilder p1, boolean p2){ return null; }
    public <T> T getTypeHandler(){ return null; }
    public <T> T getValueHandler(){ return null; }
    public JavaType containedType(int p0){ return null; }
    public JavaType getSuperClass(){ return null; }
    public JavaType[] findTypeParameters(Class<? extends Object> p0){ return null; }
    public List<JavaType> getInterfaces(){ return null; }
    public String containedTypeName(int p0){ return null; }
    public String toCanonical(){ return null; }
    public TypeBindings getBindings(){ return null; }
    public abstract StringBuilder getErasedSignature(StringBuilder p0);
    public abstract StringBuilder getGenericSignature(StringBuilder p0);
    public final JavaType findSuperType(Class<? extends Object> p0){ return null; }
    public int containedTypeCount(){ return 0; }
    public void serialize(JsonGenerator p0, SerializerProvider p1){}
    public void serializeWithType(JsonGenerator p0, SerializerProvider p1, TypeSerializer p2){}
}
