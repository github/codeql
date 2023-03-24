// Generated automatically from org.thymeleaf.cache.ICache for testing purposes

package org.thymeleaf.cache;

import java.util.Set;
import org.thymeleaf.cache.ICacheEntryValidityChecker;

public interface ICache<K, V>
{
    Set<K> keySet();
    V get(K p0);
    V get(K p0, ICacheEntryValidityChecker<? super K, ? super V> p1);
    void clear();
    void clearKey(K p0);
    void put(K p0, V p1);
}
