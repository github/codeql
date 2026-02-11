import javax.lang.model.element.Modifier;
import javax.lang.model.element.NestingKind;
import javax.tools.JavaCompiler;
import javax.tools.JavaFileObject;
import javax.tools.ToolProvider;
import java.io.*;
import java.net.URI;
import java.util.List;
import java.util.Objects;

public class Compiler {
    public static void main(String[] args) {

        JavaCompiler.CompilationTask jc = ToolProvider.getSystemJavaCompiler().getTask(
                null, null, null, null, null,
                List.of(
                        new JavaFileObject() {
                            @Override
                            public Kind getKind() {
                                return Kind.SOURCE;
                            }

                            @Override
                            public boolean isNameCompatible(String simpleName, Kind kind) {
                                return Objects.equals(simpleName, "Main");
                            }

                            @Override
                            public NestingKind getNestingKind() {
                                return null;
                            }

                            @Override
                            public Modifier getAccessLevel() {
                                return null;
                            }

                            @Override
                            public URI toUri() {
                                return URI.create("https://nonesuch.imaginary/somedir/Main.java");
                            }

                            @Override
                            public String getName() {
                                return "Main.java";
                            }

                            @Override
                            public InputStream openInputStream() throws IOException {
                                return new ByteArrayInputStream(this.getCharContent(true).toString().getBytes());
                            }

                            @Override
                            public OutputStream openOutputStream() throws IOException {
                                throw new IOException("No output allowed");
                            }

                            @Override
                            public Reader openReader(boolean ignoreEncodingErrors) throws IOException {
                                return new StringReader(this.getCharContent(ignoreEncodingErrors).toString());
                            }

                            @Override
                            public CharSequence getCharContent(boolean ignoreEncodingErrors) throws IOException {
                                return "public class Main { }";
                            }

                            @Override
                            public Writer openWriter() throws IOException {
                                throw new IOException("No output allowed");
                            }

                            @Override
                            public long getLastModified() {
                                return 0;
                            }

                            @Override
                            public boolean delete() {
                                return false;
                            }

                            @Override
                            public String toString() {
                                return "In-memory file with URI " + this.toUri();
                            }
                        }
                )
        );

        jc.call();
    }
}
