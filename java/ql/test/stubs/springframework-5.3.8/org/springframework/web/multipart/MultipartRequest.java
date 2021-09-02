// Generated automatically from org.springframework.web.multipart.MultipartRequest for testing purposes

package org.springframework.web.multipart;

import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.springframework.util.MultiValueMap;
import org.springframework.web.multipart.MultipartFile;

public interface MultipartRequest
{
    Iterator<String> getFileNames();
    List<MultipartFile> getFiles(String p0);
    Map<String, MultipartFile> getFileMap();
    MultiValueMap<String, MultipartFile> getMultiFileMap();
    MultipartFile getFile(String p0);
    String getMultipartContentType(String p0);
}
