// Generated automatically from freemarker.core.Environment for testing purposes

package freemarker.core;

import freemarker.core.Configurable;
import freemarker.core.DirectiveCallPlace;
import freemarker.core.TemplateDateFormat;
import freemarker.core.TemplateElement;
import freemarker.core.TemplateNumberFormat;
import freemarker.template.Configuration;
import freemarker.template.SimpleHash;
import freemarker.template.Template;
import freemarker.template.TemplateDirectiveModel;
import freemarker.template.TemplateExceptionHandler;
import freemarker.template.TemplateHashModel;
import freemarker.template.TemplateModel;
import freemarker.template.TemplateNodeModel;
import java.io.PrintWriter;
import java.io.Writer;
import java.text.NumberFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.TimeZone;

public class Environment extends Configurable
{
    protected Environment() {}
    public Configuration getConfiguration(){ return null; }
    public DirectiveCallPlace getCurrentDirectiveCallPlace(){ return null; }
    public Environment(Template p0, TemplateHashModel p1, Writer p2){}
    public Environment.Namespace getCurrentNamespace(){ return null; }
    public Environment.Namespace getGlobalNamespace(){ return null; }
    public Environment.Namespace getMainNamespace(){ return null; }
    public Environment.Namespace getNamespace(String p0){ return null; }
    public Environment.Namespace importLib(String p0, String p1){ return null; }
    public Environment.Namespace importLib(String p0, String p1, boolean p2){ return null; }
    public Environment.Namespace importLib(Template p0, String p1){ return null; }
    public NumberFormat getCNumberFormat(){ return null; }
    public Object __getitem__(String p0){ return null; }
    public Object getCustomState(Object p0){ return null; }
    public Object setCustomState(Object p0, Object p1){ return null; }
    public Set getKnownVariableNames(){ return null; }
    public String getDefaultNS(){ return null; }
    public String getNamespaceForPrefix(String p0){ return null; }
    public String getPrefixForNamespace(String p0){ return null; }
    public String rootBasedToAbsoluteTemplateName(String p0){ return null; }
    public String toFullTemplateName(String p0, String p1){ return null; }
    public Template getCurrentTemplate(){ return null; }
    public Template getMainTemplate(){ return null; }
    public Template getTemplate(){ return null; }
    public Template getTemplateForImporting(String p0){ return null; }
    public Template getTemplateForInclusion(String p0, String p1, boolean p2){ return null; }
    public Template getTemplateForInclusion(String p0, String p1, boolean p2, boolean p3){ return null; }
    public TemplateDateFormat getTemplateDateFormat(String p0, int p1, Class<? extends Date> p2){ return null; }
    public TemplateDateFormat getTemplateDateFormat(String p0, int p1, Class<? extends Date> p2, Locale p3){ return null; }
    public TemplateDateFormat getTemplateDateFormat(String p0, int p1, Class<? extends Date> p2, Locale p3, TimeZone p4, TimeZone p5){ return null; }
    public TemplateDateFormat getTemplateDateFormat(String p0, int p1, Locale p2, TimeZone p3, boolean p4){ return null; }
    public TemplateDateFormat getTemplateDateFormat(int p0, Class<? extends Date> p1){ return null; }
    public TemplateHashModel getDataModel(){ return null; }
    public TemplateHashModel getGlobalVariables(){ return null; }
    public TemplateModel getDataModelOrSharedVariable(String p0){ return null; }
    public TemplateModel getGlobalVariable(String p0){ return null; }
    public TemplateModel getLocalVariable(String p0){ return null; }
    public TemplateModel getVariable(String p0){ return null; }
    public TemplateNodeModel getCurrentVisitorNode(){ return null; }
    public TemplateNumberFormat getTemplateNumberFormat(){ return null; }
    public TemplateNumberFormat getTemplateNumberFormat(String p0){ return null; }
    public TemplateNumberFormat getTemplateNumberFormat(String p0, Locale p1){ return null; }
    public Writer getOut(){ return null; }
    public boolean applyEqualsOperator(TemplateModel p0, TemplateModel p1){ return false; }
    public boolean applyEqualsOperatorLenient(TemplateModel p0, TemplateModel p1){ return false; }
    public boolean applyGreaterThanOperator(TemplateModel p0, TemplateModel p1){ return false; }
    public boolean applyLessThanOperator(TemplateModel p0, TemplateModel p1){ return false; }
    public boolean applyLessThanOrEqualsOperator(TemplateModel p0, TemplateModel p1){ return false; }
    public boolean applyWithGreaterThanOrEqualsOperator(TemplateModel p0, TemplateModel p1){ return false; }
    public boolean isInAttemptBlock(){ return false; }
    public class Namespace extends SimpleHash
    {
        public Template getTemplate(){ return null; }
    }
    public static Environment getCurrentEnvironment(){ return null; }
    public void __setitem__(String p0, Object p1){}
    public void include(String p0, String p1, boolean p2){}
    public void include(Template p0){}
    public void outputInstructionStack(PrintWriter p0){}
    public void process(){}
    public void setCurrentVisitorNode(TemplateNodeModel p0){}
    public void setDateFormat(String p0){}
    public void setDateTimeFormat(String p0){}
    public void setGlobalVariable(String p0, TemplateModel p1){}
    public void setLocalVariable(String p0, TemplateModel p1){}
    public void setLocale(Locale p0){}
    public void setNumberFormat(String p0){}
    public void setOut(Writer p0){}
    public void setOutputEncoding(String p0){}
    public void setSQLDateAndTimeTimeZone(TimeZone p0){}
    public void setTemplateExceptionHandler(TemplateExceptionHandler p0){}
    public void setTimeFormat(String p0){}
    public void setTimeZone(TimeZone p0){}
    public void setURLEscapingCharset(String p0){}
    public void setVariable(String p0, TemplateModel p1){}
    public void visit(TemplateElement p0, TemplateDirectiveModel p1, Map p2, List p3){}
}
