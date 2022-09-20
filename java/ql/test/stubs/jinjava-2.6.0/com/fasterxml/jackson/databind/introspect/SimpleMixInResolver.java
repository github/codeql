// Generated automatically from com.fasterxml.jackson.databind.introspect.SimpleMixInResolver for testing purposes

package com.fasterxml.jackson.databind.introspect;

import com.fasterxml.jackson.databind.introspect.ClassIntrospector;
import com.fasterxml.jackson.databind.type.ClassKey;
import java.io.Serializable;
import java.util.Map;

public class SimpleMixInResolver implements ClassIntrospector.MixInResolver, Serializable
{
    protected SimpleMixInResolver() {}
    protected Map<ClassKey, Class<? extends Object>> _localMixIns = null;
    protected SimpleMixInResolver(ClassIntrospector.MixInResolver p0, Map<ClassKey, Class<? extends Object>> p1){}
    protected final ClassIntrospector.MixInResolver _overrides = null;
    public Class<? extends Object> findMixInClassFor(Class<? extends Object> p0){ return null; }
    public SimpleMixInResolver copy(){ return null; }
    public SimpleMixInResolver withOverrides(ClassIntrospector.MixInResolver p0){ return null; }
    public SimpleMixInResolver withoutLocalDefinitions(){ return null; }
    public SimpleMixInResolver(ClassIntrospector.MixInResolver p0){}
    public int localSize(){ return 0; }
    public void addLocalDefinition(Class<? extends Object> p0, Class<? extends Object> p1){}
    public void setLocalDefinitions(Map<Class<? extends Object>, Class<? extends Object>> p0){}
}
