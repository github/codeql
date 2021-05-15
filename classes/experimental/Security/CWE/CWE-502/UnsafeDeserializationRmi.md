# Unsafe deserialization in a remotely callable method.
Java RMI uses the default Java serialization mechanism (in other words, `ObjectInputStream`) to pass parameters in remote method invocations. This mechanism is known to be unsafe when deserializing untrusted data. If a registered remote object has a method that accepts a complex object, an attacker can take advantage of the unsafe deserialization mechanism. In the worst case, it results in remote code execution.


## Recommendation
Use only strings and primitive types in parameters of remote objects.

Set a filter for incoming serialized data by wrapping remote objects using either `UnicastRemoteObject.exportObject(Remote, int, ObjectInputFilter)` or `UnicastRemoteObject.exportObject(Remote, int, RMIClientSocketFactory, RMIServerSocketFactory, ObjectInputFilter)` methods. Those methods accept an `ObjectInputFilter` that decides which classes are allowed for deserialization. The filter should allow deserializing only safe classes.

It is also possible to set a process-wide deserialization filter. The filter can be set by with `ObjectInputFilter.Config.setSerialFilter(ObjectInputFilter)` method, or by setting system or security property `jdk.serialFilter`. Make sure that you use the latest Java versions that include JEP 290. Please note that the query is not sensitive to this mitigation.

If switching to the latest Java versions is not possible, consider using other implementations of remote procedure calls. For example, HTTP API with JSON. Make sure that the underlying deserialization mechanism is properly configured so that deserialization attacks are not possible.


## Example
The following code registers a remote object with a vulnerable method that accepts a complex object:


```java
public class Server {
    public void bindRemoteObject(Registry registry) throws Exception {
        registry.bind("unsafe", new RemoteObjectImpl());
    }
}

interface RemoteObject extends Remote {
    void action(Object obj) throws RemoteException;
}

class RemoteObjectImpl implements RemoteObject {
    // ...
}
```
The next example registers a safe remote object whose methods use only primitive types and strings:


```java
public class Server {
    public void bindRemoteObject(Registry registry) throws Exception {
        registry.bind("safe", new RemoteObjectImpl());
    }
}

interface RemoteObject extends Remote {
    void calculate(int a, double b) throws RemoteException;
    void save(String s) throws RemoteException;
}

class RemoteObjectImpl implements RemoteObject {
    // ...
}
```
The next example shows how to set a deserilization filter for a remote object:


```java
public void bindRemoteObject(Registry registry, int port) throws Exception {
    ObjectInputFilter filter = info -> {
        if (info.serialClass().getCanonicalName().startsWith("com.safe.package.")) {
            return ObjectInputFilter.Status.ALLOWED;
        }
        return ObjectInputFilter.Status.REJECTED;
    };
    registry.bind("safer", UnicastRemoteObject.exportObject(new RemoteObjectImpl(), port, filter));
}

```

## References
* Oracle: [Remote Method Invocation (RMI)](https://www.oracle.com/java/technologies/javase/remote-method-invocation-home.html).
* ITNEXT: [Java RMI for pentesters part two - reconnaissance &amp; attack against non-JMX registries](https://itnext.io/java-rmi-for-pentesters-part-two-reconnaissance-attack-against-non-jmx-registries-187a6561314d).
* MOGWAI LABS: [Attacking Java RMI services after JEP 290](https://mogwailabs.de/en/blog/2019/03/attacking-java-rmi-services-after-jep-290)
* OWASP: [Deserialization of untrusted data](https://www.owasp.org/index.php/Deserialization_of_untrusted_data).
* OpenJDK: [JEP 290: Filter Incoming Serialization Data](https://openjdk.java.net/jeps/290)
* Common Weakness Enumeration: [CWE-502](https://cwe.mitre.org/data/definitions/502.html).
