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