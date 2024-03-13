import java.io.File;
import java.net.URI;
import java.nio.file.Path;
import java.nio.file.Paths;
import android.net.Uri;

public class Test {

    Object source() {
        return null;
    }

    void sink(Object o) {}

    private void exactPathMatchGuardValidation(String path) throws Exception {
        if (!path.equals("/safe/path"))
            throw new Exception();
    }

    public void exactPathMatchGuard() throws Exception {
        {
            String source = (String) source();
            if (source.equals("/safe/path"))
                sink(source); // Safe
            else
                sink(source); // $ hasTaintFlow
        }
        {
            String source = (String) source();
            if ("/safe/path".equals(source))
                sink(source); // Safe
            else
                sink(source); // $ hasTaintFlow
        }
        {
            URI source = (URI) source();
            if (source.equals(new URI("http://safe/uri")))
                sink(source); // Safe
            else
                sink(source); // $ hasTaintFlow
        }
        {
            File source = (File) source();
            if (source.equals(new File("/safe/file")))
                sink(source); // Safe
            else
                sink(source); // $ hasTaintFlow
        }
        {
            Uri source = (Uri) source();
            if (source.equals(Uri.parse("http://safe/uri")))
                sink(source); // Safe
            else
                sink(source); // $ hasTaintFlow
        }
        {
            String source = (String) source();
            exactPathMatchGuardValidation(source);
            sink(source); // Safe
        }
    }

    private void allowListGuardValidation(String path) throws Exception {
        if (path.contains("..") || !path.startsWith("/safe"))
            throw new Exception();
    }

    public void allowListGuard() throws Exception {
        // Prefix check by itself is not enough
        {
            String source = (String) source();
            if (source.startsWith("/safe")) {
                sink(source); // $ hasTaintFlow
            } else
                sink(source); // $ hasTaintFlow
        }
        // PathTraversalGuard + allowListGuard
        {
            String source = (String) source();
            if (!source.contains("..") && source.startsWith("/safe"))
                sink(source); // Safe
            else
                sink(source); // $ hasTaintFlow
        }
        {
            String source = (String) source();
            if (source.indexOf("..") == -1 && source.startsWith("/safe"))
                sink(source); // Safe
            else
                sink(source); // $ hasTaintFlow
        }
        {
            String source = (String) source();
            if (source.lastIndexOf("..") == -1 && source.startsWith("/safe"))
                sink(source); // Safe
            else
                sink(source); // $ hasTaintFlow
        }
        // PathTraversalSanitizer + allowListGuard
        {
            File source = (File) source();
            String normalized = source.getCanonicalPath();
            if (normalized.startsWith("/safe")) {
                sink(source); // Safe
                sink(normalized); // Safe
            } else {
                sink(source); // $ hasTaintFlow
                sink(normalized); // $ hasTaintFlow
            }
        }
        {
            File source = (File) source();
            String normalized = source.getCanonicalFile().toString();
            if (normalized.startsWith("/safe")) {
                sink(source); // Safe
                sink(normalized); // Safe
            } else {
                sink(source); // $ hasTaintFlow
                sink(normalized); // $ hasTaintFlow
            }
        }
        {
            String source = (String) source();
            Path normalized = Paths.get(source).normalize();
            if (normalized.startsWith("/safe")) {
                sink(source); // Safe
                sink(normalized); // Safe
            } else {
                sink(source); // $ hasTaintFlow
                sink(normalized); // $ hasTaintFlow
            }
        }
        {
            String source = (String) source();
            String normalized = Paths.get(source).normalize().toString();
            if (normalized.startsWith("/safe")) {
                sink(source); // Safe
                sink(normalized); // Safe
            } else {
                sink(source); // $ hasTaintFlow
                sink(normalized); // $ hasTaintFlow
            }
        }
        {
            String source = (String) source();
            String normalized = Paths.get(source).normalize().toString();
            if (normalized.regionMatches(0, "/safe", 0, 5)) {
                sink(source); // Safe
                sink(normalized); // Safe
            } else {
                sink(source); // $ hasTaintFlow
                sink(normalized); // $ hasTaintFlow
            }
        }
        {
            String source = (String) source();
            String normalized = Paths.get(source).normalize().toString();
            if (normalized.matches("/safe/.*")) {
                sink(source); // Safe
                sink(normalized); // Safe
            } else {
                sink(source); // $ hasTaintFlow
                sink(normalized); // $ hasTaintFlow
            }
        }
        // validation method
        {
            String source = (String) source();
            allowListGuardValidation(source);
            sink(source); // Safe
        }
        // PathInjectionSanitizer + partial string match is considered unsafe
        {
            String source = (String) source();
            String normalized = Paths.get(source).normalize().toString();
            if (normalized.contains("/safe")) {
                sink(source); // $ hasTaintFlow
                sink(normalized); // $ hasTaintFlow
            } else {
                sink(source); // $ hasTaintFlow
                sink(normalized); // $ hasTaintFlow
            }
        }
        {
            String source = (String) source();
            String normalized = Paths.get(source).normalize().toString();
            if (normalized.regionMatches(1, "/safe", 0, 5)) {
                sink(source); // $ hasTaintFlow
                sink(normalized); // $ hasTaintFlow
            } else {
                sink(source); // $ hasTaintFlow
                sink(normalized); // $ hasTaintFlow
            }
        }
        {
            String source = (String) source();
            String normalized = Paths.get(source).normalize().toString();
            if (normalized.matches(".*/safe/.*")) {
                sink(source); // $ hasTaintFlow
                sink(normalized); // $ hasTaintFlow
            } else {
                sink(source); // $ hasTaintFlow
                sink(normalized); // $ hasTaintFlow
            }
        }
    }

    private void dotDotCheckGuardValidation(String path) throws Exception {
        if (!path.startsWith("/safe") || path.contains(".."))
            throw new Exception();
    }

    public void dotDotCheckGuard() throws Exception {
        // dot dot check by itself is not enough
        {
            String source = (String) source();
            if (!source.contains("..")) {
                sink(source); // $ hasTaintFlow
            } else
                sink(source); // $ hasTaintFlow
        }
        // allowListGuard + dotDotCheckGuard
        {
            String source = (String) source();
            if (source.startsWith("/safe") && !source.contains(".."))
                sink(source); // Safe
            else
                sink(source); // $ hasTaintFlow
        }
        {
            String source = (String) source();
            if (source.startsWith("/safe") && source.indexOf("..") == -1)
                sink(source); // Safe
            else
                sink(source); // $ hasTaintFlow
        }
        {
            String source = (String) source();
            if (!source.startsWith("/safe") || source.indexOf("..") != -1)
                sink(source); // $ hasTaintFlow
            else
                sink(source); // Safe
        }
        {
            String source = (String) source();
            if (source.startsWith("/safe") && source.lastIndexOf("..") == -1)
                sink(source); // Safe
            else
                sink(source); // $ hasTaintFlow
        }
        // blockListGuard + dotDotCheckGuard
        {
            String source = (String) source();
            if (!source.startsWith("/data") && !source.contains(".."))
                sink(source); // Safe
            else
                sink(source); // $ hasTaintFlow
        }
        {
            String source = (String) source();
            if (!source.startsWith("/data") && source.indexOf("..") == -1)
                sink(source); // Safe
            else
                sink(source); // $ hasTaintFlow
        }
        {
            String source = (String) source();
            if (source.startsWith("/data") || source.indexOf("..") != -1)
                sink(source); // $ hasTaintFlow
            else
                sink(source); // Safe
        }
        {
            String source = (String) source();
            if (!source.startsWith("/data") && source.lastIndexOf("..") == -1)
                sink(source); // Safe
            else
                sink(source); // $ hasTaintFlow
        }
        // validation method
        {
            String source = (String) source();
            dotDotCheckGuardValidation(source);
            sink(source); // Safe
        }
    }

    private void blockListGuardValidation(String path) throws Exception {
        if (path.contains("..") || path.startsWith("/data"))
            throw new Exception();
    }

    public void blockListGuard() throws Exception {
        // Prefix check by itself is not enough
        {
            String source = (String) source();
            if (!source.startsWith("/data")) {
                sink(source); // $ hasTaintFlow
            } else
                sink(source); // $ hasTaintFlow
        }
        // PathTraversalGuard + blockListGuard
        {
            String source = (String) source();
            if (!source.contains("..") && !source.startsWith("/data"))
                sink(source); // Safe
            else
                sink(source); // $ hasTaintFlow
        }
        {
            String source = (String) source();
            if (source.indexOf("..") == -1 && !source.startsWith("/data"))
                sink(source); // Safe
            else
                sink(source); // $ hasTaintFlow
        }
        {
            String source = (String) source();
            if (source.lastIndexOf("..") == -1 && !source.startsWith("/data"))
                sink(source); // Safe
            else
                sink(source); // $ hasTaintFlow
        }
        // PathTraversalSanitizer + blockListGuard
        {
            File source = (File) source();
            String normalized = source.getCanonicalPath();
            if (!normalized.startsWith("/data")) {
                sink(source); // Safe
                sink(normalized); // Safe
            } else {
                sink(source); // $ hasTaintFlow
                sink(normalized); // $ hasTaintFlow
            }
        }
        {
            File source = (File) source();
            String normalized = source.getCanonicalFile().toString();
            if (!normalized.startsWith("/data")) {
                sink(source); // Safe
                sink(normalized); // Safe
            } else {
                sink(source); // $ hasTaintFlow
                sink(normalized); // $ hasTaintFlow
            }
        }
        {
            String source = (String) source();
            Path normalized = Paths.get(source).normalize();
            if (!normalized.startsWith("/data")) {
                sink(source); // Safe
                sink(normalized); // Safe
            } else {
                sink(source); // $ hasTaintFlow
                sink(normalized); // $ hasTaintFlow
            }
        }
        {
            String source = (String) source();
            String normalized = Paths.get(source).normalize().toString();
            if (!normalized.startsWith("/data")) {
                sink(source); // Safe
                sink(normalized); // Safe
            } else {
                sink(source); // $ hasTaintFlow
                sink(normalized); // $ hasTaintFlow
            }
        }
        {
            String source = (String) source();
            String normalized = Paths.get(source).normalize().toString();
            if (!normalized.regionMatches(0, "/data", 0, 5)) {
                sink(source); // Safe
                sink(normalized); // Safe
            } else {
                sink(source); // $ hasTaintFlow
                sink(normalized); // $ hasTaintFlow
            }
        }
        {
            String source = (String) source();
            String normalized = Paths.get(source).normalize().toString();
            if (!normalized.matches("/data/.*")) {
                sink(source); // Safe
                sink(normalized); // Safe
            } else {
                sink(source); // $ hasTaintFlow
                sink(normalized); // $ hasTaintFlow
            }
        }
        // validation method
        {
            String source = (String) source();
            blockListGuardValidation(source);
            sink(source); // Safe
        }
        // PathInjectionSanitizer + partial string match with disallowed words
        {
            String source = (String) source();
            String normalized = Paths.get(source).normalize().toString();
            if (!normalized.contains("/")) {
                sink(source); // Safe
                sink(normalized); // Safe
            } else {
                sink(source); // $ hasTaintFlow
                sink(normalized); // $ hasTaintFlow
            }
        }
        {
            String source = (String) source();
            String normalized = Paths.get(source).normalize().toString();
            if (!normalized.regionMatches(1, "/", 0, 5)) {
                sink(source); // Safe
                sink(normalized); // Safe
            } else {
                sink(source); // $ hasTaintFlow
                sink(normalized); // $ hasTaintFlow
            }
        }
        {
            String source = (String) source();
            String normalized = Paths.get(source).normalize().toString();
            if (!normalized.matches("/")) {
                sink(source); // Safe
                sink(normalized); // Safe
            } else {
                sink(source); // $ hasTaintFlow
                sink(normalized); // $ hasTaintFlow
            }
        }
        // PathInjectionSanitizer + partial string match with disallowed prefixes
        {
            String source = (String) source();
            String normalized = Paths.get(source).normalize().toString();
            if (!normalized.contains("/data")) {
                sink(source); // Safe
                sink(normalized); // Safe
            } else {
                sink(source); // $ hasTaintFlow
                sink(normalized); // $ hasTaintFlow
            }
        }
        {
            String source = (String) source();
            String normalized = Paths.get(source).normalize().toString();
            if (!normalized.regionMatches(1, "/data", 0, 5)) {
                sink(source); // Safe
                sink(normalized); // Safe
            } else {
                sink(source); // $ hasTaintFlow
                sink(normalized); // $ hasTaintFlow
            }
        }
        {
            String source = (String) source();
            String normalized = Paths.get(source).normalize().toString();
            if (!normalized.matches(".*/data/.*")) {
                sink(source); // Safe
                sink(normalized); // Safe
            } else {
                sink(source); // $ hasTaintFlow
                sink(normalized); // $ hasTaintFlow
            }
        }
    }
}
