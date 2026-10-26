// Generated automatically from org.apache.tools.ant.filters.TokenFilter for testing purposes

package org.apache.tools.ant.filters;

import java.io.Reader;
import org.apache.tools.ant.ProjectComponent;
import org.apache.tools.ant.filters.BaseFilterReader;
import org.apache.tools.ant.filters.ChainableReader;
import org.apache.tools.ant.util.LineTokenizer;
import org.apache.tools.ant.util.Tokenizer;

public class TokenFilter extends BaseFilterReader implements ChainableReader
{
    abstract static public class ChainableReaderFilter extends ProjectComponent implements ChainableReader, TokenFilter.Filter
    {
        public ChainableReaderFilter(){}
        public Reader chain(Reader p0){ return null; }
        public void setByLine(boolean p0){}
    }
    public TokenFilter(){}
    public TokenFilter(Reader p0){}
    public final Reader chain(Reader p0){ return null; }
    public int read(){ return 0; }
    public static String resolveBackSlash(String p0){ return null; }
    public static int convertRegexOptions(String p0){ return 0; }
    public void add(TokenFilter.Filter p0){}
    public void add(Tokenizer p0){}
    public void addContainsRegex(TokenFilter.ContainsRegex p0){}
    public void addContainsString(TokenFilter.ContainsString p0){}
    public void addDeleteCharacters(TokenFilter.DeleteCharacters p0){}
    public void addFileTokenizer(TokenFilter.FileTokenizer p0){}
    public void addIgnoreBlank(TokenFilter.IgnoreBlank p0){}
    public void addLineTokenizer(LineTokenizer p0){}
    public void addReplaceRegex(TokenFilter.ReplaceRegex p0){}
    public void addReplaceString(TokenFilter.ReplaceString p0){}
    public void addStringTokenizer(TokenFilter.StringTokenizer p0){}
    public void addTrim(TokenFilter.Trim p0){}
    public void setDelimOutput(String p0){}
    static public class ContainsRegex extends TokenFilter.ChainableReaderFilter
    {
        public ContainsRegex(){}
        public String filter(String p0){ return null; }
        public void setFlags(String p0){}
        public void setPattern(String p0){}
        public void setReplace(String p0){}
    }
    static public class ContainsString extends ProjectComponent implements TokenFilter.Filter
    {
        public ContainsString(){}
        public String filter(String p0){ return null; }
        public void setContains(String p0){}
    }
    static public class DeleteCharacters extends ProjectComponent implements ChainableReader, TokenFilter.Filter
    {
        public DeleteCharacters(){}
        public Reader chain(Reader p0){ return null; }
        public String filter(String p0){ return null; }
        public void setChars(String p0){}
    }
    static public class FileTokenizer extends org.apache.tools.ant.util.FileTokenizer
    {
        public FileTokenizer(){}
    }
    static public class IgnoreBlank extends TokenFilter.ChainableReaderFilter
    {
        public IgnoreBlank(){}
        public String filter(String p0){ return null; }
    }
    static public class ReplaceRegex extends TokenFilter.ChainableReaderFilter
    {
        public ReplaceRegex(){}
        public String filter(String p0){ return null; }
        public void setFlags(String p0){}
        public void setPattern(String p0){}
        public void setReplace(String p0){}
    }
    static public class ReplaceString extends TokenFilter.ChainableReaderFilter
    {
        public ReplaceString(){}
        public String filter(String p0){ return null; }
        public void setFrom(String p0){}
        public void setTo(String p0){}
    }
    static public class StringTokenizer extends org.apache.tools.ant.util.StringTokenizer
    {
        public StringTokenizer(){}
    }
    static public class Trim extends TokenFilter.ChainableReaderFilter
    {
        public String filter(String p0){ return null; }
        public Trim(){}
    }
    static public interface Filter
    {
        String filter(String p0);
    }
}
