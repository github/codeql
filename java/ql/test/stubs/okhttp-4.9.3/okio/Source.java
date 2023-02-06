// Generated automatically from okio.Source for testing purposes

package okio;

import java.io.Closeable;
import okio.Buffer;
import okio.Timeout;

public interface Source extends Closeable
{
    Timeout timeout();
    long read(Buffer p0, long p1);
    void close();
}
