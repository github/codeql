import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemStream;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

public class FileUpload {

    private HttpServletRequest request;
    private HttpServletResponse response;
    private javax.servlet.http.Part filePart;
    private FileItem fileItem;
    private FileItemStream fileItemStream;
    private jakarta.servlet.http.Part jakartaPart;
    private ServletFileUpload servletFileUpload;

    private static void sink(Object o) {}

    public void test() throws Exception {
        sink(filePart.getContentType());  // $ hasRemoteValueFlow
        sink(filePart.getHeader("test")); // $ hasRemoteValueFlow
        sink(filePart.getHeaderNames()); // $ hasRemoteValueFlow
        sink(filePart.getHeaders("test")); // $ hasRemoteValueFlow
        sink(filePart.getInputStream()); // $ hasRemoteValueFlow
        sink(filePart.getName()); // $ hasRemoteValueFlow
        sink(filePart.getSubmittedFileName()); // $ hasRemoteValueFlow

        sink(fileItem.get());            // $ hasRemoteValueFlow
        sink(fileItem.getContentType()); // $ hasRemoteValueFlow
        sink(fileItem.getFieldName());        // $ hasRemoteValueFlow
        sink(fileItem.getInputStream());        // $ hasRemoteValueFlow
        sink(fileItem.getName());        // $ hasRemoteValueFlow
        sink(fileItem.getName());        // $ hasRemoteValueFlow
        sink(fileItem.getString());      // $ hasRemoteValueFlow

        sink(fileItemStream.getContentType()); // $ hasRemoteValueFlow
        sink(fileItemStream.getFieldName()); // $ hasRemoteValueFlow
        sink(fileItemStream.getName()); // $ hasRemoteValueFlow
        sink(fileItemStream.openStream()); // $ hasRemoteValueFlow

        sink(jakartaPart.getContentType());  // $ hasRemoteValueFlow
        sink(jakartaPart.getHeader("test")); // $ hasRemoteValueFlow
        sink(jakartaPart.getHeaderNames()); // $ hasRemoteValueFlow
        sink(jakartaPart.getHeaders("test")); // $ hasRemoteValueFlow
        sink(jakartaPart.getInputStream()); // $ hasRemoteValueFlow
        sink(jakartaPart.getName()); // $ hasRemoteValueFlow
        sink(jakartaPart.getSubmittedFileName()); // $ hasRemoteValueFlow

        FileItem item = servletFileUpload.parseRequest(request).get(0);
        sink(item.getName()); // $ hasRemoteValueFlow
    }
}