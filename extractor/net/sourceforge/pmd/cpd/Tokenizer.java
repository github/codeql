package net.sourceforge.pmd.cpd;

/*
 * This is a stub definition for pmd's Tokenizer interface
 * including only the API used by the GoLanguage class.
 */

import java.util.List;

public interface Tokenizer {
    void tokenize(SourceCode tokens, List<TokenEntry> tokenEntries);
}
