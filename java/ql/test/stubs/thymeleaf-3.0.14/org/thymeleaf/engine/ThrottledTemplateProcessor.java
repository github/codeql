// Generated automatically from org.thymeleaf.engine.ThrottledTemplateProcessor for testing purposes

package org.thymeleaf.engine;

import java.io.OutputStream;
import java.io.Writer;
import java.nio.charset.Charset;
import org.thymeleaf.IThrottledTemplateProcessor;
import org.thymeleaf.TemplateSpec;
import org.thymeleaf.engine.IThrottledTemplateWriterControl;

public class ThrottledTemplateProcessor implements IThrottledTemplateProcessor
{
    protected ThrottledTemplateProcessor() {}
    public IThrottledTemplateWriterControl getThrottledTemplateWriterControl(){ return null; }
    public String getProcessorIdentifier(){ return null; }
    public TemplateSpec getTemplateSpec(){ return null; }
    public boolean isFinished(){ return false; }
    public int process(int p0, OutputStream p1, Charset p2){ return 0; }
    public int process(int p0, Writer p1){ return 0; }
    public int processAll(OutputStream p0, Charset p1){ return 0; }
    public int processAll(Writer p0){ return 0; }
}
