package jdk.jshell;

import java.util.Collection;
import java.util.List;

public abstract class SourceCodeAnalysis {

    public abstract CompletionInfo analyzeCompletion(String input);

    public abstract List<Suggestion> completionSuggestions(String input, int cursor, int[] anchor);

    public abstract List<Documentation> documentation(String input, int cursor, boolean computeJavadoc);

    public abstract String analyzeType(String code, int cursor);

    public abstract QualifiedNames listQualifiedNames(String code, int cursor);

    public abstract SnippetWrapper wrapper(Snippet snippet);

    public abstract List<SnippetWrapper> wrappers(String input);

    public abstract Collection<Snippet> dependents(Snippet snippet);

    SourceCodeAnalysis() {}

    public interface CompletionInfo {

        Completeness completeness();

        String remaining();

        String source();
    }

    public enum Completeness {

        COMPLETE(true),

        COMPLETE_WITH_SEMI(true),

        DEFINITELY_INCOMPLETE(false),

        CONSIDERED_INCOMPLETE(false),

        EMPTY(false),

        UNKNOWN(true);

        private final boolean isComplete;

        Completeness(boolean isComplete) {
            this.isComplete = isComplete;
        }

        public boolean isComplete() {
            return isComplete;
        }
    }

    public interface Suggestion {

        String continuation();

        boolean matchesType();
    }

    public interface Documentation {

        String signature();

        String javadoc();
    }

    public static final class QualifiedNames {


        QualifiedNames(List<String> names, int simpleNameLength, boolean upToDate, boolean resolvable) { }

        public List<String> getNames() {
            return null;
        }

        public int getSimpleNameLength() {
            return 1;
        }

        public boolean isUpToDate() {
            return false;
        }

        public boolean isResolvable() {
            return false;
        }

    }

    public interface SnippetWrapper {

        String source();

        String wrapped();

        String fullClassName();

        Snippet.Kind kind();

        int sourceToWrappedPosition(int pos);

        int wrappedToSourcePosition(int pos);
    }
}
