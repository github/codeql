// Generated automatically from software.amazon.awssdk.transfer.s3.model.Upload for testing purposes

package software.amazon.awssdk.transfer.s3.model;

import java.util.concurrent.CompletableFuture;
import software.amazon.awssdk.transfer.s3.model.CompletedUpload;
import software.amazon.awssdk.transfer.s3.model.ObjectTransfer;

public interface Upload extends ObjectTransfer
{
    CompletableFuture<CompletedUpload> completionFuture();
}
