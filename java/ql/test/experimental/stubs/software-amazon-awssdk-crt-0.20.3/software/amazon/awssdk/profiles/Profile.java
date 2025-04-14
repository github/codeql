// Generated automatically from software.amazon.awssdk.profiles.Profile for testing purposes

package software.amazon.awssdk.profiles;

import java.util.Map;
import java.util.Optional;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class Profile implements ToCopyableBuilder<Profile.Builder, Profile>
{
    protected Profile() {}
    public Map<String, String> properties(){ return null; }
    public Optional<Boolean> booleanProperty(String p0){ return null; }
    public Optional<String> property(String p0){ return null; }
    public Profile.Builder toBuilder(){ return null; }
    public String name(){ return null; }
    public String toString(){ return null; }
    public boolean equals(Object p0){ return false; }
    public int hashCode(){ return 0; }
    public static Profile.Builder builder(){ return null; }
    static public interface Builder extends CopyableBuilder<Profile.Builder, Profile>
    {
        Profile build();
        Profile.Builder name(String p0);
        Profile.Builder properties(Map<String, String> p0);
    }
}
