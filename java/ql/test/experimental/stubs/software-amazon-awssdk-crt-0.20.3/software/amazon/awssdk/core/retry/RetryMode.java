// Generated automatically from software.amazon.awssdk.core.retry.RetryMode for testing purposes

package software.amazon.awssdk.core.retry;

import java.util.function.Supplier;
import software.amazon.awssdk.profiles.ProfileFile;

public enum RetryMode
{
    ADAPTIVE, LEGACY, STANDARD;
    private RetryMode() {}
    public static RetryMode defaultRetryMode(){ return null; }
    public static RetryMode.Resolver resolver(){ return null; }
    static public class Resolver
    {
        protected Resolver() {}
        public RetryMode resolve(){ return null; }
        public RetryMode.Resolver defaultRetryMode(RetryMode p0){ return null; }
        public RetryMode.Resolver profileFile(Supplier<ProfileFile> p0){ return null; }
        public RetryMode.Resolver profileName(String p0){ return null; }
    }
}
