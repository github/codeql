package javax.script;

import java.io.Reader;

public interface Compilable {
    public CompiledScript compile(String script) throws ScriptException;

    public CompiledScript compile(Reader script) throws ScriptException;
}
