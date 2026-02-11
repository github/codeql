// Generated automatically from software.amazon.awssdk.services.s3.model.GetBucketWebsiteResponse for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.services.s3.model.ErrorDocument;
import software.amazon.awssdk.services.s3.model.IndexDocument;
import software.amazon.awssdk.services.s3.model.RedirectAllRequestsTo;
import software.amazon.awssdk.services.s3.model.RoutingRule;
import software.amazon.awssdk.services.s3.model.S3Response;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class GetBucketWebsiteResponse extends S3Response implements ToCopyableBuilder<GetBucketWebsiteResponse.Builder, GetBucketWebsiteResponse>
{
    protected GetBucketWebsiteResponse() {}
    public GetBucketWebsiteResponse.Builder toBuilder(){ return null; }
    public final <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public final ErrorDocument errorDocument(){ return null; }
    public final IndexDocument indexDocument(){ return null; }
    public final List<RoutingRule> routingRules(){ return null; }
    public final List<SdkField<? extends Object>> sdkFields(){ return null; }
    public final RedirectAllRequestsTo redirectAllRequestsTo(){ return null; }
    public final String toString(){ return null; }
    public final boolean equals(Object p0){ return false; }
    public final boolean equalsBySdkFields(Object p0){ return false; }
    public final boolean hasRoutingRules(){ return false; }
    public final int hashCode(){ return 0; }
    public static GetBucketWebsiteResponse.Builder builder(){ return null; }
    public static java.lang.Class<? extends GetBucketWebsiteResponse.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<GetBucketWebsiteResponse.Builder, GetBucketWebsiteResponse>, S3Response.Builder, SdkPojo
    {
        GetBucketWebsiteResponse.Builder errorDocument(ErrorDocument p0);
        GetBucketWebsiteResponse.Builder indexDocument(IndexDocument p0);
        GetBucketWebsiteResponse.Builder redirectAllRequestsTo(RedirectAllRequestsTo p0);
        GetBucketWebsiteResponse.Builder routingRules(Collection<RoutingRule> p0);
        GetBucketWebsiteResponse.Builder routingRules(RoutingRule... p0);
        GetBucketWebsiteResponse.Builder routingRules(java.util.function.Consumer<RoutingRule.Builder>... p0);
        default GetBucketWebsiteResponse.Builder errorDocument(java.util.function.Consumer<ErrorDocument.Builder> p0){ return null; }
        default GetBucketWebsiteResponse.Builder indexDocument(java.util.function.Consumer<IndexDocument.Builder> p0){ return null; }
        default GetBucketWebsiteResponse.Builder redirectAllRequestsTo(java.util.function.Consumer<RedirectAllRequestsTo.Builder> p0){ return null; }
    }
}
