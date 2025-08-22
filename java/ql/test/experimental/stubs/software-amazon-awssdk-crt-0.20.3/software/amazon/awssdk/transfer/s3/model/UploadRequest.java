// Generated automatically from software.amazon.awssdk.transfer.s3.model.UploadRequest for testing purposes

package software.amazon.awssdk.transfer.s3.model;

import java.util.Collection;
import java.util.List;
import java.util.function.Consumer;
import software.amazon.awssdk.core.async.AsyncRequestBody;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;
import software.amazon.awssdk.transfer.s3.model.TransferObjectRequest;
import software.amazon.awssdk.transfer.s3.progress.TransferListener;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class UploadRequest implements ToCopyableBuilder<UploadRequest.Builder, UploadRequest>, TransferObjectRequest
{
    protected UploadRequest() {}
    public AsyncRequestBody requestBody(){ return null; }
    public List<TransferListener> transferListeners(){ return null; }
    public PutObjectRequest putObjectRequest(){ return null; }
    public String toString(){ return null; }
    public UploadRequest.Builder toBuilder(){ return null; }
    public boolean equals(Object p0){ return false; }
    public int hashCode(){ return 0; }
    public static UploadRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends UploadRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<UploadRequest.Builder, UploadRequest>
    {
        UploadRequest build();
        UploadRequest.Builder addTransferListener(TransferListener p0);
        UploadRequest.Builder putObjectRequest(PutObjectRequest p0);
        UploadRequest.Builder requestBody(AsyncRequestBody p0);
        UploadRequest.Builder transferListeners(Collection<TransferListener> p0);
        default UploadRequest.Builder putObjectRequest(java.util.function.Consumer<PutObjectRequest.Builder> p0){ return null; }
    }
}
