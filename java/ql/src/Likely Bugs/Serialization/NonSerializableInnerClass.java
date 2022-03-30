class NonSerializableServer {

    // BAD: The following class is serializable, but the enclosing class
    // 'NonSerializableServer' is not. Serializing an instance of 'WrongSession' 
    // causes a 'java.io.NotSerializableException'.
    class WrongSession implements Serializable {
        private static final long serialVersionUID = 8970783971992397218L;
        private int id;
        private String user;
        
        WrongSession(int id, String user) { /*...*/ }
    }
    
    public WrongSession getNewSession(String user) {
        return new WrongSession(newId(), user);
    }
}

class Server {

    // GOOD: The following class can be correctly serialized because it is static.
    static class Session implements Serializable {
        private static final long serialVersionUID = 1065454318648105638L;
        private int id;
        private String user;
        
        Session(int id, String user) { /*...*/ }
    }
    
    public Session getNewSession(String user) {
        return new Session(newId(), user);
    }
}