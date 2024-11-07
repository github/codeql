// Generated automatically from software.amazon.awssdk.transfer.s3.progress.TransferProgressSnapshot for testing purposes

package software.amazon.awssdk.transfer.s3.progress;

import java.util.Optional;
import java.util.OptionalDouble;
import java.util.OptionalLong;
import software.amazon.awssdk.core.SdkResponse;

public interface TransferProgressSnapshot
{
    Optional<SdkResponse> sdkResponse();
    OptionalDouble ratioTransferred();
    OptionalLong remainingBytes();
    OptionalLong totalBytes();
    long transferredBytes();
}
