// Generated automatically from okio.Sink for testing purposes

package okio;

import java.io.Closeable;
import java.io.Flushable;
import okio.Buffer;
import okio.Timeout;

public interface Sink extends Closeable, Flushable
{
    Timeout timeout();
    void close();
    void flush();
    void write(Buffer p0, long p1);
}
