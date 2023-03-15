// Generated automatically from org.apache.http.HttpEntityEnclosingRequest for testing purposes

package org.apache.http;

import org.apache.http.HttpEntity;
import org.apache.http.HttpRequest;

public interface HttpEntityEnclosingRequest extends HttpRequest
{
    HttpEntity getEntity();
    boolean expectContinue();
    void setEntity(HttpEntity p0);
}
