// Generated automatically from software.amazon.awssdk.transfer.s3.model.Download for testing purposes

package software.amazon.awssdk.transfer.s3.model;

import java.util.concurrent.CompletableFuture;
import software.amazon.awssdk.transfer.s3.model.CompletedDownload;
import software.amazon.awssdk.transfer.s3.model.ObjectTransfer;

public interface Download<ResultT> extends ObjectTransfer
{
    CompletableFuture<CompletedDownload<ResultT>> completionFuture();
}
