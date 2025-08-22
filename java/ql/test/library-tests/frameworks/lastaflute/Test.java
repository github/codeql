import java.io.IOException;

import org.lastaflute.web.Execute;
import org.lastaflute.web.ruts.multipart.MultipartFormFile;

public class Test {

    void sink(Object o) {
    }

    public class TestForm {
        public MultipartFormFile file;
    }

    @Execute
    public String index(TestForm form) throws IOException {
        MultipartFormFile file = form.file;

        sink(file.getFileData()); // $hasTaintFlow
        sink(file.getInputStream()); // $hasTaintFlow

        return "index.jsp";
    }

}

    
