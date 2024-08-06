// Generated automatically from software.amazon.awssdk.services.s3.model.SelectObjectContentRequest for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.awscore.AwsRequestOverrideConfiguration;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ExpressionType;
import software.amazon.awssdk.services.s3.model.InputSerialization;
import software.amazon.awssdk.services.s3.model.OutputSerialization;
import software.amazon.awssdk.services.s3.model.RequestProgress;
import software.amazon.awssdk.services.s3.model.S3Request;
import software.amazon.awssdk.services.s3.model.ScanRange;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class SelectObjectContentRequest extends S3Request implements ToCopyableBuilder<SelectObjectContentRequest.Builder, SelectObjectContentRequest>
{
    protected SelectObjectContentRequest() {}
    public SelectObjectContentRequest.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final ExpressionType expressionType(){ return null; }
    public final InputSerialization inputSerialization(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final OutputSerialization outputSerialization(){ return null; }
    public final RequestProgress requestProgress(){ return null; }
    public final ScanRange scanRange(){ return null; }
    public final String bucket(){ return null; }
    public final String expectedBucketOwner(){ return null; }
    public final String expression(){ return null; }
    public final String expressionTypeAsString(){ return null; }
    public final String key(){ return null; }
    public final String sseCustomerAlgorithm(){ return null; }
    public final String sseCustomerKey(){ return null; }
    public final String sseCustomerKeyMD5(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static SelectObjectContentRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends SelectObjectContentRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<SelectObjectContentRequest.Builder, SelectObjectContentRequest>, S3Request.Builder, SdkPojo
    {
        SelectObjectContentRequest.Builder bucket(String p0);
        SelectObjectContentRequest.Builder expectedBucketOwner(String p0);
        SelectObjectContentRequest.Builder expression(String p0);
        SelectObjectContentRequest.Builder expressionType(ExpressionType p0);
        SelectObjectContentRequest.Builder expressionType(String p0);
        SelectObjectContentRequest.Builder inputSerialization(InputSerialization p0);
        SelectObjectContentRequest.Builder key(String p0);
        SelectObjectContentRequest.Builder outputSerialization(OutputSerialization p0);
        SelectObjectContentRequest.Builder overrideConfiguration(AwsRequestOverrideConfiguration p0);
        SelectObjectContentRequest.Builder overrideConfiguration(java.util.function.Consumer<AwsRequestOverrideConfiguration.Builder> p0);
        SelectObjectContentRequest.Builder requestProgress(RequestProgress p0);
        SelectObjectContentRequest.Builder scanRange(ScanRange p0);
        SelectObjectContentRequest.Builder sseCustomerAlgorithm(String p0);
        SelectObjectContentRequest.Builder sseCustomerKey(String p0);
        SelectObjectContentRequest.Builder sseCustomerKeyMD5(String p0);
        default SelectObjectContentRequest.Builder inputSerialization(java.util.function.Consumer<InputSerialization.Builder> p0){ return null; }
        default SelectObjectContentRequest.Builder outputSerialization(java.util.function.Consumer<OutputSerialization.Builder> p0){ return null; }
        default SelectObjectContentRequest.Builder requestProgress(java.util.function.Consumer<RequestProgress.Builder> p0){ return null; }
        default SelectObjectContentRequest.Builder scanRange(java.util.function.Consumer<ScanRange.Builder> p0){ return null; }
    }
}
