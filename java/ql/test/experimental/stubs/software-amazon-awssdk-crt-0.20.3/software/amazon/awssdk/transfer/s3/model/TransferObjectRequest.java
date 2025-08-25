// Generated automatically from software.amazon.awssdk.transfer.s3.model.TransferObjectRequest for testing purposes

package software.amazon.awssdk.transfer.s3.model;

import java.util.List;
import software.amazon.awssdk.transfer.s3.model.TransferRequest;
import software.amazon.awssdk.transfer.s3.progress.TransferListener;

public interface TransferObjectRequest extends TransferRequest
{
    List<TransferListener> transferListeners();
}
