import io.micronaut.http.annotation.*;
import io.micronaut.http.multipart.CompletedFileUpload;
import java.io.IOException;

@Controller("/upload")
class MicronautFileUploadTest {

    void sink(Object o) {}

    @Post("/file")
    void testFileUpload(CompletedFileUpload file) throws IOException {
        sink(file.getFilename()); // $hasTaintFlow
        sink(file.getBytes()); // $hasTaintFlow
        sink(file.getInputStream()); // $hasTaintFlow
        sink(file.getContentType()); // $hasTaintFlow
        sink(file.getSize()); // $hasTaintFlow
    }
}
