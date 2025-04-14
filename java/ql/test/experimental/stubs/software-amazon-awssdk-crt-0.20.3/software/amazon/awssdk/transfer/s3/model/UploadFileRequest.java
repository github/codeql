// Generated automatically from software.amazon.awssdk.transfer.s3.model.UploadFileRequest for testing purposes

package software.amazon.awssdk.transfer.s3.model;

import java.io.File;
import java.nio.file.Path;
import java.util.Collection;
import java.util.List;
import java.util.function.Consumer;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;
import software.amazon.awssdk.transfer.s3.model.TransferObjectRequest;
import software.amazon.awssdk.transfer.s3.progress.TransferListener;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class UploadFileRequest implements ToCopyableBuilder<UploadFileRequest.Builder, UploadFileRequest>, TransferObjectRequest
{
    protected UploadFileRequest() {}
    public List<TransferListener> transferListeners(){ return null; }
    public Path source(){ return null; }
    public PutObjectRequest putObjectRequest(){ return null; }
    public String toString(){ return null; }
    public UploadFileRequest.Builder toBuilder(){ return null; }
    public boolean equals(Object p0){ return false; }
    public int hashCode(){ return 0; }
    public static UploadFileRequest.Builder builder(){ return null; }
    public static java.lang.Class<? extends UploadFileRequest.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<UploadFileRequest.Builder, UploadFileRequest>
    {
        UploadFileRequest.Builder addTransferListener(TransferListener p0);
        UploadFileRequest.Builder putObjectRequest(PutObjectRequest p0);
        UploadFileRequest.Builder source(Path p0);
        UploadFileRequest.Builder transferListeners(Collection<TransferListener> p0);
        default UploadFileRequest.Builder putObjectRequest(java.util.function.Consumer<PutObjectRequest.Builder> p0){ return null; }
        default UploadFileRequest.Builder source(File p0){ return null; }
    }
}
