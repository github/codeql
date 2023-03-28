// Generated automatically from org.apache.tools.ant.types.PatternSet for testing purposes

package org.apache.tools.ant.types;

import java.io.File;
import org.apache.tools.ant.Project;
import org.apache.tools.ant.types.DataType;
import org.apache.tools.ant.types.Reference;

public class PatternSet extends DataType implements Cloneable
{
    public Object clone(){ return null; }
    public PatternSet(){}
    public PatternSet.NameEntry createExclude(){ return null; }
    public PatternSet.NameEntry createExcludesFile(){ return null; }
    public PatternSet.NameEntry createInclude(){ return null; }
    public PatternSet.NameEntry createIncludesFile(){ return null; }
    public String toString(){ return null; }
    public String[] getExcludePatterns(Project p0){ return null; }
    public String[] getIncludePatterns(Project p0){ return null; }
    public boolean hasPatterns(Project p0){ return false; }
    public class NameEntry
    {
        public NameEntry(){}
        public String evalName(Project p0){ return null; }
        public String getName(){ return null; }
        public String toString(){ return null; }
        public void setIf(Object p0){}
        public void setIf(String p0){}
        public void setName(String p0){}
        public void setUnless(Object p0){}
        public void setUnless(String p0){}
    }
    public void addConfiguredInvert(PatternSet p0){}
    public void addConfiguredPatternset(PatternSet p0){}
    public void append(PatternSet p0, Project p1){}
    public void setExcludes(String p0){}
    public void setExcludesfile(File p0){}
    public void setIncludes(String p0){}
    public void setIncludesfile(File p0){}
    public void setRefid(Reference p0){}
}
