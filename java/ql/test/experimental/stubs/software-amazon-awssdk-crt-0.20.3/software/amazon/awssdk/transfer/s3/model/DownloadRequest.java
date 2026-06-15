// Generated automatically from software.amazon.awssdk.transfer.s3.model.DownloadRequest for testing purposes

package software.amazon.awssdk.transfer.s3.model;

import java.util.Collection;
import java.util.List;
import java.util.function.Consumer;
import software.amazon.awssdk.core.async.AsyncResponseTransformer;
import software.amazon.awssdk.services.s3.model.GetObjectRequest;
import software.amazon.awssdk.services.s3.model.GetObjectResponse;
import software.amazon.awssdk.transfer.s3.model.TransferObjectRequest;
import software.amazon.awssdk.transfer.s3.progress.TransferListener;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class DownloadRequest<ReturnT> implements ToCopyableBuilder<DownloadRequest.TypedBuilder<ReturnT>, DownloadRequest<ReturnT>>, TransferObjectRequest
{
    protected DownloadRequest() {}
    public DownloadRequest.TypedBuilder<ReturnT> toBuilder(){ return null; }
    public GetObjectRequest getObjectRequest(){ return null; }
    public List<TransferListener> transferListeners(){ return null; }
    public String toString(){ return null; }
    public boolean equals(Object p0){ return false; }
    public int hashCode(){ return 0; }
    public software.amazon.awssdk.core.async.AsyncResponseTransformer<GetObjectResponse, ReturnT> responseTransformer(){ return null; }
    public static DownloadRequest.UntypedBuilder builder(){ return null; }
    static public interface TypedBuilder<T> extends CopyableBuilder<DownloadRequest.TypedBuilder<T>, software.amazon.awssdk.transfer.s3.model.DownloadRequest<T>>
    {
        DownloadRequest.TypedBuilder<T> addTransferListener(TransferListener p0);
        DownloadRequest.TypedBuilder<T> getObjectRequest(GetObjectRequest p0);
        DownloadRequest.TypedBuilder<T> responseTransformer(software.amazon.awssdk.core.async.AsyncResponseTransformer<GetObjectResponse, T> p0);
        DownloadRequest.TypedBuilder<T> transferListeners(Collection<TransferListener> p0);
        default DownloadRequest.TypedBuilder<T> getObjectRequest(java.util.function.Consumer<GetObjectRequest.Builder> p0){ return null; }
    }
    static public interface UntypedBuilder
    {
        <T> DownloadRequest.TypedBuilder<T> responseTransformer(software.amazon.awssdk.core.async.AsyncResponseTransformer<GetObjectResponse, T> p0);
        DownloadRequest.UntypedBuilder addTransferListener(TransferListener p0);
        DownloadRequest.UntypedBuilder getObjectRequest(GetObjectRequest p0);
        DownloadRequest.UntypedBuilder transferListeners(Collection<TransferListener> p0);
        default DownloadRequest.UntypedBuilder getObjectRequest(java.util.function.Consumer<GetObjectRequest.Builder> p0){ return null; }
    }
}
