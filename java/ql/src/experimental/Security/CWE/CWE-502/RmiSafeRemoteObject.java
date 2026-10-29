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