// Generated automatically from jakarta.json.JsonNumber for testing purposes

package jakarta.json;

import jakarta.json.JsonValue;
import java.math.BigDecimal;
import java.math.BigInteger;

public interface JsonNumber extends JsonValue
{
    BigDecimal bigDecimalValue();
    BigInteger bigIntegerValue();
    BigInteger bigIntegerValueExact();
    String toString();
    boolean equals(Object p0);
    boolean isIntegral();
    default Number numberValue(){ return null; }
    double doubleValue();
    int hashCode();
    int intValue();
    int intValueExact();
    long longValue();
    long longValueExact();
}
