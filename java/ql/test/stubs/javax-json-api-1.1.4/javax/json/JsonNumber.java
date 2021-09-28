// Generated automatically from javax.json.JsonNumber for testing purposes

package javax.json;

import java.math.BigDecimal;
import java.math.BigInteger;
import javax.json.JsonValue;

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
