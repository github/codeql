// Bad: ScriptEngine allows arbitrary code injection
ScriptEngineManager scriptEngineManager = new ScriptEngineManager();
ScriptEngine scriptEngine = scriptEngineManager.getEngineByExtension("js");
Object result = scriptEngine.eval(code);