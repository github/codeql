import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemStream;

public class FileUpload {

    private HttpServletRequest request;
    private HttpServletResponse response;
    private Part filePart;
    private FileItem fileItem;
    private FileItemStream fileItemStream;

    private static void sink(Object o) {}

    public void test() throws Exception {
        sink(filePart.getContentType());  // $ hasRemoteValueFlow
        sink(filePart.getHeader("test")); // $ hasRemoteValueFlow
        sink(filePart.getInputStream()); // $ hasRemoteValueFlow
        sink(filePart.getHeaders("test")); // $ hasRemoteValueFlow
        sink(filePart.getHeaderNames()); // $ hasRemoteValueFlow
        sink(filePart.getSubmittedFileName()); // $ hasRemoteValueFlow
        sink(filePart.getName()); // $ hasRemoteValueFlow

        sink(fileItem.getName());        // $ hasRemoteValueFlow
        sink(fileItem.get());            // $ hasRemoteValueFlow
        sink(fileItem.getString());      // $ hasRemoteValueFlow
        sink(fileItem.getContentType()); // $ hasRemoteValueFlow
        sink(fileItem.getName());        // $ hasRemoteValueFlow

        //These result in a compiler error when uncommented
        //sink(fileItemStream) // $ hasRemoteValueFlow
        //sink(fileItemStream.getFieldName()) // $ hasRemoteValueFlow
        //sink(fileItemStream.getName()) // $ hasRemoteValueFlow
        //sink(fileItemStream.openStream()) // $ hasRemoteValueFlow

    }
}