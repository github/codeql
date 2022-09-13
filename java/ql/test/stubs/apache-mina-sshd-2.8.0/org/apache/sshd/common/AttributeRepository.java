// Generated automatically from org.apache.sshd.common.AttributeRepository for testing purposes

package org.apache.sshd.common;

import java.util.Collection;
import java.util.Map;

public interface AttributeRepository
{
    <T> T getAttribute(AttributeRepository.AttributeKey<T> p0);
    Collection<AttributeRepository.AttributeKey<? extends Object>> attributeKeys();
    default <T> T resolveAttribute(AttributeRepository.AttributeKey<T> p0){ return null; }
    int getAttributesCount();
    static <A> AttributeRepository ofKeyValuePair(AttributeRepository.AttributeKey<A> p0, A p1){ return null; }
    static AttributeRepository ofAttributesMap(Map<AttributeRepository.AttributeKey<? extends Object>, ? extends Object> p0){ return null; }
    static public class AttributeKey<T>
    {
        public AttributeKey(){}
    }
}
