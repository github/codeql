// Generated automatically from org.springframework.web.multipart.MultipartResolver for testing purposes

package org.springframework.web.multipart;

import javax.servlet.http.HttpServletRequest;
import org.springframework.web.multipart.MultipartHttpServletRequest;

public interface MultipartResolver
{
    MultipartHttpServletRequest resolveMultipart(HttpServletRequest p0);
    boolean isMultipart(HttpServletRequest p0);
    void cleanupMultipart(MultipartHttpServletRequest p0);
}
