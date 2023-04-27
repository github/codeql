// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.util.RootNameLookup for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.util;

import java.io.Serializable;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JavaType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.PropertyName;
import org.apache.htrace.shaded.fasterxml.jackson.databind.cfg.MapperConfig;
import org.apache.htrace.shaded.fasterxml.jackson.databind.type.ClassKey;
import org.apache.htrace.shaded.fasterxml.jackson.databind.util.LRUMap;

public class RootNameLookup implements Serializable
{
    protected LRUMap<ClassKey, PropertyName> _rootNames = null;
    protected Object readResolve(){ return null; }
    public PropertyName findRootName(Class<? extends Object> p0, MapperConfig<? extends Object> p1){ return null; }
    public PropertyName findRootName(JavaType p0, MapperConfig<? extends Object> p1){ return null; }
    public RootNameLookup(){}
}
