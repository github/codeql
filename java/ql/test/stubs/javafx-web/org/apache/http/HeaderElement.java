// Generated automatically from org.apache.http.HeaderElement for testing purposes

package org.apache.http;

import org.apache.http.NameValuePair;

public interface HeaderElement
{
    NameValuePair getParameter(int p0);
    NameValuePair getParameterByName(String p0);
    NameValuePair[] getParameters();
    String getName();
    String getValue();
    int getParameterCount();
}
