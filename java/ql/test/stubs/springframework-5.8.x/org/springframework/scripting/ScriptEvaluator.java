package org.springframework.scripting;

import java.util.Map;
import org.springframework.lang.Nullable;

public interface ScriptEvaluator {
    @Nullable
    Object evaluate(ScriptSource var1) ;

    @Nullable
    Object evaluate(ScriptSource var1, @Nullable Map<String, Object> var2) ;
}
