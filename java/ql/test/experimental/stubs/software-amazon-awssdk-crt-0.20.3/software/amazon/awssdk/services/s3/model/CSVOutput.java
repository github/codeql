// Generated automatically from software.amazon.awssdk.services.s3.model.CSVOutput for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.QuoteFields;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class CSVOutput implements SdkPojo, Serializable, ToCopyableBuilder<CSVOutput.Builder, CSVOutput>
{
    protected CSVOutput() {}
    public CSVOutput.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final QuoteFields quoteFields(){ return null; }
    public final String fieldDelimiter(){ return null; }
    public final String quoteCharacter(){ return null; }
    public final String quoteEscapeCharacter(){ return null; }
    public final String quoteFieldsAsString(){ return null; }
    public final String recordDelimiter(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static CSVOutput.Builder builder(){ return null; }
    public static java.lang.Class<? extends CSVOutput.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<CSVOutput.Builder, CSVOutput>, SdkPojo
    {
        CSVOutput.Builder fieldDelimiter(String p0);
        CSVOutput.Builder quoteCharacter(String p0);
        CSVOutput.Builder quoteEscapeCharacter(String p0);
        CSVOutput.Builder quoteFields(QuoteFields p0);
        CSVOutput.Builder quoteFields(String p0);
        CSVOutput.Builder recordDelimiter(String p0);
    }
}
