// Generated automatically from org.apache.tools.ant.types.AbstractFileSet for testing purposes

package org.apache.tools.ant.types;

import java.io.File;
import java.util.Enumeration;
import java.util.Stack;
import org.apache.tools.ant.DirectoryScanner;
import org.apache.tools.ant.FileScanner;
import org.apache.tools.ant.Project;
import org.apache.tools.ant.types.DataType;
import org.apache.tools.ant.types.PatternSet;
import org.apache.tools.ant.types.Reference;
import org.apache.tools.ant.types.selectors.AndSelector;
import org.apache.tools.ant.types.selectors.ContainsRegexpSelector;
import org.apache.tools.ant.types.selectors.ContainsSelector;
import org.apache.tools.ant.types.selectors.DateSelector;
import org.apache.tools.ant.types.selectors.DependSelector;
import org.apache.tools.ant.types.selectors.DepthSelector;
import org.apache.tools.ant.types.selectors.DifferentSelector;
import org.apache.tools.ant.types.selectors.ExecutableSelector;
import org.apache.tools.ant.types.selectors.ExtendSelector;
import org.apache.tools.ant.types.selectors.FileSelector;
import org.apache.tools.ant.types.selectors.FilenameSelector;
import org.apache.tools.ant.types.selectors.MajoritySelector;
import org.apache.tools.ant.types.selectors.NoneSelector;
import org.apache.tools.ant.types.selectors.NotSelector;
import org.apache.tools.ant.types.selectors.OrSelector;
import org.apache.tools.ant.types.selectors.OwnedBySelector;
import org.apache.tools.ant.types.selectors.PosixGroupSelector;
import org.apache.tools.ant.types.selectors.PosixPermissionsSelector;
import org.apache.tools.ant.types.selectors.PresentSelector;
import org.apache.tools.ant.types.selectors.ReadableSelector;
import org.apache.tools.ant.types.selectors.SelectSelector;
import org.apache.tools.ant.types.selectors.SelectorContainer;
import org.apache.tools.ant.types.selectors.SizeSelector;
import org.apache.tools.ant.types.selectors.SymlinkSelector;
import org.apache.tools.ant.types.selectors.TypeSelector;
import org.apache.tools.ant.types.selectors.WritableSelector;
import org.apache.tools.ant.types.selectors.modifiedselector.ModifiedSelector;

abstract public class AbstractFileSet extends DataType implements Cloneable, SelectorContainer
{
    protected AbstractFileSet getRef(Project p0){ return null; }
    protected AbstractFileSet(AbstractFileSet p0){}
    protected void dieOnCircularReference(Stack<Object> p0, Project p1){}
    public AbstractFileSet(){}
    public DirectoryScanner getDirectoryScanner(){ return null; }
    public DirectoryScanner getDirectoryScanner(Project p0){ return null; }
    public Enumeration<FileSelector> selectorElements(){ return null; }
    public File getDir(){ return null; }
    public File getDir(Project p0){ return null; }
    public FileSelector[] getSelectors(Project p0){ return null; }
    public Object clone(){ return null; }
    public PatternSet createPatternSet(){ return null; }
    public PatternSet mergePatterns(Project p0){ return null; }
    public PatternSet.NameEntry createExclude(){ return null; }
    public PatternSet.NameEntry createExcludesFile(){ return null; }
    public PatternSet.NameEntry createInclude(){ return null; }
    public PatternSet.NameEntry createIncludesFile(){ return null; }
    public String toString(){ return null; }
    public String[] mergeExcludes(Project p0){ return null; }
    public String[] mergeIncludes(Project p0){ return null; }
    public boolean getDefaultexcludes(){ return false; }
    public boolean getErrorOnMissingDir(){ return false; }
    public boolean hasPatterns(){ return false; }
    public boolean hasSelectors(){ return false; }
    public boolean isCaseSensitive(){ return false; }
    public boolean isFollowSymlinks(){ return false; }
    public int getMaxLevelsOfSymlinks(){ return 0; }
    public int selectorCount(){ return 0; }
    public void add(FileSelector p0){}
    public void addAnd(AndSelector p0){}
    public void addContains(ContainsSelector p0){}
    public void addContainsRegexp(ContainsRegexpSelector p0){}
    public void addCustom(ExtendSelector p0){}
    public void addDate(DateSelector p0){}
    public void addDepend(DependSelector p0){}
    public void addDepth(DepthSelector p0){}
    public void addDifferent(DifferentSelector p0){}
    public void addExecutable(ExecutableSelector p0){}
    public void addFilename(FilenameSelector p0){}
    public void addMajority(MajoritySelector p0){}
    public void addModified(ModifiedSelector p0){}
    public void addNone(NoneSelector p0){}
    public void addNot(NotSelector p0){}
    public void addOr(OrSelector p0){}
    public void addOwnedBy(OwnedBySelector p0){}
    public void addPosixGroup(PosixGroupSelector p0){}
    public void addPosixPermissions(PosixPermissionsSelector p0){}
    public void addPresent(PresentSelector p0){}
    public void addReadable(ReadableSelector p0){}
    public void addSelector(SelectSelector p0){}
    public void addSize(SizeSelector p0){}
    public void addSymlink(SymlinkSelector p0){}
    public void addType(TypeSelector p0){}
    public void addWritable(WritableSelector p0){}
    public void appendExcludes(String[] p0){}
    public void appendIncludes(String[] p0){}
    public void appendSelector(FileSelector p0){}
    public void setCaseSensitive(boolean p0){}
    public void setDefaultexcludes(boolean p0){}
    public void setDir(File p0){}
    public void setErrorOnMissingDir(boolean p0){}
    public void setExcludes(String p0){}
    public void setExcludesfile(File p0){}
    public void setFile(File p0){}
    public void setFollowSymlinks(boolean p0){}
    public void setIncludes(String p0){}
    public void setIncludesfile(File p0){}
    public void setMaxLevelsOfSymlinks(int p0){}
    public void setRefid(Reference p0){}
    public void setupDirectoryScanner(FileScanner p0){}
    public void setupDirectoryScanner(FileScanner p0, Project p1){}
}
