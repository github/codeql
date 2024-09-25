import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

public class App {

    private HttpServletRequest request;
    private HttpServletResponse response;
    private Part filePart;

    private static void sink(Object o) {}

    public void test() throws Exception {
        sink(filePart.getContentType());  // $hasRemoteValueFlow
        sink(filePart.getHeader("test")); // $hasRemoteValueFlow
        sink(filePart.getInputStream()); // $hasRemoteValueFlow
        sink(filePart.getHeaders("test")); // $hasRemoteValueFlow
        //sink(filePart.getHeaderNames()); // $hasRemoteValueFlow
        sink(filePart.getSubmittedFileName()); // $hasRemoteValueFlow
        sink(filePart.getName()); // $hasRemoteValueFlow
    }
}