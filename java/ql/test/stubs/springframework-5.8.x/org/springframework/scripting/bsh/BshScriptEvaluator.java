package org.springframework.scripting.bsh;

import java.util.Map;
import org.springframework.beans.factory.BeanClassLoaderAware;
import org.springframework.lang.Nullable;
import org.springframework.scripting.ScriptEvaluator;
import org.springframework.scripting.ScriptSource;

public class BshScriptEvaluator implements ScriptEvaluator, BeanClassLoaderAware {

    public BshScriptEvaluator() { }

    public BshScriptEvaluator(ClassLoader classLoader) { }

    public void setBeanClassLoader(ClassLoader classLoader) { }

    @Nullable
    public Object evaluate(ScriptSource script) {
        return null;
    }

    @Nullable
    public Object evaluate(ScriptSource script, @Nullable Map<String, Object> arguments) {
        return null;
    }
}
