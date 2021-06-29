public class SandboxGroovyClassLoader extends ClassLoader {
    public SandboxGroovyClassLoader(ClassLoader parent) {
        super(parent);
    }

    /* override `loadClass` here to prevent loading sensitive classes, such as `java.lang.Runtime`, `java.lang.ProcessBuilder`, `java.lang.System`, etc.  */
    /* Note we must also block `groovy.transform.ASTTest`, `groovy.lang.GrabConfig` and `org.buildobjects.process.ProcBuilder` to prevent compile-time RCE. */

    static void runWithSandboxGroovyClassLoader() throws Exception {
        // GOOD: route all class-loading via sand-boxing classloader.
        SandboxGroovyClassLoader classLoader = new GroovyClassLoader(new SandboxGroovyClassLoader());
        
        Class<?> scriptClass = classLoader.parseClass(untrusted.getQueryString());
        Object scriptInstance = scriptClass.newInstance();
        Object result = scriptClass.getDeclaredMethod("bar", new Class[]{}).invoke(scriptInstance, new Object[]{});
    }
}