// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.type.TypeBase for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.type;

import org.apache.htrace.shaded.fasterxml.jackson.core.JsonGenerator;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JavaType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JsonSerializable;
import org.apache.htrace.shaded.fasterxml.jackson.databind.SerializerProvider;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsontype.TypeSerializer;

abstract public class TypeBase extends JavaType implements JsonSerializable
{
    protected TypeBase() {}
    protected TypeBase(Class<? extends Object> p0, int p1, Object p2, Object p3){}
    protected TypeBase(Class<? extends Object> p0, int p1, Object p2, Object p3, boolean p4){}
    protected abstract String buildCanonicalName();
    protected static StringBuilder _classSignature(Class<? extends Object> p0, StringBuilder p1, boolean p2){ return null; }
    public <T> T getTypeHandler(){ return null; }
    public <T> T getValueHandler(){ return null; }
    public String toCanonical(){ return null; }
    public abstract StringBuilder getErasedSignature(StringBuilder p0);
    public abstract StringBuilder getGenericSignature(StringBuilder p0);
    public void serialize(JsonGenerator p0, SerializerProvider p1){}
    public void serializeWithType(JsonGenerator p0, SerializerProvider p1, TypeSerializer p2){}
}
