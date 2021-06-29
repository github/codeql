public void bindRemoteObject(Registry registry, int port) throws Exception {
    ObjectInputFilter filter = info -> {
        if (info.serialClass().getCanonicalName().startsWith("com.safe.package.")) {
            return ObjectInputFilter.Status.ALLOWED;
        }
        return ObjectInputFilter.Status.REJECTED;
    };
    registry.bind("safer", UnicastRemoteObject.exportObject(new RemoteObjectImpl(), port, filter));
}
