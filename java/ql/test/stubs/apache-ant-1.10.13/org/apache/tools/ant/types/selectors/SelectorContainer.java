// Generated automatically from org.apache.tools.ant.types.selectors.SelectorContainer for testing purposes

package org.apache.tools.ant.types.selectors;

import java.util.Enumeration;
import org.apache.tools.ant.Project;
import org.apache.tools.ant.types.selectors.AndSelector;
import org.apache.tools.ant.types.selectors.ContainsRegexpSelector;
import org.apache.tools.ant.types.selectors.ContainsSelector;
import org.apache.tools.ant.types.selectors.DateSelector;
import org.apache.tools.ant.types.selectors.DependSelector;
import org.apache.tools.ant.types.selectors.DepthSelector;
import org.apache.tools.ant.types.selectors.DifferentSelector;
import org.apache.tools.ant.types.selectors.ExtendSelector;
import org.apache.tools.ant.types.selectors.FileSelector;
import org.apache.tools.ant.types.selectors.FilenameSelector;
import org.apache.tools.ant.types.selectors.MajoritySelector;
import org.apache.tools.ant.types.selectors.NoneSelector;
import org.apache.tools.ant.types.selectors.NotSelector;
import org.apache.tools.ant.types.selectors.OrSelector;
import org.apache.tools.ant.types.selectors.PresentSelector;
import org.apache.tools.ant.types.selectors.SelectSelector;
import org.apache.tools.ant.types.selectors.SizeSelector;
import org.apache.tools.ant.types.selectors.TypeSelector;
import org.apache.tools.ant.types.selectors.modifiedselector.ModifiedSelector;

public interface SelectorContainer
{
    Enumeration<FileSelector> selectorElements();
    FileSelector[] getSelectors(Project p0);
    boolean hasSelectors();
    int selectorCount();
    void add(FileSelector p0);
    void addAnd(AndSelector p0);
    void addContains(ContainsSelector p0);
    void addContainsRegexp(ContainsRegexpSelector p0);
    void addCustom(ExtendSelector p0);
    void addDate(DateSelector p0);
    void addDepend(DependSelector p0);
    void addDepth(DepthSelector p0);
    void addDifferent(DifferentSelector p0);
    void addFilename(FilenameSelector p0);
    void addMajority(MajoritySelector p0);
    void addModified(ModifiedSelector p0);
    void addNone(NoneSelector p0);
    void addNot(NotSelector p0);
    void addOr(OrSelector p0);
    void addPresent(PresentSelector p0);
    void addSelector(SelectSelector p0);
    void addSize(SizeSelector p0);
    void addType(TypeSelector p0);
    void appendSelector(FileSelector p0);
}
