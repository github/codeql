// Generated automatically from kotlin.text.Regex for testing purposes

package kotlin.text;

import java.io.Serializable;
import java.util.List;
import java.util.Set;
import java.util.regex.Pattern;
import kotlin.jvm.functions.Function1;
import kotlin.sequences.Sequence;
import kotlin.text.MatchResult;
import kotlin.text.RegexOption;

public class Regex implements Serializable
{
    protected Regex() {}
    public Regex(Pattern p0){}
    public Regex(String p0){}
    public Regex(String p0, RegexOption p1){}
    public Regex(String p0, Set<? extends RegexOption> p1){}
    public String toString(){ return null; }
    public final List<String> split(CharSequence p0, int p1){ return null; }
    public final MatchResult find(CharSequence p0, int p1){ return null; }
    public final MatchResult matchEntire(CharSequence p0){ return null; }
    public final Pattern toPattern(){ return null; }
    public final Sequence<MatchResult> findAll(CharSequence p0, int p1){ return null; }
    public final Set<RegexOption> getOptions(){ return null; }
    public final String getPattern(){ return null; }
    public final String replace(CharSequence p0, Function1<? super MatchResult, ? extends CharSequence> p1){ return null; }
    public final String replace(CharSequence p0, String p1){ return null; }
    public final String replaceFirst(CharSequence p0, String p1){ return null; }
    public final boolean containsMatchIn(CharSequence p0){ return false; }
    public final boolean matches(CharSequence p0){ return false; }
    public static Regex.Companion Companion = null;
    static public class Companion
    {
        protected Companion() {}
        public final Regex fromLiteral(String p0){ return null; }
        public final String escape(String p0){ return null; }
        public final String escapeReplacement(String p0){ return null; }
    }
}
