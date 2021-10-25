package jdk.nashorn.api.scripting;

import javax.script.ScriptEngine;
import javax.script.ScriptEngineFactory;

public final class NashornScriptEngineFactory implements ScriptEngineFactory {

    public NashornScriptEngineFactory() {
    }

    @Override
    public String getEngineName() {
        return null;
    }

    @Override
    public String getMethodCallSyntax(final String obj, final String method, final String... args) {
        return null;
    }

    @Override
    public String getProgram(final String... statements) {
        return null;
    }

    @Override
    public ScriptEngine getScriptEngine() {
        return null;
    }

    public ScriptEngine getScriptEngine(final ClassLoader appLoader) {
        return null;
    }

    public ScriptEngine getScriptEngine(final ClassFilter classFilter) {
        return null;
    }

    public ScriptEngine getScriptEngine(final String... args) {
        return null;
    }

    public ScriptEngine getScriptEngine(final String[] args, final ClassLoader appLoader) {
        return null;
    }

    public ScriptEngine getScriptEngine(final String[] args, final ClassLoader appLoader, final ClassFilter classFilter) {
        return null;
    }
}
