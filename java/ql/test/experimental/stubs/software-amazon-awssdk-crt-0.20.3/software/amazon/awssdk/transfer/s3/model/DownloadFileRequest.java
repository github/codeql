// Generated automatically from software.amazon.awssdk.transfer.s3.model.DownloadFileRequest for testing purposes

package software.amazon.awssdk.transfer.s3.model;

import java.io.File;
import java.nio.file.Path;
import java.util.Collection;
import java.util.List;
import java.util.function.Consumer;
import software.amazon.awssdk.services.s3.model.GetObjectRequest;
import software.amazon.awssdk.transfer.s3.model.TransferObjectRequest;
import software.amazon.awssdk.transfer.s3.progress.TransferListener;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class DownloadFileRequest implements ToCopyableBuilder<DownloadFileRequest.Builder, DownloadFileRequest>, TransferObjectRequest
{
    protected DownloadFileRequest() {}
    public DownloadFileRequest.Builder toBuilder(){ return null; }
    public GetObjectRequest getObjectRequest(){ return null; }
    public List<TransferListener> transferListeners(){ return null; }
    public Path destination(){ return null; }
    public String toString(){ return null; }
    public boolean equals(Object p0){ return false; }
    public int hashCode(){ return 0; }
    public static DownloadFileRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends DownloadFileRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<DownloadFileRequest.Builder, DownloadFileRequest>
    {
        DownloadFileRequest.Builder addTransferListener(TransferListener p0);
        DownloadFileRequest.Builder destination(Path p0);
        DownloadFileRequest.Builder getObjectRequest(GetObjectRequest p0);
        DownloadFileRequest.Builder transferListeners(Collection<TransferListener> p0);
        default DownloadFileRequest.Builder destination(File p0){ return null; }
        default DownloadFileRequest.Builder getObjectRequest(java.util.function.Consumer<GetObjectRequest.Builder> p0){ return null; }
    }
}
