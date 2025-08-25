// Generated automatically from software.amazon.awssdk.transfer.s3.model.FailedFileUpload for testing purposes

package software.amazon.awssdk.transfer.s3.model;

import software.amazon.awssdk.transfer.s3.model.FailedObjectTransfer;
import software.amazon.awssdk.transfer.s3.model.UploadFileRequest;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class FailedFileUpload implements FailedObjectTransfer, ToCopyableBuilder<FailedFileUpload.Builder, FailedFileUpload>
{
    protected FailedFileUpload() {}
    public FailedFileUpload.Builder toBuilder(){ return null; }
    public String toString(){ return null; }
    public Throwable exception(){ return null; }
    public UploadFileRequest request(){ return null; }
    public boolean equals(Object p0){ return false; }
    public int hashCode(){ return 0; }
    public static FailedFileUpload.Builder builder(){ return null; }
    public static java.lang.Class<? extends FailedFileUpload.Builder> serializableBuilderClass(){ return null; }
    static public interface Builder extends CopyableBuilder<FailedFileUpload.Builder, FailedFileUpload>
    {
        FailedFileUpload.Builder exception(Throwable p0);
        FailedFileUpload.Builder request(UploadFileRequest p0);
    }
}
