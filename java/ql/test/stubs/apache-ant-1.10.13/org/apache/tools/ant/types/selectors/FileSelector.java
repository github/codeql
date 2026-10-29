// Generated automatically from org.apache.tools.ant.types.selectors.FileSelector for testing purposes

package org.apache.tools.ant.types.selectors;

import java.io.File;
import org.apache.tools.ant.types.Resource;
import org.apache.tools.ant.types.resources.selectors.ResourceSelector;

public interface FileSelector extends ResourceSelector
{
    boolean isSelected(File p0, String p1, File p2);
    default boolean isSelected(Resource p0){ return false; }
}
