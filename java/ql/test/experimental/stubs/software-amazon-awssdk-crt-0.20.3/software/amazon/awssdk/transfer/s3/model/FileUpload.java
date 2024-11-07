// Generated automatically from software.amazon.awssdk.transfer.s3.model.FileUpload for testing purposes

package software.amazon.awssdk.transfer.s3.model;

import java.util.concurrent.CompletableFuture;
import software.amazon.awssdk.transfer.s3.model.CompletedFileUpload;
import software.amazon.awssdk.transfer.s3.model.ObjectTransfer;
import software.amazon.awssdk.transfer.s3.model.ResumableFileUpload;

public interface FileUpload extends ObjectTransfer
{
    CompletableFuture<CompletedFileUpload> completionFuture();
    ResumableFileUpload pause();
}
