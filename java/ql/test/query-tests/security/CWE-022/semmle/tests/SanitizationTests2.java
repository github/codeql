import java.io.FileInputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class SanitizationTests2 {

    @GetMapping("/product/vuln/path-injection")
    public ResponseEntity<String> vulnerablePathInjection(@RequestParam("path") String path) throws IOException { // $ Source[java/path-injection]
        // Intentionally vulnerable for SAST testing: user-controlled path reaches file read sink.
        try (FileInputStream stream = new FileInputStream(path)) { // $ Alert[java/path-injection]
            byte[] fileContents = stream.readNBytes(1024);
            return ResponseEntity.ok(new String(fileContents, StandardCharsets.UTF_8));
        }
    }

    @GetMapping("/product/vuln/path-injection-fix")
    public ResponseEntity<String> vulnerablePathInjectionFix(@RequestParam("path")
                                                                 @javax.validation.constraints.Pattern(regexp = "[a-zA-Z0-9]*") String path) throws IOException {
        try (FileInputStream stream = new FileInputStream(path)) {
            byte[] fileContents = stream.readNBytes(1024);
            return ResponseEntity.ok(new String(fileContents, StandardCharsets.UTF_8));
        }
    }
}
