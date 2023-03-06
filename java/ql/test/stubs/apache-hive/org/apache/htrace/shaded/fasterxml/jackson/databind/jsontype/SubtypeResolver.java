// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.databind.jsontype.SubtypeResolver for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.databind.jsontype;

import java.util.Collection;
import org.apache.htrace.shaded.fasterxml.jackson.databind.AnnotationIntrospector;
import org.apache.htrace.shaded.fasterxml.jackson.databind.JavaType;
import org.apache.htrace.shaded.fasterxml.jackson.databind.cfg.MapperConfig;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.AnnotatedClass;
import org.apache.htrace.shaded.fasterxml.jackson.databind.introspect.AnnotatedMember;
import org.apache.htrace.shaded.fasterxml.jackson.databind.jsontype.NamedType;

abstract public class SubtypeResolver
{
    public SubtypeResolver(){}
    public abstract Collection<NamedType> collectAndResolveSubtypes(AnnotatedClass p0, MapperConfig<? extends Object> p1, AnnotationIntrospector p2);
    public abstract Collection<NamedType> collectAndResolveSubtypes(AnnotatedMember p0, MapperConfig<? extends Object> p1, AnnotationIntrospector p2, JavaType p3);
    public abstract void registerSubtypes(Class<? extends Object>... p0);
    public abstract void registerSubtypes(NamedType... p0);
}
