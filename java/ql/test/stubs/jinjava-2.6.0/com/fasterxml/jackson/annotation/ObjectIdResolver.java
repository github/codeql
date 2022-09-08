// Generated automatically from com.fasterxml.jackson.annotation.ObjectIdResolver for testing purposes

package com.fasterxml.jackson.annotation;

import com.fasterxml.jackson.annotation.ObjectIdGenerator;

public interface ObjectIdResolver
{
    Object resolveId(ObjectIdGenerator.IdKey p0);
    ObjectIdResolver newForDeserialization(Object p0);
    boolean canUseFor(ObjectIdResolver p0);
    void bindItem(ObjectIdGenerator.IdKey p0, Object p1);
}
