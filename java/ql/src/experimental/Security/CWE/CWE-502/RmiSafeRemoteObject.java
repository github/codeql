public class Server {
    public static void main(String... args) throws Exception {
        Registry registry = LocateRegistry.createRegistry(1099);
        registry.bind("unsafe", new RemoteObjectImpl());
    }
}

interface RemoteObject extends Remote {
    void calculate(int a, double b) throws RemoteException;
    void save(String s) throws RemoteException;
}

class RemoteObjectImpl implements RemoteObject {
    // ...
}