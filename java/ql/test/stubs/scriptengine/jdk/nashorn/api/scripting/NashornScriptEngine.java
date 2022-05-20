package jdk.nashorn.api.scripting;

import java.io.Reader;

import javax.script.AbstractScriptEngine;
import javax.script.Compilable;
import javax.script.CompiledScript;
import javax.script.ScriptEngine;
import javax.script.ScriptEngineFactory;
import javax.script.ScriptException;

public final class NashornScriptEngine extends AbstractScriptEngine implements Compilable {
	public Object eval(String var1) throws ScriptException {
		return null;
	}

	@Override
	public ScriptEngineFactory getFactory() {
		return null;
	}

	@Override
	public CompiledScript compile(final Reader reader) throws ScriptException {
		return null;
	}

	@Override
	public CompiledScript compile(final String str) throws ScriptException {
		return null;
	}
}
