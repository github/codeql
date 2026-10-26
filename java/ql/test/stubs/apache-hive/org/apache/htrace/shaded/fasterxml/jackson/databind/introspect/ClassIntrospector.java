// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.ClassIntrospector for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.introspect;

import org.apache.htrace.shaded.fasterxml.jackson.databind.BeanDescription;
import org.apache.htrace.shaded.fasterxml.jackson.databind.DeserializationConfig;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JavaType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.SerializationConfig;
import org.apache.htrace.shaded.fasterxml.jackson.databind.cfg.MapperConfig;

abstract public class ClassIntrospector
{
    protected ClassIntrospector(){}
    public abstract BeanDescription forClassAnnotations(MapperConfig<? extends Object> p0, JavaType p1, ClassIntrospector.MixInResolver p2);
    public abstract BeanDescription forCreation(DeserializationConfig p0, JavaType p1, ClassIntrospector.MixInResolver p2);
    public abstract BeanDescription forDeserialization(DeserializationConfig p0, JavaType p1, ClassIntrospector.MixInResolver p2);
    public abstract BeanDescription forDeserializationWithBuilder(DeserializationConfig p0, JavaType p1, ClassIntrospector.MixInResolver p2);
    public abstract BeanDescription forDirectClassAnnotations(MapperConfig<? extends Object> p0, JavaType p1, ClassIntrospector.MixInResolver p2);
    public abstract BeanDescription forSerialization(SerializationConfig p0, JavaType p1, ClassIntrospector.MixInResolver p2);
    static public interface MixInResolver
    {
        Class<? extends Object> findMixInClassFor(Class<? extends Object> p0);
    }
}
