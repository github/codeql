// Generated automatically from okhttp3.Headers for testing purposes

package okhttp3;

import java.time.Instant;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import kotlin.Pair;
import kotlin.jvm.internal.markers.KMappedMarker;

public class Headers implements Iterable<Pair<? extends String, ? extends String>>, KMappedMarker {
    protected Headers() {}

    public Iterator<Pair<? extends String, ? extends String>> iterator() {
        return null;
    }

    public String toString() {
        return null;
    }

    public boolean equals(Object p0) {
        return false;
    }

    public final Date getDate(String p0) {
        return null;
    }

    public final Headers.Builder newBuilder() {
        return null;
    }

    public final Instant getInstant(String p0) {
        return null;
    }

    public final List<String> values(String p0) {
        return null;
    }

    public final Map<String, List<String>> toMultimap() {
        return null;
    }

    public final Set<String> names() {
        return null;
    }

    public final String get(String p0) {
        return null;
    }

    public final String name(int p0) {
        return null;
    }

    public final String value(int p0) {
        return null;
    }

    public final int size() {
        return 0;
    }

    public final long byteCount() {
        return 0;
    }

    public int hashCode() {
        return 0;
    }

    public static Headers of(Map<String, String> p0) {
        return null;
    }

    public static Headers of(String... p0) {
        return null;
    }

    public static Headers.Companion Companion = null;

    static public class Builder {
        public Builder() {}

        public final Headers build() {
            return null;
        }

        public final Headers.Builder add(String p0) {
            return null;
        }

        public final Headers.Builder add(String p0, Date p1) {
            return null;
        }

        public final Headers.Builder add(String p0, Instant p1) {
            return null;
        }

        public final Headers.Builder add(String p0, String p1) {
            return null;
        }

        public final Headers.Builder addAll(Headers p0) {
            return null;
        }

        public final Headers.Builder addLenient$okhttp(String p0) {
            return null;
        }

        public final Headers.Builder addLenient$okhttp(String p0, String p1) {
            return null;
        }

        public final Headers.Builder addUnsafeNonAscii(String p0, String p1) {
            return null;
        }

        public final Headers.Builder removeAll(String p0) {
            return null;
        }

        public final Headers.Builder set(String p0, Date p1) {
            return null;
        }

        public final Headers.Builder set(String p0, Instant p1) {
            return null;
        }

        public final Headers.Builder set(String p0, String p1) {
            return null;
        }

        public final List<String> getNamesAndValues$okhttp() {
            return null;
        }

        public final String get(String p0) {
            return null;
        }
    }
    static public class Companion {
        protected Companion() {}

        public final Headers of(Map<String, String> p0) {
            return null;
        }

        public final Headers of(String... p0) {
            return null;
        }
    }
}
