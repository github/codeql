class HTTPRequest
{
    public class HTTPRequestStateChangeArgs : EventArgs
    {
        private String state;
        public HTTPRequestStateChangeArgs(String state)
        {
            this.state = state;
        }
    }

    public delegate void HTTPRequestStateChange(object sender, HTTPRequestStateChangeArgs e);

    public event HTTPRequestStateChange HTTPRequestStateChangeEvent;

    public void send()
    {
        HTTPRequestStateChangeEvent(this, new HTTPRequestStateChangeArgs("sent"));
        HTTPRequestStateChangeEvent(this, new HTTPRequestStateChangeArgs("responsestart"));
        HTTPRequestStateChangeEvent(this, new HTTPRequestStateChangeArgs("responseend"));
        HTTPRequestStateChangeEvent(this, new HTTPRequestStateChangeArgs("responseprocessed"));
    }
}
