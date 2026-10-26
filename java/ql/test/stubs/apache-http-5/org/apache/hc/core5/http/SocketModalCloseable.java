// Generated automatically from org.apache.hc.core5.http.SocketModalCloseable for testing purposes

package org.apache.hc.core5.http;

import org.apache.hc.core5.io.ModalCloseable;
import org.apache.hc.core5.util.Timeout;

public interface SocketModalCloseable extends ModalCloseable
{
    Timeout getSocketTimeout();
    void setSocketTimeout(Timeout p0);
}
