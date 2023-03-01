// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.core.ObjectCodec for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.core;

import java.util.Iterator;
import org.apache.htrace.shaded.fasterxml.jackson.core.JsonFactory;
import org.apache.htrace.shaded.fasterxml.jackson.core.JsonGenerator;
import org.apache.htrace.shaded.fasterxml.jackson.core.JsonParser;
import org.apache.htrace.shaded.fasterxml.jackson.core.TreeCodec;
import org.apache.htrace.shaded.fasterxml.jackson.core.TreeNode;
import org.apache.htrace.shaded.fasterxml.jackson.core.Version;
import org.apache.htrace.shaded.fasterxml.jackson.core.Versioned;
import org.apache.htrace.shaded.fasterxml.jackson.core.type.ResolvedType;
import org.apache.htrace.shaded.fasterxml.jackson.core.type.TypeReference;

abstract public class ObjectCodec extends TreeCodec implements Versioned
{
    protected ObjectCodec(){}
    public JsonFactory getFactory(){ return null; }
    public JsonFactory getJsonFactory(){ return null; }
    public Version version(){ return null; }
    public abstract <T extends TreeNode> T readTree(JsonParser p0);
    public abstract <T> T readValue(JsonParser p0, ResolvedType p1);
    public abstract <T> T readValue(JsonParser p0, TypeReference<? extends Object> p1);
    public abstract <T> T readValue(JsonParser p0, java.lang.Class<T> p1);
    public abstract <T> T treeToValue(TreeNode p0, java.lang.Class<T> p1);
    public abstract <T> java.util.Iterator<T> readValues(JsonParser p0, ResolvedType p1);
    public abstract <T> java.util.Iterator<T> readValues(JsonParser p0, TypeReference<? extends Object> p1);
    public abstract <T> java.util.Iterator<T> readValues(JsonParser p0, java.lang.Class<T> p1);
    public abstract JsonParser treeAsTokens(TreeNode p0);
    public abstract TreeNode createArrayNode();
    public abstract TreeNode createObjectNode();
    public abstract void writeTree(JsonGenerator p0, TreeNode p1);
    public abstract void writeValue(JsonGenerator p0, Object p1);
}
