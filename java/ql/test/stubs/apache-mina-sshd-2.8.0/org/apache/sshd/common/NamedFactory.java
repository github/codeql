// Generated automatically from org.apache.sshd.common.NamedFactory for testing purposes

package org.apache.sshd.common;

import java.util.Collection;
import java.util.List;
import java.util.function.Function;
import org.apache.sshd.common.Factory;
import org.apache.sshd.common.NamedResource;
import org.apache.sshd.common.OptionalFeature;

public interface NamedFactory<T> extends Factory<T>, NamedResource
{
    static <E extends NamedResource & OptionalFeature> List<E> setUpBuiltinFactories(boolean p0, Collection<? extends E> p1){ return null; }
    static <S extends OptionalFeature, E extends NamedResource> List<E> setUpTransformedFactories(boolean p0, Collection<? extends S> p1, Function<? super S, ? extends E> p2){ return null; }
    static <T> T create(Collection<? extends NamedFactory<? extends T>> p0, String p1){ return null; }
}
