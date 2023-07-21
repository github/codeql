// Generated automatically from org.apache.tools.ant.types.DataType for testing purposes

package org.apache.tools.ant.types;

import java.util.Stack;
import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.Project;
import org.apache.tools.ant.ProjectComponent;
import org.apache.tools.ant.types.Reference;

abstract public class DataType extends ProjectComponent implements Cloneable
{
    protected <T> T getCheckedRef(){ return null; }
    protected <T> T getCheckedRef(Project p0){ return null; }
    protected <T> T getCheckedRef(java.lang.Class<T> p0){ return null; }
    protected <T> T getCheckedRef(java.lang.Class<T> p0, String p1){ return null; }
    protected <T> T getCheckedRef(java.lang.Class<T> p0, String p1, Project p2){ return null; }
    protected BuildException circularReference(){ return null; }
    protected BuildException noChildrenAllowed(){ return null; }
    protected BuildException tooManyAttributes(){ return null; }
    protected Reference ref = null;
    protected String getDataTypeName(){ return null; }
    protected boolean checked = false;
    protected boolean isChecked(){ return false; }
    protected void checkAttributesAllowed(){}
    protected void checkChildrenAllowed(){}
    protected void dieOnCircularReference(){}
    protected void dieOnCircularReference(Project p0){}
    protected void dieOnCircularReference(Stack<Object> p0, Project p1){}
    protected void setChecked(boolean p0){}
    public DataType(){}
    public Object clone(){ return null; }
    public Reference getRefid(){ return null; }
    public String toString(){ return null; }
    public boolean isReference(){ return false; }
    public static void invokeCircularReferenceCheck(DataType p0, Stack<Object> p1, Project p2){}
    public static void pushAndInvokeCircularReferenceCheck(DataType p0, Stack<Object> p1, Project p2){}
    public void setRefid(Reference p0){}
}
