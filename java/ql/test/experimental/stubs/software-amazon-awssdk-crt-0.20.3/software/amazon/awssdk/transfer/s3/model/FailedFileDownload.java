// Generated automatically from software.amazon.awssdk.transfer.s3.model.FailedFileDownload for testing purposes

package software.amazon.awssdk.transfer.s3.model;

import software.amazon.awssdk.transfer.s3.model.DownloadFileRequest;
import software.amazon.awssdk.transfer.s3.model.FailedObjectTransfer;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class FailedFileDownload implements FailedObjectTransfer, ToCopyableBuilder<FailedFileDownload.Builder, FailedFileDownload>
{
    protected FailedFileDownload() {}
    public DownloadFileRequest request(){ return null; }
    public FailedFileDownload.Builder toBuilder(){ return null; }
    public String toString(){ return null; }
    public Throwable exception(){ return null; }
    public boolean equals(Object p0){ return false; }
    public int hashCode(){ return 0; }
    public static FailedFileDownload.Builder builder(){ return null; }
    public static java.lang.Class<? extends FailedFileDownload.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<FailedFileDownload.Builder, FailedFileDownload>
    {
        FailedFileDownload.Builder exception(Throwable p0);
        FailedFileDownload.Builder request(DownloadFileRequest p0);
    }
}
