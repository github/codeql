// Generated automatically from software.amazon.awssdk.services.s3.model.GetBucketPolicyStatusResponse for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.PolicyStatus;
import software.amazon.awssdk.services.s3.model.S3Response;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class GetBucketPolicyStatusResponse extends S3Response implements ToCopyableBuilder<GetBucketPolicyStatusResponse.Builder, GetBucketPolicyStatusResponse>
{
    protected GetBucketPolicyStatusResponse() {}
    public GetBucketPolicyStatusResponse.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final PolicyStatus policyStatus(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static GetBucketPolicyStatusResponse.Builder builder(){ return null; }
    public static java.lang.Class<? extends GetBucketPolicyStatusResponse.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<GetBucketPolicyStatusResponse.Builder, GetBucketPolicyStatusResponse>, S3Response.Builder, SdkPojo
    {
        GetBucketPolicyStatusResponse.Builder policyStatus(PolicyStatus p0);
        default GetBucketPolicyStatusResponse.Builder policyStatus(java.util.function.Consumer<PolicyStatus.Builder> p0){ return null; }
    }
}
