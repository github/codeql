// Generated automatically from org.apache.htrace.shaded.fasterxml.jackson.annotation.ObjectIdResolver for testing purposes

package org.apache.htrace.shaded.fasterxml.jackson.annotation;

import org.apache.htrace.shaded.fasterxml.jackson.annotation.ObjectIdGenerator;

public interface ObjectIdResolver
{
    Object resolveId(ObjectIdGenerator.IdKey p0);
    ObjectIdResolver newForDeserialization(Object p0);
    boolean canUseFor(ObjectIdResolver p0);
    void bindItem(ObjectIdGenerator.IdKey p0, Object p1);
}
