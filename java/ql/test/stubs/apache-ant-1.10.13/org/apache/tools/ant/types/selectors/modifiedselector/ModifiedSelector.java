// Generated automatically from org.apache.tools.ant.types.selectors.modifiedselector.ModifiedSelector for testing purposes

package org.apache.tools.ant.types.selectors.modifiedselector;

import java.io.File;
import java.util.Comparator;
import org.apache.tools.ant.BuildEvent;
import org.apache.tools.ant.BuildListener;
import org.apache.tools.ant.types.EnumeratedAttribute;
import org.apache.tools.ant.types.Parameter;
import org.apache.tools.ant.types.Path;
import org.apache.tools.ant.types.Resource;
import org.apache.tools.ant.types.resources.selectors.ResourceSelector;
import org.apache.tools.ant.types.selectors.BaseExtendSelector;
import org.apache.tools.ant.types.selectors.modifiedselector.Algorithm;
import org.apache.tools.ant.types.selectors.modifiedselector.Cache;

public class ModifiedSelector extends BaseExtendSelector implements BuildListener, ResourceSelector
{
    protected <T> T loadClass(String p0, String p1, java.lang.Class<? extends T> p2){ return null; }
    protected void saveCache(){}
    protected void tryToSetAParameter(Object p0, String p1, String p2){}
    public Algorithm getAlgorithm(){ return null; }
    public Cache getCache(){ return null; }
    public ClassLoader getClassLoader(){ return null; }
    public Comparator<? super String> getComparator(){ return null; }
    public ModifiedSelector(){}
    public String toString(){ return null; }
    public boolean getDelayUpdate(){ return false; }
    public boolean isSelected(File p0, String p1, File p2){ return false; }
    public boolean isSelected(Resource p0){ return false; }
    public int getModified(){ return 0; }
    public void addClasspath(Path p0){}
    public void addParam(Parameter p0){}
    public void addParam(String p0, Object p1){}
    public void buildFinished(BuildEvent p0){}
    public void buildStarted(BuildEvent p0){}
    public void configure(){}
    public void messageLogged(BuildEvent p0){}
    public void setAlgorithm(ModifiedSelector.AlgorithmName p0){}
    public void setAlgorithmClass(String p0){}
    public void setCache(ModifiedSelector.CacheName p0){}
    public void setCacheClass(String p0){}
    public void setClassLoader(ClassLoader p0){}
    public void setComparator(ModifiedSelector.ComparatorName p0){}
    public void setComparatorClass(String p0){}
    public void setDelayUpdate(boolean p0){}
    public void setModified(int p0){}
    public void setParameters(Parameter... p0){}
    public void setSeldirs(boolean p0){}
    public void setSelres(boolean p0){}
    public void setUpdate(boolean p0){}
    public void targetFinished(BuildEvent p0){}
    public void targetStarted(BuildEvent p0){}
    public void taskFinished(BuildEvent p0){}
    public void taskStarted(BuildEvent p0){}
    public void useParameter(Parameter p0){}
    public void verifySettings(){}
    static public class AlgorithmName extends EnumeratedAttribute
    {
        public AlgorithmName(){}
        public String[] getValues(){ return null; }
    }
    static public class CacheName extends EnumeratedAttribute
    {
        public CacheName(){}
        public String[] getValues(){ return null; }
    }
    static public class ComparatorName extends EnumeratedAttribute
    {
        public ComparatorName(){}
        public String[] getValues(){ return null; }
    }
}
