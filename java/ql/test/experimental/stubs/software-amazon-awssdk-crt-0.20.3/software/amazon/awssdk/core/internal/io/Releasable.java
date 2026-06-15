// Generated automatically from software.amazon.awssdk.core.internal.io.Releasable for testing purposes

package software.amazon.awssdk.core.internal.io;

import java.io.Closeable;
import org.slf4j.Logger;

public interface Releasable
{
    static void release(Closeable p0, Logger p1){}
    void release();
}
