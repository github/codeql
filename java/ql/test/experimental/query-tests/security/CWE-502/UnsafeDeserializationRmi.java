import java.io.ObjectInputFilter;
import java.io.ObjectInputStream;
import java.rmi.Naming;
import java.rmi.Remote;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.rmi.server.UnicastRemoteObject;

public class UnsafeDeserializationRmi {

    // BAD (bind a remote object that has a vulnerable method)
    public static void testRegistryBindWithObjectParameter() throws Exception {
        Registry registry = LocateRegistry.createRegistry(1099);
        registry.bind("unsafe", new UnsafeRemoteObjectImpl());
        registry.rebind("unsafe", new UnsafeRemoteObjectImpl());
        registry.rebind("unsafe", UnicastRemoteObject.exportObject(new UnsafeRemoteObjectImpl()));
    }

    // GOOD (bind a remote object that has methods that takes safe parameters)
    public static void testRegistryBindWithIntParameter() throws Exception {
        Registry registry = LocateRegistry.createRegistry(1099);
        registry.bind("safe", new SafeRemoteObjectImpl());
        registry.rebind("safe", new SafeRemoteObjectImpl());
    }

    // BAD (bind a remote object that has a vulnerable method)
    public static void testNamingBindWithObjectParameter() throws Exception {
        Naming.bind("unsafe", new UnsafeRemoteObjectImpl());
        Naming.rebind("unsafe", new UnsafeRemoteObjectImpl());
    }

    // GOOD (bind a remote object that has methods that takes safe parameters)
    public static void testNamingBindWithIntParameter() throws Exception {
        Naming.bind("safe", new SafeRemoteObjectImpl());
        Naming.rebind("safe", new SafeRemoteObjectImpl());
    }

    // GOOD (bind a remote object with a deserialization filter)
    public static void testRegistryBindWithDeserializationFilter() throws Exception {
        Registry registry = LocateRegistry.createRegistry(1099);
        ObjectInputFilter filter = info -> {
            if (info.serialClass().getCanonicalName().startsWith("com.safe.package.")) {
                return ObjectInputFilter.Status.ALLOWED;
            }
            return ObjectInputFilter.Status.REJECTED;
        };
        registry.rebind("safe", UnicastRemoteObject.exportObject(new UnsafeRemoteObjectImpl(), 12345, filter));
    }
}

interface UnsafeRemoteObject extends Remote {
    void take(Object obj) throws RemoteException;
}

class UnsafeRemoteObjectImpl implements UnsafeRemoteObject {
    public void take(Object obj) throws RemoteException {}
}

interface SafeRemoteObject extends Remote {
    void take(int n) throws RemoteException;
    void take(double n) throws RemoteException;
    void take(String s) throws RemoteException;
    void take(ObjectInputStream ois) throws RemoteException;
}

class SafeRemoteObjectImpl implements SafeRemoteObject {
    public void take(int n) throws RemoteException {}
    public void take(double n) throws RemoteException {}
    public void take(String s) throws RemoteException {}
    public void take(ObjectInputStream ois) throws RemoteException {}
    public void safeMethod(Object object) {} // this method is not declared in SafeRemoteObject
}
