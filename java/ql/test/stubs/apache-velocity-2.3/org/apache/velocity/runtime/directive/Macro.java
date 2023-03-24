// Generated automatically from org.apache.velocity.runtime.directive.Macro for testing purposes

package org.apache.velocity.runtime.directive;

import java.io.Writer;
import java.util.ArrayList;
import java.util.List;
import org.apache.velocity.context.InternalContextAdapter;
import org.apache.velocity.runtime.RuntimeServices;
import org.apache.velocity.runtime.directive.Directive;
import org.apache.velocity.runtime.parser.Token;
import org.apache.velocity.runtime.parser.node.Node;

public class Macro extends Directive
{
    public Macro(){}
    public String getName(){ return null; }
    public boolean isScopeProvided(){ return false; }
    public boolean render(InternalContextAdapter p0, Writer p1, Node p2){ return false; }
    public int getType(){ return 0; }
    public static StringBuilder macroToString(StringBuilder p0, List<Macro.MacroArg> p1, RuntimeServices p2){ return null; }
    public void checkArgs(ArrayList<Integer> p0, Token p1, String p2){}
    public void init(RuntimeServices p0, InternalContextAdapter p1, Node p2){}
    static public class MacroArg
    {
        public MacroArg(){}
        public Node defaultVal = null;
        public String name = null;
    }
}
