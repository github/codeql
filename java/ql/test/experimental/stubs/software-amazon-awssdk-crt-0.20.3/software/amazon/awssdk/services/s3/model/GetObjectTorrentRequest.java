// Generated automatically from software.amazon.awssdk.services.s3.model.GetObjectTorrentRequest for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.awscore.AwsRequestOverrideConfiguration;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.RequestPayer;
import software.amazon.awssdk.services.s3.model.S3Request;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class GetObjectTorrentRequest extends S3Request implements ToCopyableBuilder<GetObjectTorrentRequest.Builder, GetObjectTorrentRequest>
{
    protected GetObjectTorrentRequest() {}
    public GetObjectTorrentRequest.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final RequestPayer requestPayer(){ return null; }
    public final String bucket(){ return null; }
    public final String expectedBucketOwner(){ return null; }
    public final String key(){ return null; }
    public final String requestPayerAsString(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final int hashCode(){ return 0; }
    public static GetObjectTorrentRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends GetObjectTorrentRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<GetObjectTorrentRequest.Builder, GetObjectTorrentRequest>, S3Request.Builder, SdkPojo
    {
        GetObjectTorrentRequest.Builder bucket(String p0);
        GetObjectTorrentRequest.Builder expectedBucketOwner(String p0);
        GetObjectTorrentRequest.Builder key(String p0);
        GetObjectTorrentRequest.Builder overrideConfiguration(AwsRequestOverrideConfiguration p0);
        GetObjectTorrentRequest.Builder overrideConfiguration(java.util.function.Consumer<AwsRequestOverrideConfiguration.Builder> p0);
        GetObjectTorrentRequest.Builder requestPayer(RequestPayer p0);
        GetObjectTorrentRequest.Builder requestPayer(String p0);
    }
}
