// Generated automatically from org.thymeleaf.inline.IInliner for testing purposes

package org.thymeleaf.inline;

import org.thymeleaf.context.ITemplateContext;
import org.thymeleaf.model.ICDATASection;
import org.thymeleaf.model.IComment;
import org.thymeleaf.model.IText;

public interface IInliner
{
    CharSequence inline(ITemplateContext p0, ICDATASection p1);
    CharSequence inline(ITemplateContext p0, IComment p1);
    CharSequence inline(ITemplateContext p0, IText p1);
    String getName();
}
