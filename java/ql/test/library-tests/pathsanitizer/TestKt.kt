import java.io.File
import java.net.URI
import java.nio.file.Path
import java.nio.file.Paths
import android.net.Uri

class TestKt {
    fun source(): Any? {
        return null
    }

    fun sink(o: Any?) {}

    @Throws(Exception::class)
    private fun exactPathMatchGuardValidation(path: String?) {
        if (!path.equals("/safe/path")) throw Exception()
    }

    @Throws(Exception::class)
    fun exactPathMatchGuard() {
        run {
            val source = source() as String?
            if (source!!.equals("/safe/path"))
                sink(source) // Safe
            else
                sink(source) // $ hasTaintFlow
        }
        run {
            val source = source() as String?
            if ("/safe/path".equals(source))
                sink(source) // Safe
            else
                sink(source) // $ hasTaintFlow
        }
        run {
            val source = source() as URI?
            if (source!!.equals(URI("http://safe/uri")))
                sink(source) // Safe
            else
                sink(source) // $ hasTaintFlow
        }
        run {
            val source = source() as File?
            if (source!!.equals(File("/safe/file")))
                sink(source) // Safe
            else
                sink(source) // $ hasTaintFlow
        }
        run {
            val source = source() as Uri?
            if (source!!.equals(Uri.parse("http://safe/uri")))
                sink(source) // Safe
            else
                sink(source) // $ hasTaintFlow
        }
        run {
            val source = source() as String?
            exactPathMatchGuardValidation(source)
            sink(source) // Safe
        }
    }

    @Throws(Exception::class)
    private fun allowListGuardValidation(path: String?) {
        if (path!!.contains("..") || !path.startsWith("/safe")) throw Exception()
    }

    @Throws(Exception::class)
    fun allowListGuard() {
        // Prefix check by itself is not enough
        run {
            val source = source() as String?
            if (source!!.startsWith("/safe")) {
                sink(source) // $ hasTaintFlow
            } else
                sink(source) // $ hasTaintFlow
        }
        // PathTraversalGuard + allowListGuard
        run {
            val source = source() as String?
            if (!source!!.contains("..") && source.startsWith("/safe"))
                sink(source) // Safe
            else
                sink(source) // $ hasTaintFlow
        }
        run {
            val source = source() as String?
            if (source!!.indexOf("..") == -1 && source.startsWith("/safe"))
                sink(source) // Safe
            else
                sink(source) // $ hasTaintFlow
        }
        run {
            val source = source() as String?
            if (source!!.lastIndexOf("..") == -1 && source.startsWith("/safe"))
                sink(source) // Safe
            else
                sink(source) // $ hasTaintFlow
        }
        // PathTraversalSanitizer + allowListGuard
        run {
            val source: File? = source() as File?
            val normalized: String = source!!.canonicalPath
            if (normalized.startsWith("/safe")) {
                sink(source) // Safe
                sink(normalized) // Safe
            } else {
                sink(source) // $ hasTaintFlow
                sink(normalized) // $ hasTaintFlow
            }
        }
        run {
            val source: File? = source() as File?
            val normalized: File = source!!.canonicalFile
            if (normalized.startsWith("/safe")) {
                sink(source) // Safe
                sink(normalized) // Safe
            } else {
                sink(source) // $ hasTaintFlow
                sink(normalized) // $ hasTaintFlow
            }
        }
        run {
            val source: File? = source() as File?
            val normalized: String = source!!.canonicalFile.toString()
            if (normalized.startsWith("/safe")) {
                sink(source) // Safe
                sink(normalized) // Safe
            } else {
                sink(source) // $ hasTaintFlow
                sink(normalized) // $ hasTaintFlow
            }
        }
        run {
            val source = source() as String?
            val normalized: Path = Paths.get(source).normalize()
            if (normalized.startsWith("/safe")) {
                sink(source) // Safe
                sink(normalized) // Safe
            } else {
                sink(source) // $ hasTaintFlow
                sink(normalized) // $ hasTaintFlow
            }
        }
        run {
            val source = source() as String?
            // normalize().toString() gets extracted as Object.toString, stopping taint here
            val normalized: String = Paths.get(source).normalize().toString()
            if (normalized.startsWith("/safe")) {
                sink(source) // $ SPURIOUS: hasTaintFlow
                sink(normalized) // Safe
            } else {
                sink(source) // $ hasTaintFlow
                sink(normalized) // $ MISSING: hasTaintFlow
            }
        }
        run {
            val source = source() as String?
            // normalize().toString() gets extracted as Object.toString, stopping taint here
            val normalized: String = Paths.get(source).normalize().toString()
            if (normalized.regionMatches(0, "/safe", 0, 5)) {
                sink(source) // $ SPURIOUS: hasTaintFlow
                sink(normalized) // Safe
            } else {
                sink(source) // $ hasTaintFlow
                sink(normalized) // $ MISSING: hasTaintFlow
            }
        }
        run {
            val source = source() as String?
            // normalize().toString() gets extracted as Object.toString, stopping taint here
            val normalized: String = Paths.get(source).normalize().toString()
            if (normalized.matches("/safe/.*".toRegex())) {
                sink(source) // $ SPURIOUS: hasTaintFlow
                sink(normalized) // Safe
            } else {
                sink(source) // $ hasTaintFlow
                sink(normalized) // $ MISSING: hasTaintFlow
            }
        }
        // validation method
        run {
            val source = source() as String?
            allowListGuardValidation(source)
            sink(source) // Safe
        }
        // PathInjectionSanitizer + partial string match is considered unsafe
        run {
            val source = source() as String?
            // normalize().toString() gets extracted as Object.toString, stopping taint here
            val normalized: String = Paths.get(source).normalize().toString()
            if (normalized.contains("/safe")) {
                sink(source) // $ hasTaintFlow
                sink(normalized) // $ MISSING: hasTaintFlow
            } else {
                sink(source) // $ hasTaintFlow
                sink(normalized) // $ MISSING: hasTaintFlow
            }
        }
        run {
            val source = source() as String?
            // normalize().toString() gets extracted as Object.toString, stopping taint here
            val normalized: String = Paths.get(source).normalize().toString()
            if (normalized.regionMatches(1, "/safe", 0, 5)) {
                sink(source) // $ hasTaintFlow
                sink(normalized) // $ MISSING: hasTaintFlow
            } else {
                sink(source) // $ hasTaintFlow
                sink(normalized) // $ MISSING: hasTaintFlow
            }
        }
        run {
            val source = source() as String?
            // normalize().toString() gets extracted as Object.toString, stopping taint here
            val normalized: String = Paths.get(source).normalize().toString()
            if (normalized.matches(".*/safe/.*".toRegex())) {
                sink(source) // $ hasTaintFlow
                sink(normalized) // $ MISSING: hasTaintFlow
            } else {
                sink(source) // $ hasTaintFlow
                sink(normalized) // $ MISSING: hasTaintFlow
            }
        }
    }

    @Throws(Exception::class)
    private fun dotDotCheckGuardValidation(path: String?) {
        if (!path!!.startsWith("/safe") || path.contains("..")) throw Exception()
    }

    @Throws(Exception::class)
    fun dotDotCheckGuard() {
        // dot dot check by itself is not enough
        run {
            val source = source() as String?
            if (!source!!.contains("..")) {
                sink(source) // $ hasTaintFlow
            } else
                sink(source) // $ hasTaintFlow
        }
        // allowListGuard + dotDotCheckGuard
        run {
            val source = source() as String?
            if (source!!.startsWith("/safe") && !source.contains(".."))
                sink(source) // Safe
            else
                sink(source) // $ hasTaintFlow
        }
        run {
            val source = source() as String?
            if (source!!.startsWith("/safe") && source.indexOf("..") == -1)
                sink(source) // Safe
            else
                sink(source) // $ hasTaintFlow
        }
        run {
            val source = source() as String?
            if (!source!!.startsWith("/safe") || source.indexOf("..") != -1)
                sink(source) // $ hasTaintFlow
            else
                sink(source) // Safe
        }
        run {
            val source = source() as String?
            if (source!!.startsWith("/safe") && source.lastIndexOf("..") == -1)
                sink(source) // Safe
            else
                sink(source) // $ hasTaintFlow
        }
        // blockListGuard + dotDotCheckGuard
        run {
            val source = source() as String?
            if (!source!!.startsWith("/data") && !source.contains(".."))
                sink(source) // Safe
            else
                sink(source) // $ hasTaintFlow
        }
        run {
            val source = source() as String?
            if (!source!!.startsWith("/data") && source.indexOf("..") == -1)
                sink(source) // Safe
            else
                sink(source) // $ hasTaintFlow
        }
        run {
            val source = source() as String?
            if (source!!.startsWith("/data") || source.indexOf("..") != -1)
                sink(source) // $ hasTaintFlow
            else
                sink(source) // Safe
        }
        run {
            val source = source() as String?
            if (!source!!.startsWith("/data") && source.lastIndexOf("..") == -1)
                sink(source) // Safe
            else
                sink(source) // $ hasTaintFlow
        }
        // validation method
        run {
            val source = source() as String?
            dotDotCheckGuardValidation(source)
            sink(source) // Safe
        }
    }

    @Throws(Exception::class)
    private fun blockListGuardValidation(path: String?) {
        if (path!!.contains("..") || path.startsWith("/data")) throw Exception()
    }

    @Throws(Exception::class)
    fun blockListGuard() {
        // Prefix check by itself is not enough
        run {
            val source = source() as String?
            if (!source!!.startsWith("/data")) {
                sink(source) // $ hasTaintFlow
            } else
                sink(source) // $ hasTaintFlow
        }
        // PathTraversalGuard + blockListGuard
        run {
            val source = source() as String?
            if (!source!!.contains("..") && !source.startsWith("/data"))
                sink(source) // Safe
            else
                sink(source) // $ hasTaintFlow
        }
        run {
            val source = source() as String?
            if (source!!.indexOf("..") == -1 && !source.startsWith("/data"))
                sink(source) // Safe
            else
                sink(source) // $ hasTaintFlow
        }
        run {
            val source = source() as String?
            if (source!!.lastIndexOf("..") == -1 && !source.startsWith("/data"))
                sink(source) // Safe
            else
                sink(source) // $ hasTaintFlow
        }
        // PathTraversalSanitizer + blockListGuard
        run {
            val source: File? = source() as File?
            val normalized: String = source!!.canonicalPath
            if (!normalized.startsWith("/data")) {
                sink(source) // Safe
                sink(normalized) // Safe
            } else {
                sink(source) // $ hasTaintFlow
                sink(normalized) // $ hasTaintFlow
            }
        }
        run {
            val source: File? = source() as File?
            val normalized: File = source!!.canonicalFile
            if (!normalized.startsWith("/data")) {
                sink(source) // Safe
                sink(normalized) // Safe
            } else {
                sink(source) // $ hasTaintFlow
                sink(normalized) // $ hasTaintFlow
            }
        }
        run {
            val source: File? = source() as File?
            val normalized: String = source!!.canonicalFile.toString()
            if (!normalized.startsWith("/data")) {
                sink(source) // Safe
                sink(normalized) // Safe
            } else {
                sink(source) // $ hasTaintFlow
                sink(normalized) // $ hasTaintFlow
            }
        }
        run {
            val source = source() as String?
            val normalized: Path = Paths.get(source).normalize()
            if (!normalized.startsWith("/data")) {
                sink(source) // Safe
                sink(normalized) // Safe
            } else {
                sink(source) // $ hasTaintFlow
                sink(normalized) // $ hasTaintFlow
            }
        }
        run {
            val source = source() as String?
            // normalize().toString() gets extracted as Object.toString, stopping taint here
            val normalized: String = Paths.get(source).normalize().toString()
            if (!normalized.startsWith("/data")) {
                sink(source) // $ SPURIOUS: hasTaintFlow
                sink(normalized) // Safe
            } else {
                sink(source) // $ hasTaintFlow
                sink(normalized) // $ MISSING: hasTaintFlow
            }
        }
        run {
            val source = source() as String?
           // normalize().toString() gets extracted as Object.toString, stopping taint here
             val normalized: String = Paths.get(source).normalize().toString()
            if (!normalized.regionMatches(0, "/data", 0, 5)) {
                sink(source) // $ SPURIOUS: hasTaintFlow
                sink(normalized) // Safe
            } else {
                sink(source) // $ hasTaintFlow
                sink(normalized) // $ MISSING: hasTaintFlow
            }
        }
        run {
            val source = source() as String?
            // normalize().toString() gets extracted as Object.toString, stopping taint here
            val normalized: String = Paths.get(source).normalize().toString()
            if (!normalized.matches("/data/.*".toRegex())) {
                sink(source) // $ SPURIOUS: hasTaintFlow
                sink(normalized) // Safe
            } else {
                sink(source) // $ hasTaintFlow
                sink(normalized) // $ MISSING: hasTaintFlow
            }
        }
        // validation method
        run {
            val source = source() as String?
            blockListGuardValidation(source)
            sink(source) // Safe
        }
        // PathInjectionSanitizer + partial string match with disallowed words
        run {
            val source = source() as String?
            // normalize().toString() gets extracted as Object.toString, stopping taint here
            val normalized: String = Paths.get(source).normalize().toString()
            if (!normalized.contains("/")) {
                sink(source) // $ SPURIOUS: hasTaintFlow
                sink(normalized) // Safe
            } else {
                sink(source) // $ hasTaintFlow
                sink(normalized) // $ MISSING: hasTaintFlow
            }
        }
        run {
            val source = source() as String?
            // normalize().toString() gets extracted as Object.toString, stopping taint here
            val normalized: String = Paths.get(source).normalize().toString()
            if (!normalized.regionMatches(1, "/", 0, 5)) {
                sink(source) // $ SPURIOUS: hasTaintFlow
                sink(normalized) // Safe
            } else {
                sink(source) // $ hasTaintFlow
                sink(normalized) // $ MISSING: hasTaintFlow
            }
        }
        run {
            val source = source() as String?
            // normalize().toString() gets extracted as Object.toString, stopping taint here
            val normalized: String = Paths.get(source).normalize().toString()
            if (!normalized.matches("/".toRegex())) {
                sink(source) // $ SPURIOUS: hasTaintFlow
                sink(normalized) // Safe
            } else {
                sink(source) // $ hasTaintFlow
                sink(normalized) // $ MISSING: hasTaintFlow
            }
        }
        // PathInjectionSanitizer + partial string match with disallowed prefixes
        run {
            val source = source() as String?
            // normalize().toString() gets extracted as Object.toString, stopping taint here
            val normalized: String = Paths.get(source).normalize().toString()
            if (!normalized.contains("/data")) {
                sink(source) // $ SPURIOUS: hasTaintFlow
                sink(normalized) // Safe
            } else {
                sink(source) // $ hasTaintFlow
                sink(normalized) // $ MISSING: hasTaintFlow
            }
        }
        run {
            val source = source() as String?
            // normalize().toString() gets extracted as Object.toString, stopping taint here
            val normalized: String = Paths.get(source).normalize().toString()
            if (!normalized.regionMatches(1, "/data", 0, 5)) {
                sink(source) // $ SPURIOUS: hasTaintFlow
                sink(normalized) // Safe
            } else {
                sink(source) // $ hasTaintFlow
                sink(normalized) // $ MISSING: hasTaintFlow
            }
        }
        run {
            val source = source() as String?
            // normalize().toString() gets extracted as Object.toString, stopping taint here
            val normalized: String = Paths.get(source).normalize().toString()
            if (!normalized.matches(".*/data/.*".toRegex())) {
                sink(source) // $ SPURIOUS: hasTaintFlow
                sink(normalized) // Safe
            } else {
                sink(source) // $ hasTaintFlow
                sink(normalized) // $ MISSING: hasTaintFlow
            }
        }
    }
}