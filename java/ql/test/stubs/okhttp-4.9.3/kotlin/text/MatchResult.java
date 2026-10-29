// Generated automatically from kotlin.text.MatchResult for testing purposes

package kotlin.text;

import java.util.List;
import kotlin.ranges.IntRange;
import kotlin.text.MatchGroupCollection;

public interface MatchResult
{
    IntRange getRange();
    List<String> getGroupValues();
    MatchGroupCollection getGroups();
    MatchResult next();
    MatchResult.Destructured getDestructured();
    String getValue();
    static public class Destructured
    {
        protected Destructured() {}
        public Destructured(MatchResult p0){}
        public final List<String> toList(){ return null; }
        public final MatchResult getMatch(){ return null; }
    }
}
