import java.io.ObjectInputStream;
import java.rmi.Naming;
import java.rmi.Remote;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;

public class UnsafeDeserializationRmi {

    // BAD (bind a remote object that has a vulnerable method that takes Object)
    public static void testRegistryBindWithObjectParameter() throws Exception {
        Registry registry = LocateRegistry.createRegistry(1099);
        registry.bind("test", new RemoteObjectWithObject());
        registry.rebind("test", new RemoteObjectWithObject());
    }

    // GOOD (bind a remote object that has methods that takes safe parameters)
    public static void testRegistryBindWithIntParameter() throws Exception {
        Registry registry = LocateRegistry.createRegistry(1099);
        registry.bind("test", new SafeRemoteObject());
        registry.rebind("test", new SafeRemoteObject());
    }

    // BAD (bind a remote object that has a vulnerable method that takes Object)
    public static void testNamingBindWithObjectParameter() throws Exception {
        Naming.bind("test", new RemoteObjectWithObject());
        Naming.rebind("test", new RemoteObjectWithObject());
    }

    // GOOD (bind a remote object that has methods that takes safe parameters)
    public static void testNamingBindWithIntParameter() throws Exception {
        Naming.bind("test", new SafeRemoteObject());
        Naming.rebind("test", new SafeRemoteObject());
    }
}

interface RemoteObjectWithObjectInterface extends Remote {
    void take(Object obj) throws RemoteException;
}

class RemoteObjectWithObject implements RemoteObjectWithObjectInterface {
    public void take(Object obj) throws RemoteException {}
}

interface SafeRemoteObjectInterface extends Remote {
    void take(int n) throws RemoteException;
    void take(double n) throws RemoteException;
    void take(String s) throws RemoteException;
    void take(ObjectInputStream ois) throws RemoteException;
}

class SafeRemoteObject implements SafeRemoteObjectInterface {
    public void take(int n) throws RemoteException {}
    public void take(double n) throws RemoteException {}
    public void take(String s) throws RemoteException {}
    public void take(ObjectInputStream ois) throws RemoteException {}
    public void safeMethod(Object object) {} // this method is not declared in SafeRemoteObjectInterface
}
