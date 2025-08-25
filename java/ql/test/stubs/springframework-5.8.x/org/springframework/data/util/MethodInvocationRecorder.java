// Generated automatically from org.springframework.data.util.MethodInvocationRecorder for testing purposes

package org.springframework.data.util;

import java.lang.reflect.Method;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.function.Function;

public class MethodInvocationRecorder
{
    protected MethodInvocationRecorder() {}
    public static <T> MethodInvocationRecorder.Recorded<T> forProxyOf(Class<T> p0){ return null; }
    public static MethodInvocationRecorder.PropertyNameDetectionStrategy DEFAULT = null;
    static public class Recorded<T>
    {
        protected Recorded() {}
        public <S> MethodInvocationRecorder.Recorded<S> record(Function<? super T, S> p0){ return null; }
        public <S> MethodInvocationRecorder.Recorded<S> record(MethodInvocationRecorder.Recorded.ToCollectionConverter<T, S> p0){ return null; }
        public <S> MethodInvocationRecorder.Recorded<S> record(MethodInvocationRecorder.Recorded.ToMapConverter<T, S> p0){ return null; }
        public Optional<String> getPropertyPath(){ return null; }
        public Optional<String> getPropertyPath(List<MethodInvocationRecorder.PropertyNameDetectionStrategy> p0){ return null; }
        public Optional<String> getPropertyPath(MethodInvocationRecorder.PropertyNameDetectionStrategy p0){ return null; }
        public String toString(){ return null; }
        static public interface ToCollectionConverter<T, S> extends Function<T, Collection<S>>
        {
        }
        static public interface ToMapConverter<T, S> extends Function<T, Map<? extends Object, S>>
        {
        }
    }
    static public interface PropertyNameDetectionStrategy
    {
        String getPropertyName(Method p0);
    }
}
