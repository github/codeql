// Generated automatically from org.jdbi.v3.core.qualifier.QualifiedType for testing purposes

package org.jdbi.v3.core.qualifier;

import java.lang.annotation.Annotation;
import java.lang.reflect.Type;
import java.util.Optional;
import java.util.Set;
import java.util.function.Function;
import org.jdbi.v3.core.generic.GenericType;

public class QualifiedType<T>
{
    protected QualifiedType() {}
    public Optional<QualifiedType<? extends Object>> flatMapType(Function<Type, Optional<Type>> p0){ return null; }
    public QualifiedType<? extends Object> mapType(Function<Type, Type> p0){ return null; }
    public QualifiedType<T> with(Annotation... p0){ return null; }
    public QualifiedType<T> withAnnotationClasses(Iterable<Class<? extends Annotation>> p0){ return null; }
    public QualifiedType<T> withAnnotations(Iterable<? extends Annotation> p0){ return null; }
    public Set<Annotation> getQualifiers(){ return null; }
    public String toString(){ return null; }
    public Type getType(){ return null; }
    public boolean equals(Object p0){ return false; }
    public boolean hasQualifier(Class<? extends Annotation> p0){ return false; }
    public final QualifiedType<T> with(Class<? extends Annotation>... p0){ return null; }
    public int hashCode(){ return 0; }
    public static <T> org.jdbi.v3.core.qualifier.QualifiedType<T> of(java.lang.Class<T> p0){ return null; }
    public static <T> org.jdbi.v3.core.qualifier.QualifiedType<T> of(org.jdbi.v3.core.generic.GenericType<T> p0){ return null; }
    public static QualifiedType<? extends Object> of(Type p0){ return null; }
}
