class SSRF {
    /** Test url.openStream() */
    public void openUrlStream(HttpServletRequest servletRequest) {
        {
            String urlStr = servletRequest.getParameter("url");
            URL uri = new URL(urlStr);
            InputStream input = uri.openStream(); // BAD: open url stream from remote source without validation
        }

        {
            String urlStr = servletRequest.getParameter("url");
            if (urlStr.startsWith("https://www.mycorp.com")) {
                URL uri = new URL(urlStr);
                InputStream input = uri.openStream(); // GOOD: open url stream from remote source with validation
            }
        }
    }

    /** Test url.openConnection() */
    public void openUrlConnection(HttpServletRequest servletRequest) {
        {
            String urlStr = servletRequest.getParameter("url");
            URL uri = new URL(urlStr);
            URLConnection input = uri.openConnection(); // BAD: open url connection from remote source without
                                                        // validation
        }

        {
            String urlStr = servletRequest.getParameter("url");
            if (urlStr.startsWith("https://www.mycorp.com")) {
                URL uri = new URL(urlStr);
                URLConnection input = uri.openConnection(); // GOOD: open url connection from remote source with
                                                            // validation
            }
        }
    }

    /** Test Apache HttpRequest */
    public void service(HttpServletRequest servletRequest, HttpServletResponse servletResponse)
            throws ServletException, IOException {
        String method = servletRequest.getMethod();
        String proxyRequestUri = servletRequest.getParameter("url");

        {
            URI targetUriObj = new URI(proxyRequestUri);
            HttpRequest proxyRequest = new BasicHttpRequest(method, proxyRequestUri);  //BAD: open HTTPRequest from remote source without validation    
        }

        {
            if (proxyRequestUri.startsWith("https://www.mycorp.com")) {
                URI targetUriObj = new URI(proxyRequestUri);
                HttpRequest proxyRequest = new BasicHttpRequest(method, proxyRequestUri);  //GOOD: open HTTPRequest from remote source with validation        
            }
        }
    }

}