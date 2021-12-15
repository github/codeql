public static void main(String[] args) {
    {
        try {
            TestImpl obj = new TestImpl();

            // BAD: default socket factory is used
            Test stub = (Test) UnicastRemoteObject.exportObject(obj, 0);
        } catch (Exception e) {
            // fail
        }
    }

    {
        try {
            TestImpl obj = new TestImpl();
            SslRMIClientSocketFactory csf = new SslRMIClientSocketFactory();
            SslRMIServerSocketFactory ssf = new SslRMIServerSocketFactory();

            // GOOD: SSL factories are used
            Test stub = (Test) UnicastRemoteObject.exportObject(obj, 0, csf, ssf);
        } catch (Exception e) {
            // fail
        }
    }
}
