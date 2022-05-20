package net.sourceforge.pmd.cpd;

import java.io.IOException;
import java.io.InputStreamReader;
import java.lang.ProcessBuilder.Redirect;
import java.nio.charset.Charset;
import java.nio.file.Paths;
import java.util.List;
import opencsv.CSVReader;

public class GoLanguage extends AbstractLanguage {
        public GoLanguage() {
                super(".go");
        }

        @Override
        public Tokenizer getTokenizer(final boolean fuzzyMatch) {
                return new Tokenizer() {
                        @Override
                        public void tokenize(SourceCode tokens, List<TokenEntry> tokenEntries) {
                                String fileName = tokens.getFileName();
                                String platform = "linux", exe = "";

                                String osName = System.getProperty("os.name", "unknown");
                                if (osName.contains("Windows")) {
                                        platform = "win";
                                        exe = ".exe";
                                } else if (osName.contains("Mac OS X")) {
                                        platform = "osx";
                                }

                                // get tools folder from SEMMLE_DIST
                                String toolsDir = null;
                                String dist = System.getenv("SEMMLE_DIST");
                                if (dist != null && !dist.isEmpty()) {
                                        toolsDir = dist + "/language-packs/go/tools/platform/" + platform;
                                }

                                String goTokenizer = toolsDir == null ? "go-tokenizer" : toolsDir + "/bin/go-tokenizer";
                                goTokenizer += exe;
                                ProcessBuilder pb = new ProcessBuilder(Paths.get(goTokenizer).toString(), fileName);
                                pb.redirectError(Redirect.INHERIT);
                                try {
                                        Process process = pb.start();
                                        try (
                                                        CSVReader r = new CSVReader(new InputStreamReader(process.getInputStream(), Charset.forName("UTF-8")))
                                                        ) {
                                                String[] row;
                                                while ((row = r.readNext()) != null) {
                                                        String text = row[0];
                                                        String fuzzyText = row[1];
                                                        int beginLine = Integer.parseInt(row[2]);
                                                        int beginColumn = Integer.parseInt(row[3]);
                                                        int endLine = Integer.parseInt(row[4]);
                                                        int endColumn = Integer.parseInt(row[5]);
                                                        tokenEntries.add(new TokenEntry(fuzzyMatch ? text : fuzzyText, fileName, beginLine, beginColumn, endLine, endColumn));
                                                }
                                        }
                                        int exitCode = process.waitFor();
                                        if (exitCode != 0)
                                                throw new RuntimeException("Tokenizing " + fileName + " returned " + exitCode + ".");
                                } catch (IOException | InterruptedException e) {
                                        throw new RuntimeException(e);
                                }
                        }
                };
        }
}
