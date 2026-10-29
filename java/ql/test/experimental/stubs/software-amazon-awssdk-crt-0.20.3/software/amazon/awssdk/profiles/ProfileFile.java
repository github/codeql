// Generated automatically from software.amazon.awssdk.profiles.ProfileFile for testing purposes

package software.amazon.awssdk.profiles;

import java.io.InputStream;
import java.nio.file.Path;
import java.util.Map;
import java.util.Optional;
import software.amazon.awssdk.profiles.Profile;
import software.amazon.awssdk.utils.builder.SdkBuilder;

public class ProfileFile
{
    protected ProfileFile() {}
    public Map<String, Profile> profiles(){ return null; }
    public Optional<Profile> getSection(String p0, String p1){ return null; }
    public Optional<Profile> profile(String p0){ return null; }
    public String toString(){ return null; }
    public boolean equals(Object p0){ return false; }
    public int hashCode(){ return 0; }
    public static ProfileFile defaultProfileFile(){ return null; }
    public static ProfileFile.Aggregator aggregator(){ return null; }
    public static ProfileFile.Builder builder(){ return null; }
    public static String PROFILES_SECTION_TITLE = null;
    static public class Aggregator implements SdkBuilder<ProfileFile.Aggregator, ProfileFile>
    {
        public Aggregator(){}
        public ProfileFile build(){ return null; }
        public ProfileFile.Aggregator addFile(ProfileFile p0){ return null; }
    }
    static public enum Type
    {
        CONFIGURATION, CREDENTIALS;
        private Type() {}
    }
    static public interface Builder extends SdkBuilder<ProfileFile.Builder, ProfileFile>
    {
        ProfileFile build();
        ProfileFile.Builder content(InputStream p0);
        ProfileFile.Builder content(Path p0);
        ProfileFile.Builder type(ProfileFile.Type p0);
    }
}
