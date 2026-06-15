// Generated automatically from software.amazon.awssdk.transfer.s3.model.CompletedDirectoryDownload for testing purposes

package software.amazon.awssdk.transfer.s3.model;

import java.util.Collection;
import java.util.List;
import software.amazon.awssdk.transfer.s3.model.CompletedDirectoryTransfer;
import software.amazon.awssdk.transfer.s3.model.FailedFileDownload;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class CompletedDirectoryDownload implements CompletedDirectoryTransfer, ToCopyableBuilder<CompletedDirectoryDownload.Builder, CompletedDirectoryDownload>
{
    protected CompletedDirectoryDownload() {}
    public CompletedDirectoryDownload.Builder toBuilder(){ return null; }
    public List<FailedFileDownload> failedTransfers(){ return null; }
    public String toString(){ return null; }
    public boolean equals(Object p0){ return false; }
    public int hashCode(){ return 0; }
    public static CompletedDirectoryDownload.Builder builder(){ return null; }
    public static java.lang.Class<? extends CompletedDirectoryDownload.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<CompletedDirectoryDownload.Builder, CompletedDirectoryDownload>
    {
        CompletedDirectoryDownload build();
        CompletedDirectoryDownload.Builder addFailedTransfer(FailedFileDownload p0);
        CompletedDirectoryDownload.Builder failedTransfers(Collection<FailedFileDownload> p0);
    }
}
