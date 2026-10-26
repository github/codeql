// Generated automatically from com.google.gson.internal.Excluder for testing purposes

package com.google.gson.internal;

import com.google.gson.ExclusionStrategy;
import com.google.gson.Gson;
import com.google.gson.TypeAdapter;
import com.google.gson.TypeAdapterFactory;
import com.google.gson.reflect.TypeToken;
import java.lang.reflect.Field;

public class Excluder implements Cloneable, TypeAdapterFactory
{
    protected Excluder clone(){ return null; }
    public <T> com.google.gson.TypeAdapter<T> create(Gson p0, com.google.gson.reflect.TypeToken<T> p1){ return null; }
    public Excluder disableInnerClassSerialization(){ return null; }
    public Excluder excludeFieldsWithoutExposeAnnotation(){ return null; }
    public Excluder withExclusionStrategy(ExclusionStrategy p0, boolean p1, boolean p2){ return null; }
    public Excluder withModifiers(int... p0){ return null; }
    public Excluder withVersion(double p0){ return null; }
    public Excluder(){}
    public boolean excludeClass(Class<? extends Object> p0, boolean p1){ return false; }
    public boolean excludeField(Field p0, boolean p1){ return false; }
    public static Excluder DEFAULT = null;
}
