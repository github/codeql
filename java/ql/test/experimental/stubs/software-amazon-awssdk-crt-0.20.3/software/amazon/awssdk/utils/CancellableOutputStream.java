// Generated automatically from software.amazon.awssdk.utils.CancellableOutputStream for testing purposes

package software.amazon.awssdk.utils;

import java.io.OutputStream;

abstract public class CancellableOutputStream extends OutputStream
{
    public CancellableOutputStream(){}
    public abstract void cancel();
}
