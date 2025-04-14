package org.springframework.remoting.rmi;

public abstract class RmiBasedExporter {

    public void setService(Object service) {}

    public void setServiceInterface(Class clazz) {}

    public void setServiceName(String name) {}

    public void setRegistryPort(int port) {}
}