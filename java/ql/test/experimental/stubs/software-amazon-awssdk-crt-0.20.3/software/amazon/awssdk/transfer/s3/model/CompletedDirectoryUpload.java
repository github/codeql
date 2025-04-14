// Generated automatically from software.amazon.awssdk.transfer.s3.model.CompletedDirectoryUpload for testing purposes

package software.amazon.awssdk.transfer.s3.model;

import java.util.Collection;
import java.util.List;
import software.amazon.awssdk.transfer.s3.model.CompletedDirectoryTransfer;
import software.amazon.awssdk.transfer.s3.model.FailedFileUpload;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class CompletedDirectoryUpload implements CompletedDirectoryTransfer, ToCopyableBuilder<CompletedDirectoryUpload.Builder, CompletedDirectoryUpload>
{
    protected CompletedDirectoryUpload() {}
    public CompletedDirectoryUpload.Builder toBuilder(){ return null; }
    public List<FailedFileUpload> failedTransfers(){ return null; }
    public String toString(){ return null; }
    public boolean equals(Object p0){ return false; }
    public int hashCode(){ return 0; }
    public static CompletedDirectoryUpload.Builder builder(){ return null; }
    public static java.lang.Class<? extends CompletedDirectoryUpload.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<CompletedDirectoryUpload.Builder, CompletedDirectoryUpload>
    {
        CompletedDirectoryUpload build();
        CompletedDirectoryUpload.Builder addFailedTransfer(FailedFileUpload p0);
        CompletedDirectoryUpload.Builder failedTransfers(Collection<FailedFileUpload> p0);
    }
}
