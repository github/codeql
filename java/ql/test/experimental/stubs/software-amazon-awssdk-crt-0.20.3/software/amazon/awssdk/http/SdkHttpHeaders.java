// Generated automatically from software.amazon.awssdk.http.SdkHttpHeaders for testing purposes

package software.amazon.awssdk.http;

import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.function.BiConsumer;

public interface SdkHttpHeaders
{
    Map<String, List<String>> headers();
    default List<String> matchingHeaders(String p0){ return null; }
    default Optional<String> firstMatchingHeader(Collection<String> p0){ return null; }
    default Optional<String> firstMatchingHeader(String p0){ return null; }
    default int numHeaders(){ return 0; }
    default void forEachHeader(BiConsumer<? super String, ? super List<String>> p0){}
}
