// Generated automatically from org.thymeleaf.engine.IThrottledTemplateWriterControl for testing purposes

package org.thymeleaf.engine;


public interface IThrottledTemplateWriterControl
{
    boolean isOverflown();
    boolean isStopped();
    int getMaxOverflowSize();
    int getOverflowGrowCount();
    int getWrittenCount();
}
