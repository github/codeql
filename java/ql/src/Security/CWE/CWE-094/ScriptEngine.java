// Bad: arbitrary code execution
ScriptEngineManager scriptEngineManager = new ScriptEngineManager();
ScriptEngine scriptEngine = scriptEngineManager.getEngineByExtension("js");
Object result = scriptEngine.eval(code);