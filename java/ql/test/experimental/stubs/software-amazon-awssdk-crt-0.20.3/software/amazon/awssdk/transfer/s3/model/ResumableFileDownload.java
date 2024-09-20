// Generated automatically from software.amazon.awssdk.transfer.s3.model.ResumableFileDownload for testing purposes

package software.amazon.awssdk.transfer.s3.model;

import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Path;
import java.time.Instant;
import java.util.Optional;
import java.util.OptionalLong;
import java.util.function.Consumer;
import software.amazon.awssdk.core.SdkBytes;
import software.amazon.awssdk.transfer.s3.model.DownloadFileRequest;
import software.amazon.awssdk.transfer.s3.model.ResumableTransfer;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class ResumableFileDownload implements ResumableTransfer, ToCopyableBuilder<ResumableFileDownload.Builder, ResumableFileDownload>
{
    protected ResumableFileDownload() {}
    public DownloadFileRequest downloadFileRequest(){ return null; }
    public InputStream serializeToInputStream(){ return null; }
    public Instant fileLastModified(){ return null; }
    public Optional<Instant> s3ObjectLastModified(){ return null; }
    public OptionalLong totalSizeInBytes(){ return null; }
    public ResumableFileDownload.Builder toBuilder(){ return null; }
    public SdkBytes serializeToBytes(){ return null; }
    public String serializeToString(){ return null; }
    public String toString(){ return null; }
    public boolean equals(Object p0){ return false; }
    public int hashCode(){ return 0; }
    public long bytesTransferred(){ return 0; }
    public static ResumableFileDownload fromBytes(SdkBytes p0){ return null; }
    public static ResumableFileDownload fromFile(Path p0){ return null; }
    public static ResumableFileDownload fromString(String p0){ return null; }
    public static ResumableFileDownload.Builder builder(){ return null; }
    public void serializeToFile(Path p0){}
    public void serializeToOutputStream(OutputStream p0){}
    static public interface Builder extends CopyableBuilder<ResumableFileDownload.Builder, ResumableFileDownload>
    {
        ResumableFileDownload.Builder bytesTransferred(Long p0);
        ResumableFileDownload.Builder downloadFileRequest(DownloadFileRequest p0);
        ResumableFileDownload.Builder fileLastModified(Instant p0);
        ResumableFileDownload.Builder s3ObjectLastModified(Instant p0);
        ResumableFileDownload.Builder totalSizeInBytes(Long p0);
        default ResumableFileDownload.Builder downloadFileRequest(java.util.function.Consumer<DownloadFileRequest.Builder> p0){ return null; }
    }
}
