// Generated automatically from software.amazon.awssdk.services.s3.model.GetUrlRequest for testing purposes

package software.amazon.awssdk.services.s3.model;

import java.net.URI;
import java.util.List;
import java.util.Optional;
import software.amazon.awssdk.core.SdkField;
import software.amazon.awssdk.core.SdkPojo;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class GetUrlRequest implements SdkPojo, ToCopyableBuilder<GetUrlRequest.Builder, GetUrlRequest>
{
    protected GetUrlRequest() {}
    public <T> java.util.Optional<T> getValueForField(String p0, java.lang.Class<T> p1){ return null; }
    public GetUrlRequest.Builder toBuilder(){ return null; }
    public List<SdkField<? extends Object>> sdkFields(){ return null; }
    public Region region(){ return null; }
    public String bucket(){ return null; }
    public String key(){ return null; }
    public String versionId(){ return null; }
    public URI endpoint(){ return null; }
    public static GetUrlRequest.Builder builder(){ return null; }
    static public interface Builder extends CopyableBuilder<GetUrlRequest.Builder, GetUrlRequest>, SdkPojo
    {
        GetUrlRequest.Builder bucket(String p0);
        GetUrlRequest.Builder endpoint(URI p0);
        GetUrlRequest.Builder key(String p0);
        GetUrlRequest.Builder region(Region p0);
        GetUrlRequest.Builder versionId(String p0);
    }
}
