// Generated automatically from com.fasterxml.jackson.core.ObjectCodec for testing purposes

package com.fasterxml.jackson.core;

import com.fasterxml.jackson.core.JsonFactory;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.TreeCodec;
import com.fasterxml.jackson.core.TreeNode;
import com.fasterxml.jackson.core.Version;
import com.fasterxml.jackson.core.Versioned;
import com.fasterxml.jackson.core.type.ResolvedType;
import com.fasterxml.jackson.core.type.TypeReference;
import java.util.Iterator;

abstract public class ObjectCodec extends TreeCodec implements Versioned
{
    protected ObjectCodec(){}
    public JsonFactory getFactory(){ return null; }
    public JsonFactory getJsonFactory(){ return null; }
    public Version version(){ return null; }
    public abstract <T extends TreeNode> T readTree(JsonParser p0);
    public abstract <T> Iterator<T> readValues(JsonParser p0, Class<T> p1);
    public abstract <T> Iterator<T> readValues(JsonParser p0, ResolvedType p1);
    public abstract <T> Iterator<T> readValues(JsonParser p0, TypeReference<? extends Object> p1);
    public abstract <T> T readValue(JsonParser p0, Class<T> p1);
    public abstract <T> T readValue(JsonParser p0, ResolvedType p1);
    public abstract <T> T readValue(JsonParser p0, TypeReference<? extends Object> p1);
    public abstract <T> T treeToValue(TreeNode p0, Class<T> p1);
    public abstract JsonParser treeAsTokens(TreeNode p0);
    public abstract TreeNode createArrayNode();
    public abstract TreeNode createObjectNode();
    public abstract void writeTree(JsonGenerator p0, TreeNode p1);
    public abstract void writeValue(JsonGenerator p0, Object p1);
}
