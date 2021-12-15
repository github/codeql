package javax.management.remote.rmi;

import java.rmi.Remote;
import java.io.Closeable;

interface RMIConnection extends Closeable, Remote { }
