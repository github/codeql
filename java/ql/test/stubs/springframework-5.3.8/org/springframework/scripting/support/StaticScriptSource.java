package org.springframework.scripting.support;

import org.springframework.lang.Nullable;
import org.springframework.scripting.ScriptSource;

public class StaticScriptSource implements ScriptSource {

    public StaticScriptSource(String script) { }

    public StaticScriptSource(String script, @Nullable String className) { }

    public synchronized void setScript(String script) { }

    public synchronized String getScriptAsString() {
        return null;
    }

    public synchronized boolean isModified() {
        return true;
    }

    @Nullable
    public String suggestedClassName() {
        return null;
    }

    public String toString() {
        return null;
    }
}
