// Generated automatically from org.thymeleaf.IThrottledTemplateProcessor for testing purposes

package org.thymeleaf;

import java.io.OutputStream;
import java.io.Writer;
import java.nio.charset.Charset;
import org.thymeleaf.TemplateSpec;

public interface IThrottledTemplateProcessor
{
    String getProcessorIdentifier();
    TemplateSpec getTemplateSpec();
    boolean isFinished();
    int process(int p0, OutputStream p1, Charset p2);
    int process(int p0, Writer p1);
    int processAll(OutputStream p0, Charset p1);
    int processAll(Writer p0);
}
