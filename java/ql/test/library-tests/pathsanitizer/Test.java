import java.io.File;
import java.net.URI;
import java.nio.file.FileSystems;
import java.nio.file.Path;
import java.nio.file.Paths;
import android.net.Uri;
import com.google.common.base.CharMatcher;
import org.apache.commons.lang3.StringUtils;

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

    private void allowListUnrelatedValidation(String other, String path) throws Exception {
        if (other.contains("..") || !path.startsWith("/safe"))
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
        {
            String source = (String) source();
            String other = (String) source();
            allowListUnrelatedValidation(other, source);
            sink(source); // $ hasTaintFlow
        }
        // Unrelated `..` guard does not sanitize
        {
            String source = (String) source();
            String other = (String) source();
            if (!other.contains("..") && source.startsWith("/safe"))
                sink(source); // $ hasTaintFlow
            else
                sink(source); // $ hasTaintFlow
        }
        {
            // Lossy `File.getName()` does not link `baseName` back to precomputed `resolved`
            // (note: `sink(source)` is still sanitized because `localTaintFlowToPathGuard` allows taint steps).
            String source = (String) source();
            String baseName = new File(source).getName();
            Path resolved = Paths.get("/safe/sub").resolve(source);
            if (!baseName.contains("..") && resolved.startsWith("/safe"))
                sink(resolved); // $ hasTaintFlow
        }
        // Derived values across both guards
        {
            String source = (String) source();
            Path resolved = Paths.get("/safe").resolve(source);
            if (!source.contains("..") && resolved.startsWith("/safe")) {
                sink(source); // Safe
                sink(resolved); // Safe
            } else {
                sink(source); // $ hasTaintFlow
                sink(resolved); // $ hasTaintFlow
            }
        }
        {
            Path source = (Path) source();
            Path resolved = Paths.get("/safe").resolve(source);
            if (!source.toString().contains("..") && resolved.startsWith("/safe")) {
                sink(source); // Safe
                sink(resolved); // Safe
            } else {
                sink(source); // $ hasTaintFlow
                sink(resolved); // $ hasTaintFlow
            }
        }
        {
            File source = (File) source();
            String str = source.getPath();
            Path resolved = Paths.get("/safe").resolve(source.toPath());
            if (!str.contains("..") && resolved.startsWith("/safe")) {
                sink(source); // Safe
                sink(resolved); // Safe
            } else {
                sink(source); // $ hasTaintFlow
                sink(resolved); // $ hasTaintFlow
            }
        }
        {
            File source = (File) source();
            String absPath = source.getAbsoluteFile().getAbsolutePath();
            Path resolved = Paths.get("/safe").resolve(source.toPath());
            if (!absPath.contains("..") && resolved.startsWith("/safe")) {
                sink(source); // Safe
                sink(resolved); // Safe
            } else {
                sink(source); // $ hasTaintFlow
                sink(resolved); // $ hasTaintFlow
            }
        }
        {
            File dir = new File("/safe");
            String name = (String) source();
            File file = new File(dir, name);
            if (!name.contains("..") && file.toPath().startsWith(dir.toPath())) {
                sink(file); // Safe
                sink(name); // $ hasTaintFlow
            } else {
                sink(file); // $ hasTaintFlow
                sink(name); // $ hasTaintFlow
            }
        }
        {
            String source = (String) source();
            if (!source.contains("..")) {
                Path resolved = Paths.get("/safe").resolve(source);
                if (resolved.startsWith("/safe")) {
                    sink(source); // Safe
                    sink(resolved); // Safe
                } else {
                    sink(source); // $ hasTaintFlow
                    sink(resolved); // $ hasTaintFlow
                }
            }
        }
        {
            Path source = (Path) source();
            if (!source.toString().contains("..") && source.startsWith("/safe"))
                sink(source); // Safe
            else
                sink(source); // $ hasTaintFlow
        }
        {
            Object raw = source();
            if (!((String) raw).contains("..")) {
                Path resolved = Paths.get("/safe").resolve((String) raw);
                if (resolved.startsWith("/safe"))
                    sink(resolved); // Safe
                else
                    sink(resolved); // $ hasTaintFlow
            }
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

    private void dotDotUnrelatedValidation(String route, String path) throws Exception {
        // Use `indexOf` instead of `contains` because `ValidatedVariableAccess`
        // treats any `void` helper calling `String.contains` on a parameter as a validator.
        if (!route.startsWith("/safe") || path.indexOf("..") != -1)
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
            if (source.startsWith("/safe") && !StringUtils.contains(source, ".."))
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
        {
            String source = (String) source();
            String route = (String) source();
            dotDotUnrelatedValidation(route, source);
            sink(source); // $ hasTaintFlow
        }
        // Unrelated prefix or blocklist guard does not sanitize
        {
            String source = (String) source();
            String route = (String) source();
            if (route.startsWith("/safe") && !source.contains(".."))
                sink(source); // $ hasTaintFlow
            else
                sink(source); // $ hasTaintFlow
        }
        {
            String source = (String) source();
            String other = (String) source();
            if (!other.startsWith("/data") && !source.contains(".."))
                sink(source); // $ hasTaintFlow
            else
                sink(source); // $ hasTaintFlow
        }
        {
            String s = (String) source();
            if (s.startsWith("/safe")) {
                s = (String) source();
                if (!s.contains(".."))
                    sink(s); // $ hasTaintFlow
            }
        }
        // Derived values across both guards
        {
            String source = (String) source();
            String trimmed = source.trim();
            if (source.startsWith("/safe") && !trimmed.contains("..")) {
                sink(source); // Safe
                sink(trimmed); // Safe
            } else {
                sink(source); // $ hasTaintFlow
                sink(trimmed); // $ hasTaintFlow
            }
        }
        {
            String source = (String) source();
            if (source.startsWith("/safe")) {
                String trimmed = source.trim();
                if (!trimmed.contains("..")) {
                    sink(source); // Safe
                    sink(trimmed); // Safe
                } else {
                    sink(source); // $ hasTaintFlow
                    sink(trimmed); // $ hasTaintFlow
                }
            }
        }
        {
            Object raw = source();
            if (!((String) raw).contains("/data")) {
                String trimmed = ((String) raw).trim();
                if (!trimmed.contains(".."))
                    sink(trimmed); // Safe
                else
                    sink(trimmed); // $ hasTaintFlow
            }
        }
        {
            String source = (String) source();
            String target = source + "/file";
            if (Paths.get(source).startsWith("/safe") && !target.contains("..")) {
                sink(source); // Safe
                sink(target); // Safe
            } else {
                sink(source); // $ hasTaintFlow
                sink(target); // $ hasTaintFlow
            }
        }
        {
            Path source = (Path) source();
            String str = source.toString();
            if (source.toString().startsWith("/safe") && !str.contains("..")) {
                sink(source); // Safe
                sink(str); // Safe
            } else {
                sink(source); // $ hasTaintFlow
                sink(str); // $ hasTaintFlow
            }
        }
        {
            String source = (String) source();
            Path checked = FileSystems.getDefault().getPath(source);
            String target = source + "/file";
            if (checked.startsWith("/safe") && !target.contains("..")) {
                sink(source); // Safe
                sink(target); // Safe
            } else {
                sink(source); // $ hasTaintFlow
                sink(target); // $ hasTaintFlow
            }
        }
        {
            String source = (String) source();
            Path checked = FileSystems.getDefault().getPath(source, "/safe");
            String target = source + "/etc";
            if (checked.startsWith("/safe") && !target.contains("..")) {
                sink(target); // $ hasTaintFlow
            }
        }
        {
            Path source = (Path) source();
            Path abs = source.toAbsolutePath();
            Path target = source.resolve("file");
            if (abs.startsWith("/safe") && !target.toString().contains("..")) {
                sink(source); // Safe
                sink(target); // Safe
            } else {
                sink(source); // $ hasTaintFlow
                sink(target); // $ hasTaintFlow
            }
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
        // Unrelated `..` guard does not sanitize
        {
            String source = (String) source();
            String other = (String) source();
            if (!other.contains("..") && !source.startsWith("/data"))
                sink(source); // $ hasTaintFlow
            else
                sink(source); // $ hasTaintFlow
        }
        // Derived values across both guards
        {
            String source = (String) source();
            Path resolved = Paths.get("/dir").resolve(source);
            if (!source.contains("..") && !resolved.startsWith("/data")) {
                sink(source); // Safe
                sink(resolved); // Safe
            } else {
                sink(source); // $ hasTaintFlow
                sink(resolved); // $ hasTaintFlow
            }
        }
        {
            String source = (String) source();
            if (!source.contains("..")) {
                Path resolved = Paths.get("/dir").resolve(source);
                if (!resolved.startsWith("/data")) {
                    sink(source); // Safe
                    sink(resolved); // Safe
                } else {
                    sink(source); // $ hasTaintFlow
                    sink(resolved); // $ hasTaintFlow
                }
            }
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
            if (!StringUtils.contains(normalized, "/data")) {
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

    private void fileConstructorValidation(String path) throws Exception {
        // Use `indexOf` instead of `contains` for this test since a `contains`
        // call in this scenario will already be sanitized due to the inclusion
        // of `ValidatedVariableAccess` nodes in `defaultTaintSanitizer`.
        if (path.indexOf("..") != -1)
            throw new Exception();
    }

    public void fileConstructorSanitizer() throws Exception {
        // PathTraversalGuard
        {
            String source = (String) source();
            File f1 = new File("safe/file.txt");
            if (!source.contains("..")) {
                File f2 = new File(f1, source);
                sink(f2); // Safe
                sink(source); // $ hasTaintFlow
            } else {
                File f3 = new File(f1, source);
                sink(f3); // $ hasTaintFlow
                sink(source); // $ hasTaintFlow
            }
        }
        {
            String source = (String) source();
            File f1Tainted = (File) source();
            if (!source.contains("..")) {
                // `f2` is unsafe if `f1` is tainted
                File f2 = new File(f1Tainted, source);
                sink(f2); // $ hasTaintFlow
                sink(source); // $ hasTaintFlow
            } else {
                File f3 = new File(f1Tainted, source);
                sink(f3); // $ hasTaintFlow
                sink(source); // $ hasTaintFlow
            }
        }
        {
            String source = (String) source();
            File f1Null = null;
            if (!source.contains("..")) {
                // `f2` is unsafe if `f1` is null
                File f2 = new File(f1Null, source);
                sink(f2); // $ hasTaintFlow
                sink(source); // $ hasTaintFlow
            } else {
                File f3 = new File(f1Null, source);
                sink(f3); // $ hasTaintFlow
                sink(source); // $ hasTaintFlow
            }
        }
        {
            String source = (String) source();
            File f1 = new File("safe/file.txt");
            if (source.indexOf("..") == -1) {
                File f2 = new File(f1, source);
                sink(f2); // Safe
                sink(source); // $ hasTaintFlow
            } else {
                File f3 = new File(f1, source);
                sink(f3); // $ hasTaintFlow
                sink(source); // $ hasTaintFlow
            }
        }
        {
            String source = (String) source();
            File f1 = new File("safe/file.txt");
            if (source.indexOf("..") != -1) {
                File f2 = new File(f1, source);
                sink(f2); // $ hasTaintFlow
                sink(source); // $ hasTaintFlow
            } else {
                File f3 = new File(f1, source);
                sink(f3); // Safe
                sink(source); // $ hasTaintFlow
            }
        }
        {
            String source = (String) source();
            File f1 = new File("safe/file.txt");
            if (source.lastIndexOf("..") == -1) {
                File f2 = new File(f1, source);
                sink(f2); // Safe
                sink(source); // $ hasTaintFlow
            } else {
                File f3 = new File(f1, source);
                sink(f3); // $ hasTaintFlow
                sink(source); // $ hasTaintFlow
            }
        }
        // validation method
        {
            String source = (String) source();
            File f1 = new File("safe/file.txt");
            fileConstructorValidation(source);
            File f2 = new File(f1, source);
            sink(f2); // Safe
            sink(source); // $ hasTaintFlow
        }
        {
            String source = (String) source();
            File f1 = new File("safe/file.txt");

            if (source.contains("..")) {
                throw new Exception();
            } else {
                File f2 = new File(f1, source);
                sink(f2); // Safe
                sink(source); // $ hasTaintFlow
            }
        }
        // PathNormalizeSanitizer
        {
            File source = (File) source();
            String normalized = source.getCanonicalPath();
            File f1 = new File("safe/file.txt");
            File f2 = new File(f1, normalized);
            sink(f2); // Safe
            sink(source); // $ hasTaintFlow
            sink(normalized); // $ hasTaintFlow
        }
        {
            File source = (File) source();
            String normalized = source.getCanonicalFile().toString();
            File f1 = new File("safe/file.txt");
            File f2 = new File(f1, normalized);
            sink(f2); // Safe
            sink(source); // $ hasTaintFlow
            sink(normalized); // $ hasTaintFlow
        }
        {
            String source = (String) source();
            String normalized = Paths.get(source).normalize().toString();
            File f1 = new File("safe/file.txt");
            File f2 = new File(f1, normalized);
            sink(f2); // Safe
            sink(source); // $ hasTaintFlow
            sink(normalized); // $ hasTaintFlow
        }
    }

    private void directoryCharsValidation(String path) throws Exception {
        if (!path.matches("[0-9a-fA-F]{20,}")) {
            throw new Exception();
        }
    }

    public void directoryCharsSanitizer() throws Exception {
        // DirectoryCharactersGuard
        // Ensures that directory characters (/, \ and ..) cannot possibly be in the payload
        // branch = true
        {
            String source = (String) source();
            if (source.matches("[0-9a-fA-F]{20,}")) {
                sink(source); // Safe
            } else {
                sink(source); // $ hasTaintFlow
            }
        }
        {
            String source = (String) source();
            if (source.matches("[0-9a-fA-F]*")) {
                sink(source); // Safe
            } else {
                sink(source); // $ hasTaintFlow
            }
        }
        {
            String source = (String) source();
            if (source.matches("[0-9a-fA-F]+")) {
                sink(source); // Safe
            } else {
                sink(source); // $ hasTaintFlow
            }
        }
        {
            String source = (String) source();
            if (source.matches("[0-9a-fA-F\\.]+")) {
                sink(source); // $ hasTaintFlow
            } else {
                sink(source); // $ hasTaintFlow
            }
        }
        {
            String source = (String) source();
            if (source.matches("[0-9a-fA-F/]+")) {
                sink(source); // $ hasTaintFlow
            } else {
                sink(source); // $ hasTaintFlow
            }
        }
        {
            String source = (String) source();
            if (source.matches("[0-9a-fA-F\\\\]+")) {
                sink(source); // $ hasTaintFlow
            } else {
                sink(source); // $ hasTaintFlow
            }
        }
        {
            String source = (String) source();
            // exclude '.', '/', '\'
            if (source.matches("[^0-9./\\\\a-f]+")) {
                sink(source); // Safe
            } else {
                sink(source); // $ hasTaintFlow
            }
        }
        {
            String source = (String) source();
            // '/' is not excluded
            if (source.matches("[^0-9.\\\\a-f]+")) {
                sink(source); // $ hasTaintFlow
            } else {
                sink(source); // $ hasTaintFlow
            }
        }
        // branch = false
        {
            String source = (String) source();
            if (source.matches(".*[\\./\\\\].*")) {
                sink(source); // $ hasTaintFlow
            } else {
                sink(source); // Safe
            }
        }
        {
            String source = (String) source();
            if (source.matches(".+[\\./\\\\].+")) {
                sink(source); // $ hasTaintFlow
            } else {
                sink(source); // Safe
            }
        }
        {
            String source = (String) source();
            // does not match whole string
            if (source.matches("[\\./\\\\]+")) {
                sink(source); // $ hasTaintFlow
            } else {
                sink(source); // $ hasTaintFlow
            }
        }
        {
            String source = (String) source();
            // not a complete sanitizer since it doesn't protect against absolute path injection
            if (source.matches(".+[\\.].+")) {
                sink(source); // $ hasTaintFlow
            } else {
                sink(source); // $ hasTaintFlow
            }
        }
        // validation method
        {
            String source = (String) source();
            directoryCharsValidation(source);
            sink(source); // Safe
        }

        // ReplaceDirectoryCharactersSanitizer
        // Removes ".." sequences and path separators from the payload
        // single `replaceAll` call
        {
            String source = (String) source();
            source = source.replaceAll("\\.\\.|[/\\\\]", "");
            sink(source); // Safe
        }
        {
            String source = (String) source();
            source = source.replaceAll("\\.|[/\\\\]", "-");
            sink(source); // Safe
        }
        {
            String source = (String) source();
            source = source.replaceAll("[.][.]|[/\\\\]", "_");
            sink(source); // Safe
        }
        {
            String source = (String) source();
            // test a not-accepted replacement character
            source = source.replaceAll("[.][.]|[/\\\\]", "/");
            sink(source); // $ hasTaintFlow
        }
        {
            String source = (String) source();
            source = source.replaceAll(".|[/\\\\]", "");
            sink(source); // $ hasTaintFlow
        }
        {
            String source = (String) source();
            source = source.replaceAll("\\.|/|\\\\", "");
            sink(source); // Safe
        }
        {
            String source = (String) source();
            source = source.replaceAll("[\\./\\\\]", "");
            sink(source); // Safe
        }
        {
            String source = (String) source();
            source = source.replaceAll("[\\.\\\\]", "");
            sink(source); // $ hasTaintFlow
        }
        {
            String source = (String) source();
            source = source.replaceAll("[^\\.\\\\/]", "");
            sink(source); // $ hasTaintFlow
        }
        {
            String source = (String) source();
            // Bypassable with ".../...//"
            source = source.replaceAll("\\.\\./", "");
            sink(source); // $ hasTaintFlow
        }
        // multiple `replaceAll` or `replace` calls
        {
            String source = (String) source();
            source = source.replaceAll("\\.", "").replaceAll("/", "");
            sink(source); // Safe
        }
        {
            String source = (String) source();
            // test a not-accepted replacement character in each call
            source = source.replaceAll("\\.", "/").replaceAll("/", ".");
            sink(source); // $ hasTaintFlow
        }
        {
            String source = (String) source();
            // test a not-accepted replacement character in first call
            source = source.replaceAll("\\.", "/").replaceAll("/", "-");
            sink(source); // $ hasTaintFlow
        }
        {
            String source = (String) source();
            // test a not-accepted replacement character in second call
            source = source.replaceAll("\\.", "_").replaceAll("/", ".");
            sink(source); // $ hasTaintFlow
        }
        {
            String source = (String) source();
            source = source.replaceAll("\\.", "").replaceAll("/", "").replaceAll("\\\\", "");
            sink(source); // Safe
        }
        {
            String source = (String) source();
            // '/' or '\' are not replaced
            source = source.replaceAll("\\.", "").replaceAll("\\.", "");
            sink(source); // $ hasTaintFlow
        }
        {
            String source = (String) source();
            // '.' is not replaced
            source = source.replaceAll("/", "").replaceAll("\\\\", "");
            sink(source); // $ hasTaintFlow
        }
        {
            String source = (String) source();
            // Bypassable with ".....///"
            source = source.replaceAll("\\.\\./", "").replaceAll("\\./", "");
            sink(source); // $ hasTaintFlow
        }
        {
            String source = (String) source();
            source = source.replace(".", "").replace("/", "");
            sink(source); // Safe
        }
        {
            String source = (String) source();
            source = source.replace('.', '_').replace('/', '_');
            sink(source); // Safe
        }
        {
            String source = (String) source();
            source = source.replace(".", "").replace("/", "").replace("\\", "");
            sink(source); // Safe
        }
        {
            String source = (String) source();
            // '/' or '\' are not replaced
            source = source.replace(".", "").replace(".", "");
            sink(source); // $ hasTaintFlow
        }
        {
            String source = (String) source();
            // '.' is not replaced
            source = source.replace("/", "").replace("\\", "");
            sink(source); // $ hasTaintFlow
        }
        {
            String source = (String) source();
            // Bypassable with ".....///"
            source = source.replace("../", "").replace("./", "");
            sink(source); // $ hasTaintFlow
        }
        {
            String source = (String) source();
            // Bypassable with ".../...//"
            source = source.replace("../", "");
            sink(source); // $ hasTaintFlow
        }
        {
            String source = (String) source();
            source = StringUtils.replaceChars(source, "./\\", "_");
            sink(source); // Safe
        }
        {
            String source = (String) source();
            source = CharMatcher.anyOf("./\\").replaceFrom(source, '_');
            sink(source); // Safe
        }
        {
            String source = (String) source();
            source = CharMatcher.anyOf("./\\").removeFrom(source);
            sink(source); // Safe
        }
        {
            String source = (String) source();
            source = CharMatcher.anyOf("/\\").removeFrom(source);
            sink(source); // $ hasTaintFlow
        }
        {
            String source = (String) source();
            if (StringUtils.containsNone(source, "./\\"))
                sink(source); // Safe
            else
                sink(source); // $ hasTaintFlow
        }
        {
            String source = (String) source();
            if (CharMatcher.anyOf("./\\").matchesNoneOf(source))
                sink(source); // Safe
            else
                sink(source); // $ hasTaintFlow
        }
        {
            String source = (String) source();
            if (CharMatcher.anyOf("/\\").matchesNoneOf(source))
                sink(source); // $ hasTaintFlow
            else
                sink(source); // $ hasTaintFlow
        }
    }
}
