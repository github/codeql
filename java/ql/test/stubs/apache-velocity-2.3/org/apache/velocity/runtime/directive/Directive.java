// Generated automatically from org.apache.velocity.runtime.directive.Directive for testing purposes

package org.apache.velocity.runtime.directive;

import java.io.Writer;
import java.util.ArrayList;
import org.apache.velocity.Template;
import org.apache.velocity.context.InternalContextAdapter;
import org.apache.velocity.runtime.RuntimeServices;
import org.apache.velocity.runtime.directive.DirectiveConstants;
import org.apache.velocity.runtime.directive.Scope;
import org.apache.velocity.runtime.parser.Token;
import org.apache.velocity.runtime.parser.node.Node;
import org.slf4j.Logger;

abstract public class Directive implements Cloneable, DirectiveConstants
{
    protected Logger log = null;
    protected RuntimeServices rsvc = null;
    protected Scope makeScope(Object p0){ return null; }
    protected void postRender(InternalContextAdapter p0){}
    protected void preRender(InternalContextAdapter p0){}
    public Directive(){}
    public String getScopeName(){ return null; }
    public String getTemplateName(){ return null; }
    public Template getTemplate(){ return null; }
    public abstract String getName();
    public abstract boolean render(InternalContextAdapter p0, Writer p1, Node p2);
    public abstract int getType();
    public boolean isScopeProvided(){ return false; }
    public int getColumn(){ return 0; }
    public int getLine(){ return 0; }
    public void checkArgs(ArrayList<Integer> p0, Token p1, String p2){}
    public void init(RuntimeServices p0, InternalContextAdapter p1, Node p2){}
    public void setLocation(int p0, int p1){}
    public void setLocation(int p0, int p1, Template p2){}
}
