// Generated automatically from org.apache.tools.ant.types.selectors.BaseSelectorContainer for testing purposes

package org.apache.tools.ant.types.selectors;

import java.io.File;
import java.util.Enumeration;
import java.util.Stack;
import org.apache.tools.ant.Project;
import org.apache.tools.ant.types.selectors.AndSelector;
import org.apache.tools.ant.types.selectors.BaseSelector;
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

abstract public class BaseSelectorContainer extends BaseSelector implements SelectorContainer
{
    protected void dieOnCircularReference(Stack<Object> p0, Project p1){}
    public BaseSelectorContainer(){}
    public Enumeration<FileSelector> selectorElements(){ return null; }
    public FileSelector[] getSelectors(Project p0){ return null; }
    public String toString(){ return null; }
    public abstract boolean isSelected(File p0, String p1, File p2);
    public boolean hasSelectors(){ return false; }
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
    public void appendSelector(FileSelector p0){}
    public void validate(){}
}
