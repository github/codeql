// Generated automatically from android.webkit.WebMessagePort for testing purposes

package android.webkit;

import android.os.Handler;
import android.webkit.WebMessage;

abstract public class WebMessagePort
{
    abstract static public class WebMessageCallback
    {
        public WebMessageCallback(){}
        public void onMessage(WebMessagePort p0, WebMessage p1){}
    }
    public abstract void close();
    public abstract void postMessage(WebMessage p0);
    public abstract void setWebMessageCallback(WebMessagePort.WebMessageCallback p0);
    public abstract void setWebMessageCallback(WebMessagePort.WebMessageCallback p0, Handler p1);
}
