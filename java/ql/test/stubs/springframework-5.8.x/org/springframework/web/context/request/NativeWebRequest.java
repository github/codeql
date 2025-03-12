// Generated automatically from org.springframework.web.context.request.NativeWebRequest for testing purposes

package org.springframework.web.context.request;

import org.springframework.web.context.request.WebRequest;

public interface NativeWebRequest extends WebRequest
{
    <T> T getNativeRequest(Class<T> p0);
    <T> T getNativeResponse(Class<T> p0);
    Object getNativeRequest();
    Object getNativeResponse();
}
