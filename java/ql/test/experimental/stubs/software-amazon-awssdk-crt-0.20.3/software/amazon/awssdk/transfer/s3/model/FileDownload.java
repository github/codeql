// Generated automatically from software.amazon.awssdk.transfer.s3.model.FileDownload for testing purposes

package software.amazon.awssdk.transfer.s3.model;

import java.util.concurrent.CompletableFuture;
import software.amazon.awssdk.transfer.s3.model.CompletedFileDownload;
import software.amazon.awssdk.transfer.s3.model.ObjectTransfer;
import software.amazon.awssdk.transfer.s3.model.ResumableFileDownload;

public interface FileDownload extends ObjectTransfer
{
    CompletableFuture<CompletedFileDownload> completionFuture();
    ResumableFileDownload pause();
}
