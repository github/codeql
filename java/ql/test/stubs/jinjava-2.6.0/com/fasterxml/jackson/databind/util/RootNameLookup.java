// Generated automatically from com.fasterxml.jackson.databind.util.RootNameLookup for testing purposes

package com.fasterxml.jackson.databind.util;

import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.PropertyName;
import com.fasterxml.jackson.databind.cfg.MapperConfig;
import com.fasterxml.jackson.databind.type.ClassKey;
import com.fasterxml.jackson.databind.util.LRUMap;
import java.io.Serializable;

public class RootNameLookup implements Serializable
{
    protected LRUMap<ClassKey, PropertyName> _rootNames = null;
    protected Object readResolve(){ return null; }
    public PropertyName findRootName(Class<? extends Object> p0, MapperConfig<? extends Object> p1){ return null; }
    public PropertyName findRootName(JavaType p0, MapperConfig<? extends Object> p1){ return null; }
    public RootNameLookup(){}
}
