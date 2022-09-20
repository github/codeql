// Generated automatically from org.apache.velocity.runtime.parser.Parser for testing purposes

package org.apache.velocity.runtime.parser;

import java.io.Reader;
import org.apache.velocity.Template;
import org.apache.velocity.runtime.RuntimeServices;
import org.apache.velocity.runtime.directive.Directive;
import org.apache.velocity.runtime.parser.CharStream;
import org.apache.velocity.runtime.parser.Token;
import org.apache.velocity.runtime.parser.node.SimpleNode;

public interface Parser
{
    Directive getDirective(String p0);
    RuntimeServices getRuntimeServices();
    SimpleNode parse(Reader p0, Template p1);
    Template getCurrentTemplate();
    Token getToken(int p0);
    boolean isDirective(String p0);
    char asterisk();
    char at();
    char dollar();
    char hash();
    default String blockComment(){ return null; }
    default String lineComment(){ return null; }
    void ReInit(CharStream p0);
    void resetCurrentTemplate();
}
