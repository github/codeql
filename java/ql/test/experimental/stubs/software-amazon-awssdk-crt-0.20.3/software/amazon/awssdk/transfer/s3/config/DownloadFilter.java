// Generated automatically from software.amazon.awssdk.transfer.s3.config.DownloadFilter for testing purposes

package software.amazon.awssdk.transfer.s3.config;

import java.util.function.Predicate;
import software.amazon.awssdk.services.s3.model.S3Object;

public interface DownloadFilter extends Predicate<S3Object>
{
    boolean test(S3Object p0);
    static DownloadFilter allObjects(){ return null; }
}
