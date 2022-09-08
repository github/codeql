// Generated automatically from com.mitchellbosecke.pebble.PebbleEngine for testing purposes

package com.mitchellbosecke.pebble;

import com.mitchellbosecke.pebble.attributes.methodaccess.MethodAccessValidator;
import com.mitchellbosecke.pebble.cache.CacheKey;
import com.mitchellbosecke.pebble.cache.PebbleCache;
import com.mitchellbosecke.pebble.extension.Extension;
import com.mitchellbosecke.pebble.extension.ExtensionCustomizer;
import com.mitchellbosecke.pebble.extension.ExtensionRegistry;
import com.mitchellbosecke.pebble.extension.escaper.EscapingStrategy;
import com.mitchellbosecke.pebble.lexer.Syntax;
import com.mitchellbosecke.pebble.loader.Loader;
import com.mitchellbosecke.pebble.template.EvaluationOptions;
import com.mitchellbosecke.pebble.template.PebbleTemplate;
import java.util.Locale;
import java.util.concurrent.ExecutorService;
import java.util.function.Function;

public class PebbleEngine
{
    protected PebbleEngine() {}
    public EvaluationOptions getEvaluationOptions(){ return null; }
    public ExecutorService getExecutorService(){ return null; }
    public ExtensionRegistry getExtensionRegistry(){ return null; }
    public Loader<? extends Object> getLoader(){ return null; }
    public Locale getDefaultLocale(){ return null; }
    public PebbleCache<CacheKey, Object> getTagCache(){ return null; }
    public PebbleCache<Object, PebbleTemplate> getTemplateCache(){ return null; }
    public PebbleTemplate getLiteralTemplate(String p0){ return null; }
    public PebbleTemplate getTemplate(String p0){ return null; }
    public Syntax getSyntax(){ return null; }
    public boolean isStrictVariables(){ return false; }
    public int getMaxRenderedSize(){ return 0; }
    static public class Builder
    {
        public Builder(){}
        public PebbleEngine build(){ return null; }
        public PebbleEngine.Builder addEscapingStrategy(String p0, EscapingStrategy p1){ return null; }
        public PebbleEngine.Builder allowOverrideCoreOperators(boolean p0){ return null; }
        public PebbleEngine.Builder autoEscaping(boolean p0){ return null; }
        public PebbleEngine.Builder cacheActive(boolean p0){ return null; }
        public PebbleEngine.Builder defaultEscapingStrategy(String p0){ return null; }
        public PebbleEngine.Builder defaultLocale(Locale p0){ return null; }
        public PebbleEngine.Builder executorService(ExecutorService p0){ return null; }
        public PebbleEngine.Builder extension(Extension... p0){ return null; }
        public PebbleEngine.Builder greedyMatchMethod(boolean p0){ return null; }
        public PebbleEngine.Builder literalDecimalTreatedAsInteger(boolean p0){ return null; }
        public PebbleEngine.Builder literalNumbersAsBigDecimals(boolean p0){ return null; }
        public PebbleEngine.Builder loader(Loader<? extends Object> p0){ return null; }
        public PebbleEngine.Builder maxRenderedSize(int p0){ return null; }
        public PebbleEngine.Builder methodAccessValidator(MethodAccessValidator p0){ return null; }
        public PebbleEngine.Builder newLineTrimming(boolean p0){ return null; }
        public PebbleEngine.Builder registerExtensionCustomizer(Function<Extension, ExtensionCustomizer> p0){ return null; }
        public PebbleEngine.Builder strictVariables(boolean p0){ return null; }
        public PebbleEngine.Builder syntax(Syntax p0){ return null; }
        public PebbleEngine.Builder tagCache(PebbleCache<CacheKey, Object> p0){ return null; }
        public PebbleEngine.Builder templateCache(PebbleCache<Object, PebbleTemplate> p0){ return null; }
    }
}
