// Generated automatically from freemarker.template.Template for testing purposes

package freemarker.template;

import freemarker.core.Configurable;
import freemarker.core.Environment;
import freemarker.core.LibraryLoad;
import freemarker.core.Macro;
import freemarker.core.OutputFormat;
import freemarker.core.ParserConfiguration;
import freemarker.core.TemplateElement;
import freemarker.template.Configuration;
import freemarker.template.ObjectWrapper;
import freemarker.template.TemplateNodeModel;
import java.io.PrintStream;
import java.io.Reader;
import java.io.Writer;
import java.util.List;
import java.util.Map;
import javax.swing.tree.TreePath;

public class Template extends Configurable
{
    protected Template() {}
    public Configuration getConfiguration(){ return null; }
    public Environment createProcessingEnvironment(Object p0, Writer p1){ return null; }
    public Environment createProcessingEnvironment(Object p0, Writer p1, ObjectWrapper p2){ return null; }
    public List getImports(){ return null; }
    public Map getMacros(){ return null; }
    public Object getCustomLookupCondition(){ return null; }
    public OutputFormat getOutputFormat(){ return null; }
    public ParserConfiguration getParserConfiguration(){ return null; }
    public String getDefaultNS(){ return null; }
    public String getEncoding(){ return null; }
    public String getName(){ return null; }
    public String getNamespaceForPrefix(String p0){ return null; }
    public String getPrefixForNamespace(String p0){ return null; }
    public String getPrefixedName(String p0, String p1){ return null; }
    public String getSource(int p0, int p1, int p2, int p3){ return null; }
    public String getSourceName(){ return null; }
    public String toString(){ return null; }
    public Template(String p0, Reader p1){}
    public Template(String p0, Reader p1, Configuration p2){}
    public Template(String p0, Reader p1, Configuration p2, String p3){}
    public Template(String p0, String p1, Configuration p2){}
    public Template(String p0, String p1, Reader p2, Configuration p3){}
    public Template(String p0, String p1, Reader p2, Configuration p3, ParserConfiguration p4, String p5){}
    public Template(String p0, String p1, Reader p2, Configuration p3, String p4){}
    public TemplateElement getRootTreeNode(){ return null; }
    public TreePath containingElements(int p0, int p1){ return null; }
    public boolean getAutoEscaping(){ return false; }
    public int getActualNamingConvention(){ return 0; }
    public int getActualTagSyntax(){ return 0; }
    public int getInterpolationSyntax(){ return 0; }
    public static String DEFAULT_NAMESPACE_PREFIX = null;
    public static String NO_NS_PREFIX = null;
    public static Template getPlainTextTemplate(String p0, String p1, Configuration p2){ return null; }
    public static Template getPlainTextTemplate(String p0, String p1, String p2, Configuration p3){ return null; }
    public void addImport(LibraryLoad p0){}
    public void addMacro(Macro p0){}
    public void addPrefixNSMapping(String p0, String p1){}
    public void dump(PrintStream p0){}
    public void dump(Writer p0){}
    public void process(Object p0, Writer p1){}
    public void process(Object p0, Writer p1, ObjectWrapper p2){}
    public void process(Object p0, Writer p1, ObjectWrapper p2, TemplateNodeModel p3){}
    public void setCustomLookupCondition(Object p0){}
    public void setEncoding(String p0){}
}
