// Generated automatically from org.apache.sshd.common.AttributeStore for testing purposes

package org.apache.sshd.common;

import java.util.function.Function;
import org.apache.sshd.common.AttributeRepository;

public interface AttributeStore extends AttributeRepository
{
    <T> T removeAttribute(AttributeRepository.AttributeKey<T> p0);
    <T> T setAttribute(AttributeRepository.AttributeKey<T> p0, T p1);
    default <T> T computeAttributeIfAbsent(AttributeRepository.AttributeKey<T> p0, Function<? super AttributeRepository.AttributeKey<T>, ? extends T> p1){ return null; }
    void clearAttributes();
}
