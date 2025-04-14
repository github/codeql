// Generated automatically from software.amazon.awssdk.services.s3.paginators.ListPartsPublisher for testing purposes

package software.amazon.awssdk.services.s3.paginators;

import org.reactivestreams.Subscriber;
import software.amazon.awssdk.core.async.SdkPublisher;
import software.amazon.awssdk.services.s3.S3AsyncClient;
import software.amazon.awssdk.services.s3.model.ListPartsRequest;
import software.amazon.awssdk.services.s3.model.ListPartsResponse;
import software.amazon.awssdk.services.s3.model.Part;

public class ListPartsPublisher implements SdkPublisher<ListPartsResponse>
{
    protected ListPartsPublisher() {}
    public ListPartsPublisher(S3AsyncClient p0, ListPartsRequest p1){}
    public final SdkPublisher<Part> parts(){ return null; }
    public void subscribe(Subscriber<? super ListPartsResponse> p0){}
}
