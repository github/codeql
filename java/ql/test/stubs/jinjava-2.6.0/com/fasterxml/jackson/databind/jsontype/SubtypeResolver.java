// Generated automatically from com.fasterxml.jackson.databind.jsontype.SubtypeResolver for testing purposes

package com.fasterxml.jackson.databind.jsontype;

import com.fasterxml.jackson.databind.AnnotationIntrospector;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.cfg.MapperConfig;
import com.fasterxml.jackson.databind.introspect.AnnotatedClass;
import com.fasterxml.jackson.databind.introspect.AnnotatedMember;
import com.fasterxml.jackson.databind.jsontype.NamedType;
import java.util.Collection;

abstract public class SubtypeResolver
{
    public Collection<NamedType> collectAndResolveSubtypesByClass(MapperConfig<? extends Object> p0, AnnotatedClass p1){ return null; }
    public Collection<NamedType> collectAndResolveSubtypesByClass(MapperConfig<? extends Object> p0, AnnotatedMember p1, JavaType p2){ return null; }
    public Collection<NamedType> collectAndResolveSubtypesByTypeId(MapperConfig<? extends Object> p0, AnnotatedClass p1){ return null; }
    public Collection<NamedType> collectAndResolveSubtypesByTypeId(MapperConfig<? extends Object> p0, AnnotatedMember p1, JavaType p2){ return null; }
    public SubtypeResolver(){}
    public abstract Collection<NamedType> collectAndResolveSubtypes(AnnotatedClass p0, MapperConfig<? extends Object> p1, AnnotationIntrospector p2);
    public abstract Collection<NamedType> collectAndResolveSubtypes(AnnotatedMember p0, MapperConfig<? extends Object> p1, AnnotationIntrospector p2, JavaType p3);
    public abstract void registerSubtypes(Class<? extends Object>... p0);
    public abstract void registerSubtypes(NamedType... p0);
}
