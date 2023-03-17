// Generated automatically from javax.servlet.AsyncListener for testing purposes

package javax.servlet;

import java.util.EventListener;
import javax.servlet.AsyncEvent;

public interface AsyncListener extends EventListener
{
    void onComplete(AsyncEvent p0);
    void onError(AsyncEvent p0);
    void onStartAsync(AsyncEvent p0);
    void onTimeout(AsyncEvent p0);
}
