// Generated automatically from freemarker.core.ParserConfiguration for testing purposes

package freemarker.core;

import freemarker.core.ArithmeticEngine;
import freemarker.core.OutputFormat;
import freemarker.template.Version;

public interface ParserConfiguration
{
    ArithmeticEngine getArithmeticEngine();
    OutputFormat getOutputFormat();
    Version getIncompatibleImprovements();
    boolean getRecognizeStandardFileExtensions();
    boolean getStrictSyntaxMode();
    boolean getWhitespaceStripping();
    int getAutoEscapingPolicy();
    int getInterpolationSyntax();
    int getNamingConvention();
    int getTabSize();
    int getTagSyntax();
}
