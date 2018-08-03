class HTTPRequest
{
    public class HTTPRequestSentArgs : EventArgs { }
    public class HTTPRequestResponseStartArgs : EventArgs { }
    public class HTTPRequestResponseEndArgs : EventArgs { }
    public class HTTPRequestResponseProcessedArgs : EventArgs { }

    public delegate void HTTPRequestSent(object sender, HTTPRequestSentArgs e);
    public delegate void HTTPRequestResponseStart(object sender, HTTPRequestResponseStartArgs e);
    public delegate void HTTPRequestResponseEnd(object sender, HTTPRequestResponseEndArgs e);
    public delegate void HTTPRequestResponseProcessed(object sender, HTTPRequestResponseProcessedArgs e);

    public event HTTPRequestSent HTTPRequestSentEvent;
    public event HTTPRequestResponseStart HTTPRequestResponseStartEvent;
    public event HTTPRequestResponseEnd HTTPRequestResponseEndEvent;
    public event HTTPRequestResponseProcessed HTTPRequestResponseProcessedEvent;

    public void send()
    {
        HTTPRequestSentEvent(this, new HTTPRequestSentArgs());
        HTTPRequestResponseStartEvent(this, new HTTPRequestResponseStartArgs());
        HTTPRequestResponseEndEvent(this, new HTTPRequestResponseEndArgs());
        HTTPRequestResponseProcessedEvent(this, new HTTPRequestResponseProcessedArgs());
    }
}
