// Generated automatically from software.amazon.awssdk.core.protocol.MarshallingType for testing purposes

package software.amazon.awssdk.core.protocol;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;
import java.util.Map;
import software.amazon.awssdk.core.SdkBytes;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.core.document.Document;

public interface MarshallingType<T>
{
    java.lang.Class<? super T> getTargetClass();
    static <T> MarshallingType<T> newType(java.lang.Class<? super T> p0){ return null; }
    static MarshallingType<BigDecimal> BIG_DECIMAL = null;
    static MarshallingType<Boolean> BOOLEAN = null;
    static MarshallingType<Document> DOCUMENT = null;
    static MarshallingType<Double> DOUBLE = null;
    static MarshallingType<Float> FLOAT = null;
    static MarshallingType<Instant> INSTANT = null;
    static MarshallingType<Integer> INTEGER = null;
    static MarshallingType<List<? extends Object>> LIST = null;
    static MarshallingType<Long> LONG = null;
    static MarshallingType<Map<String, ? extends Object>> MAP = null;
    static MarshallingType<SdkBytes> SDK_BYTES = null;
    static MarshallingType<SdkPojo> SDK_POJO = null;
    static MarshallingType<Short> SHORT = null;
    static MarshallingType<String> STRING = null;
    static MarshallingType<Void> NULL = null;
}
