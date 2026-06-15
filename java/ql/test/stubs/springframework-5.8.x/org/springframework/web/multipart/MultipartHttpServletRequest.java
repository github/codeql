// Generated automatically from org.springframework.web.multipart.MultipartHttpServletRequest for testing purposes

package org.springframework.web.multipart;

import javax.servlet.http.HttpServletRequest;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.web.multipart.MultipartRequest;

public interface MultipartHttpServletRequest extends HttpServletRequest, MultipartRequest
{
    HttpHeaders getMultipartHeaders(String p0);
    HttpHeaders getRequestHeaders();
    HttpMethod getRequestMethod();
}
