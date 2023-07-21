// Generated automatically from org.apache.http.HttpResponse for testing purposes

package org.apache.http;

import java.util.Locale;
import org.apache.http.HttpEntity;
import org.apache.http.HttpMessage;
import org.apache.http.ProtocolVersion;
import org.apache.http.StatusLine;

public interface HttpResponse extends HttpMessage
{
    HttpEntity getEntity();
    Locale getLocale();
    StatusLine getStatusLine();
    void setEntity(HttpEntity p0);
    void setLocale(Locale p0);
    void setReasonPhrase(String p0);
    void setStatusCode(int p0);
    void setStatusLine(ProtocolVersion p0, int p1);
    void setStatusLine(ProtocolVersion p0, int p1, String p2);
    void setStatusLine(StatusLine p0);
}
