import java.rmi.Naming;
import java.rmi.Remote;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;

public class RmiUnsafeDeserialization {
    
    // BAD (bind a remote object that has a vulnerable method that takes Object)
    public static void testRegistryBindWithObjectParameter() throws Exception {
        Registry registry = LocateRegistry.createRegistry(1099);
        registry.bind("test", new RemoteObjectWithObject());
    }
}

interface RemoteObjectWithObjectInterface extends Remote {

    void take(Object obj) throws RemoteException;
}

class RemoteObjectWithObject implements RemoteObjectWithObjectInterface {

    public void take(Object obj) throws RemoteException {}
}
