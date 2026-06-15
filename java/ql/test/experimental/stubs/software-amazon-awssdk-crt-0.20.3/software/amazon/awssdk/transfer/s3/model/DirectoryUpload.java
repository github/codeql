// Generated automatically from software.amazon.awssdk.transfer.s3.model.DirectoryUpload for testing purposes

package software.amazon.awssdk.transfer.s3.model;

import java.util.concurrent.CompletableFuture;
import software.amazon.awssdk.transfer.s3.model.CompletedDirectoryUpload;
import software.amazon.awssdk.transfer.s3.model.DirectoryTransfer;

public interface DirectoryUpload extends DirectoryTransfer
{
    CompletableFuture<CompletedDirectoryUpload> completionFuture();
}
