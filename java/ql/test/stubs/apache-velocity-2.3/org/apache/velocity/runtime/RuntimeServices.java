// Generated automatically from org.apache.velocity.runtime.RuntimeServices for testing purposes

package org.apache.velocity.runtime;

import java.io.Reader;
import java.io.Writer;
import java.util.List;
import java.util.Properties;
import org.apache.velocity.Template;
import org.apache.velocity.app.event.EventCartridge;
import org.apache.velocity.context.Context;
import org.apache.velocity.runtime.ParserConfiguration;
import org.apache.velocity.runtime.RuntimeConstants;
import org.apache.velocity.runtime.directive.Directive;
import org.apache.velocity.runtime.directive.Macro;
import org.apache.velocity.runtime.parser.LogContext;
import org.apache.velocity.runtime.parser.Parser;
import org.apache.velocity.runtime.parser.node.Node;
import org.apache.velocity.runtime.parser.node.SimpleNode;
import org.apache.velocity.runtime.resource.ContentResource;
import org.apache.velocity.util.ExtProperties;
import org.apache.velocity.util.introspection.Uberspect;
import org.slf4j.Logger;

public interface RuntimeServices
{
    ContentResource getContent(String p0);
    ContentResource getContent(String p0, String p1);
    Directive getDirective(String p0);
    Directive getVelocimacro(String p0, Template p1, Template p2);
    EventCartridge getApplicationEventCartridge();
    ExtProperties getConfiguration();
    LogContext getLogContext();
    Logger getLog();
    Logger getLog(String p0);
    Object getApplicationAttribute(Object p0);
    Object getProperty(String p0);
    Object setApplicationAttribute(Object p0, Object p1);
    Parser createNewParser();
    ParserConfiguration getParserConfiguration();
    RuntimeConstants.SpaceGobbling getSpaceGobbling();
    SimpleNode parse(Reader p0, Template p1);
    String getLoaderNameForResource(String p0);
    String getString(String p0);
    String getString(String p0, String p1);
    Template getTemplate(String p0);
    Template getTemplate(String p0, String p1);
    Uberspect getUberspect();
    boolean addVelocimacro(String p0, Node p1, List<Macro.MacroArg> p2, Template p3);
    boolean evaluate(Context p0, Writer p1, String p2, Reader p3);
    boolean evaluate(Context p0, Writer p1, String p2, String p3);
    boolean getBoolean(String p0, boolean p1);
    boolean invokeVelocimacro(String p0, String p1, String[] p2, Context p3, Writer p4);
    boolean isHyphenAllowedInIdentifiers();
    boolean isInitialized();
    boolean isScopeControlEnabled(String p0);
    boolean isVelocimacro(String p0, Template p1);
    boolean useStringInterning();
    int getInt(String p0);
    int getInt(String p0, int p1);
    void addProperty(String p0, Object p1);
    void clearProperty(String p0);
    void init();
    void init(Properties p0);
    void init(String p0);
    void setConfiguration(ExtProperties p0);
    void setProperty(String p0, Object p1);
}
