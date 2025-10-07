// Generated automatically from org.springframework.web.servlet.mvc.support.RedirectAttributes for testing purposes

package org.springframework.web.servlet.mvc.support;

import java.util.Collection;
import java.util.Map;
import org.springframework.ui.Model;

public interface RedirectAttributes extends Model
{
    Map<String, ? extends Object> getFlashAttributes();
    RedirectAttributes addAllAttributes(Collection<? extends Object> p0);
    RedirectAttributes addAttribute(Object p0);
    RedirectAttributes addAttribute(String p0, Object p1);
    RedirectAttributes addFlashAttribute(Object p0);
    RedirectAttributes addFlashAttribute(String p0, Object p1);
    RedirectAttributes mergeAttributes(Map<String, ? extends Object> p0);
}
