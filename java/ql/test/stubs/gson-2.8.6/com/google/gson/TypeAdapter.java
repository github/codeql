// Generated automatically from com.google.gson.TypeAdapter for testing purposes

package com.google.gson;

import com.google.gson.JsonElement;
import com.google.gson.stream.JsonReader;
import com.google.gson.stream.JsonWriter;
import java.io.Reader;
import java.io.Writer;

abstract public class TypeAdapter<T>
{
    public TypeAdapter(){}
    public abstract T read(JsonReader p0);
    public abstract void write(JsonWriter p0, T p1);
    public final JsonElement toJsonTree(T p0){ return null; }
    public final String toJson(T p0){ return null; }
    public final T fromJson(Reader p0){ return null; }
    public final T fromJson(String p0){ return null; }
    public final T fromJsonTree(JsonElement p0){ return null; }
    public final TypeAdapter<T> nullSafe(){ return null; }
    public final void toJson(Writer p0, T p1){}
}
