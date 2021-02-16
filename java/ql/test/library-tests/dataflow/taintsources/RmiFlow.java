package security.library.dataflow;

import java.rmi.Remote;
import java.rmi.RemoteException;

public interface RmiFlow extends Remote {
	String listDirectory(String path) throws java.io.IOException;
}
