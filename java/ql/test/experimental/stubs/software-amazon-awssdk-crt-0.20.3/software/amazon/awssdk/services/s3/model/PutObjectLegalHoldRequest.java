// Generated automatically from software.amazon.awssdk.services.s3.model.PutObjectLegalHoldRequest for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.awscore.AwsRequestOverrideConfiguration;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ChecksumAlgorithm;
import software.amazon.awssdk.services.s3.model.ObjectLockLegalHold;
import software.amazon.awssdk.services.s3.model.RequestPayer;
import software.amazon.awssdk.services.s3.model.S3Request;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class PutObjectLegalHoldRequest extends S3Request implements ToCopyableBuilder<PutObjectLegalHoldRequest.Builder, PutObjectLegalHoldRequest>
{
    protected PutObjectLegalHoldRequest() {}
    public PutObjectLegalHoldRequest.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final ChecksumAlgorithm checksumAlgorithm(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final ObjectLockLegalHold legalHold(){ return null; }
    public final RequestPayer requestPayer(){ return null; }
    public final String bucket(){ return null; }
    public final String checksumAlgorithmAsString(){ return null; }
    public final String contentMD5(){ return null; }
    public final String expectedBucketOwner(){ return null; }
    public final String key(){ return null; }
    public final String requestPayerAsString(){ return null; }
    public final String toString(){ return null; }
    public final String versionId(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static PutObjectLegalHoldRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends PutObjectLegalHoldRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<PutObjectLegalHoldRequest.Builder, PutObjectLegalHoldRequest>, S3Request.Builder, SdkPojo
    {
        PutObjectLegalHoldRequest.Builder bucket(String p0);
        PutObjectLegalHoldRequest.Builder checksumAlgorithm(ChecksumAlgorithm p0);
        PutObjectLegalHoldRequest.Builder checksumAlgorithm(String p0);
        PutObjectLegalHoldRequest.Builder contentMD5(String p0);
        PutObjectLegalHoldRequest.Builder expectedBucketOwner(String p0);
        PutObjectLegalHoldRequest.Builder key(String p0);
        PutObjectLegalHoldRequest.Builder legalHold(ObjectLockLegalHold p0);
        PutObjectLegalHoldRequest.Builder overrideConfiguration(AwsRequestOverrideConfiguration p0);
        PutObjectLegalHoldRequest.Builder overrideConfiguration(java.util.function.Consumer<AwsRequestOverrideConfiguration.Builder> p0);
        PutObjectLegalHoldRequest.Builder requestPayer(RequestPayer p0);
        PutObjectLegalHoldRequest.Builder requestPayer(String p0);
        PutObjectLegalHoldRequest.Builder versionId(String p0);
        default PutObjectLegalHoldRequest.Builder legalHold(java.util.function.Consumer<ObjectLockLegalHold.Builder> p0){ return null; }
    }
}
