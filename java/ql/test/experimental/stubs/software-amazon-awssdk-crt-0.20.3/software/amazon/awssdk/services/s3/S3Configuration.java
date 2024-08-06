// Generated automatically from software.amazon.awssdk.services.s3.S3Configuration for testing purposes

package software.amazon.awssdk.services.s3;

import software.amazon.awssdk.core.ServiceConfiguration;
import software.amazon.awssdk.profiles.ProfileFile;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class S3Configuration implements ServiceConfiguration, ToCopyableBuilder<S3Configuration.Builder, S3Configuration>
{
    protected S3Configuration() {}
    public S3Configuration.Builder toBuilder(){ return null; }
    public boolean accelerateModeEnabled(){ return false; }
    public boolean checksumValidationEnabled(){ return false; }
    public boolean chunkedEncodingEnabled(){ return false; }
    public boolean dualstackEnabled(){ return false; }
    public boolean multiRegionEnabled(){ return false; }
    public boolean pathStyleAccessEnabled(){ return false; }
    public boolean useArnRegionEnabled(){ return false; }
    public static S3Configuration.Builder builder(){ return null; }
    static public interface Builder extends CopyableBuilder<S3Configuration.Builder, S3Configuration>
    {
        Boolean accelerateModeEnabled();
        Boolean checksumValidationEnabled();
        Boolean chunkedEncodingEnabled();
        Boolean dualstackEnabled();
        Boolean multiRegionEnabled();
        Boolean pathStyleAccessEnabled();
        Boolean useArnRegionEnabled();
        ProfileFile profileFile();
        S3Configuration.Builder accelerateModeEnabled(Boolean p0);
        S3Configuration.Builder checksumValidationEnabled(Boolean p0);
        S3Configuration.Builder chunkedEncodingEnabled(Boolean p0);
        S3Configuration.Builder dualstackEnabled(Boolean p0);
        S3Configuration.Builder multiRegionEnabled(Boolean p0);
        S3Configuration.Builder pathStyleAccessEnabled(Boolean p0);
        S3Configuration.Builder profileFile(ProfileFile p0);
        S3Configuration.Builder profileName(String p0);
        S3Configuration.Builder useArnRegionEnabled(Boolean p0);
        String profileName();
    }
}
