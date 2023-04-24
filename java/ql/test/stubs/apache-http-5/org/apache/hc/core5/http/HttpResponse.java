// Generated automatically from org.apache.hc.core5.http.HttpResponse for testing purposes

package org.apache.hc.core5.http;

import java.util.Locale;
import org.apache.hc.core5.http.HttpMessage;

public interface HttpResponse extends HttpMessage
{
    Locale getLocale();
    String getReasonPhrase();
    int getCode();
    void setCode(int p0);
    void setLocale(Locale p0);
    void setReasonPhrase(String p0);
}
