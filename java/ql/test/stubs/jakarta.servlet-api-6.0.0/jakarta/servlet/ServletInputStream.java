// Generated automatically from jakarta.servlet.ServletInputStream for testing purposes

package jakarta.servlet;

import jakarta.servlet.ReadListener;
import java.io.InputStream;

abstract public class ServletInputStream extends InputStream
{
    protected ServletInputStream(){}
    public abstract boolean isFinished();
    public abstract boolean isReady();
    public abstract void setReadListener(ReadListener p0);
    public int readLine(byte[] p0, int p1, int p2){ return 0; }
}
