// Generated automatically from software.amazon.awssdk.transfer.s3.model.ResumableFileUpload for testing purposes

package software.amazon.awssdk.transfer.s3.model;

import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Path;
import java.time.Instant;
import java.util.Optional;
import java.util.OptionalLong;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkBytes;
import software.amazon.awssdk.transfer.s3.model.ResumableTransfer;
import software.amazon.awssdk.transfer.s3.model.UploadFileRequest;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class ResumableFileUpload implements ResumableTransfer, ToCopyableBuilder<ResumableFileUpload.Builder, ResumableFileUpload>
{
    protected ResumableFileUpload() {}
    public InputStream serializeToInputStream(){ return null; }
    public Instant fileLastModified(){ return null; }
    public Optional<String> multipartUploadId(){ return null; }
    public OptionalLong partSizeInBytes(){ return null; }
    public OptionalLong totalParts(){ return null; }
    public OptionalLong transferredParts(){ return null; }
    public ResumableFileUpload.Builder toBuilder(){ return null; }
    public SdkBytes serializeToBytes(){ return null; }
    public String serializeToString(){ return null; }
    public String toString(){ return null; }
    public UploadFileRequest uploadFileRequest(){ return null; }
    public boolean equals(Object p0){ return false; }
    public int hashCode(){ return 0; }
    public long fileLength(){ return 0; }
    public static ResumableFileUpload fromBytes(SdkBytes p0){ return null; }
    public static ResumableFileUpload fromFile(Path p0){ return null; }
    public static ResumableFileUpload fromString(String p0){ return null; }
    public static ResumableFileUpload.Builder builder(){ return null; }
    public void serializeToFile(Path p0){}
    public void serializeToOutputStream(OutputStream p0){}
    static public interface Builder extends CopyableBuilder<ResumableFileUpload.Builder, ResumableFileUpload>
    {
        ResumableFileUpload.Builder fileLastModified(Instant p0);
        ResumableFileUpload.Builder fileLength(Long p0);
        ResumableFileUpload.Builder multipartUploadId(String p0);
        ResumableFileUpload.Builder partSizeInBytes(Long p0);
        ResumableFileUpload.Builder totalParts(Long p0);
        ResumableFileUpload.Builder transferredParts(Long p0);
        ResumableFileUpload.Builder uploadFileRequest(UploadFileRequest p0);
        default ResumableFileUpload.Builder uploadFileRequest(java.util.function.Consumer<UploadFileRequest.Builder> p0){ return null; }
    }
}
