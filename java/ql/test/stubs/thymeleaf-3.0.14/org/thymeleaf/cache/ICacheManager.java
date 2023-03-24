// Generated automatically from org.thymeleaf.cache.ICacheManager for testing purposes

package org.thymeleaf.cache;

import java.util.List;
import org.thymeleaf.cache.ExpressionCacheKey;
import org.thymeleaf.cache.ICache;
import org.thymeleaf.cache.TemplateCacheKey;
import org.thymeleaf.engine.TemplateModel;

public interface ICacheManager
{
    <K, V> ICache<K, V> getSpecificCache(String p0);
    ICache<ExpressionCacheKey, Object> getExpressionCache();
    ICache<TemplateCacheKey, TemplateModel> getTemplateCache();
    List<String> getAllSpecificCacheNames();
    void clearAllCaches();
}
