// Generated automatically from software.amazon.awssdk.services.s3.model.CSVInput for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.FileHeaderInfo;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class CSVInput implements SdkPojo, Serializable, ToCopyableBuilder<CSVInput.Builder, CSVInput>
{
    protected CSVInput() {}
    public CSVInput.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final Boolean allowQuotedRecordDelimiter(){ return null; }
    public final FileHeaderInfo fileHeaderInfo(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final String comments(){ return null; }
    public final String fieldDelimiter(){ return null; }
    public final String fileHeaderInfoAsString(){ return null; }
    public final String quoteCharacter(){ return null; }
    public final String quoteEscapeCharacter(){ return null; }
    public final String recordDelimiter(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static CSVInput.Builder builder(){ return null; }
    public static java.lang.Class<? extends CSVInput.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<CSVInput.Builder, CSVInput>, SdkPojo
    {
        CSVInput.Builder allowQuotedRecordDelimiter(Boolean p0);
        CSVInput.Builder comments(String p0);
        CSVInput.Builder fieldDelimiter(String p0);
        CSVInput.Builder fileHeaderInfo(FileHeaderInfo p0);
        CSVInput.Builder fileHeaderInfo(String p0);
        CSVInput.Builder quoteCharacter(String p0);
        CSVInput.Builder quoteEscapeCharacter(String p0);
        CSVInput.Builder recordDelimiter(String p0);
    }
}
