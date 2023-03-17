// Generated automatically from org.apache.tools.ant.types.FilterChain for testing purposes

package org.apache.tools.ant.types;

import java.util.Stack;
import java.util.Vector;
import org.apache.tools.ant.Project;
import org.apache.tools.ant.filters.ChainableReader;
import org.apache.tools.ant.filters.ClassConstants;
import org.apache.tools.ant.filters.EscapeUnicode;
import org.apache.tools.ant.filters.ExpandProperties;
import org.apache.tools.ant.filters.HeadFilter;
import org.apache.tools.ant.filters.LineContains;
import org.apache.tools.ant.filters.LineContainsRegExp;
import org.apache.tools.ant.filters.PrefixLines;
import org.apache.tools.ant.filters.ReplaceTokens;
import org.apache.tools.ant.filters.StripJavaComments;
import org.apache.tools.ant.filters.StripLineBreaks;
import org.apache.tools.ant.filters.StripLineComments;
import org.apache.tools.ant.filters.SuffixLines;
import org.apache.tools.ant.filters.TabsToSpaces;
import org.apache.tools.ant.filters.TailFilter;
import org.apache.tools.ant.filters.TokenFilter;
import org.apache.tools.ant.types.AntFilterReader;
import org.apache.tools.ant.types.DataType;
import org.apache.tools.ant.types.Reference;

public class FilterChain extends DataType
{
    protected void dieOnCircularReference(Stack<Object> p0, Project p1){}
    public FilterChain(){}
    public Vector<Object> getFilterReaders(){ return null; }
    public void add(ChainableReader p0){}
    public void addClassConstants(ClassConstants p0){}
    public void addContainsRegex(TokenFilter.ContainsRegex p0){}
    public void addDeleteCharacters(TokenFilter.DeleteCharacters p0){}
    public void addEscapeUnicode(EscapeUnicode p0){}
    public void addExpandProperties(ExpandProperties p0){}
    public void addFilterReader(AntFilterReader p0){}
    public void addHeadFilter(HeadFilter p0){}
    public void addIgnoreBlank(TokenFilter.IgnoreBlank p0){}
    public void addLineContains(LineContains p0){}
    public void addLineContainsRegExp(LineContainsRegExp p0){}
    public void addPrefixLines(PrefixLines p0){}
    public void addReplaceRegex(TokenFilter.ReplaceRegex p0){}
    public void addReplaceString(TokenFilter.ReplaceString p0){}
    public void addReplaceTokens(ReplaceTokens p0){}
    public void addStripJavaComments(StripJavaComments p0){}
    public void addStripLineBreaks(StripLineBreaks p0){}
    public void addStripLineComments(StripLineComments p0){}
    public void addSuffixLines(SuffixLines p0){}
    public void addTabsToSpaces(TabsToSpaces p0){}
    public void addTailFilter(TailFilter p0){}
    public void addTokenFilter(TokenFilter p0){}
    public void addTrim(TokenFilter.Trim p0){}
    public void setRefid(Reference p0){}
}
