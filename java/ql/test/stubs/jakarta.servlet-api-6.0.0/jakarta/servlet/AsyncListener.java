// Generated automatically from jakarta.servlet.AsyncListener for testing purposes

package jakarta.servlet;

import jakarta.servlet.AsyncEvent;
import java.util.EventListener;

public interface AsyncListener extends EventListener
{
    void onComplete(AsyncEvent p0);
    void onError(AsyncEvent p0);
    void onStartAsync(AsyncEvent p0);
    void onTimeout(AsyncEvent p0);
}
