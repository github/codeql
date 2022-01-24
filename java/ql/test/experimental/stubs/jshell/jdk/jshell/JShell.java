package jdk.jshell;

import java.util.List;
import java.lang.IllegalStateException;

public class JShell implements AutoCloseable {

    JShell(Builder b) throws IllegalStateException { }

    public static class Builder {

        Builder() { }

        public JShell build() throws IllegalStateException {
            return null;
        }
    }

    public static JShell create() throws IllegalStateException {
        return null;
    }

    public static Builder builder() {
        return null;
    }

    public SourceCodeAnalysis sourceCodeAnalysis() {
        return null;
    }

    public List<SnippetEvent> eval(String input) throws IllegalStateException {
        return null;
    }

    @Override
    public void close() { }
}
