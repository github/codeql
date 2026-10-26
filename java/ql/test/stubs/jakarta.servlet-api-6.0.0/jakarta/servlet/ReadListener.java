// Generated automatically from jakarta.servlet.ReadListener for testing purposes

package jakarta.servlet;

import java.util.EventListener;

public interface ReadListener extends EventListener
{
    void onAllDataRead();
    void onDataAvailable();
    void onError(Throwable p0);
}
