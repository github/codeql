// Generated automatically from software.amazon.awssdk.transfer.s3.model.DirectoryDownload for testing purposes

package software.amazon.awssdk.transfer.s3.model;

import java.util.concurrent.CompletableFuture;
import software.amazon.awssdk.transfer.s3.model.CompletedDirectoryDownload;
import software.amazon.awssdk.transfer.s3.model.DirectoryTransfer;

public interface DirectoryDownload extends DirectoryTransfer
{
    CompletableFuture<CompletedDirectoryDownload> completionFuture();
}
