// Generated automatically from org.thymeleaf.cache.ICacheEntryValidityChecker for testing purposes

package org.thymeleaf.cache;

import java.io.Serializable;

public interface ICacheEntryValidityChecker<K, V> extends Serializable
{
    boolean checkIsValueStillValid(K p0, V p1, long p2);
}
