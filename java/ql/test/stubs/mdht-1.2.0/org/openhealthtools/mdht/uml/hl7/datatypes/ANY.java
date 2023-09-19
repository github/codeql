// Generated automatically from org.openhealthtools.mdht.uml.hl7.datatypes.ANY for testing purposes

package org.openhealthtools.mdht.uml.hl7.datatypes;

import org.eclipse.emf.ecore.EObject;
import org.openhealthtools.mdht.uml.hl7.vocab.NullFlavor;

public interface ANY extends EObject
{
    NullFlavor getNullFlavor();
    boolean hasContent();
    boolean isDefined(String p0);
    boolean isNullFlavorDefined();
    boolean isNullFlavorUndefined();
    boolean isSetNullFlavor();
    boolean matches(String p0, String p1);
    void setNullFlavor(NullFlavor p0);
    void unsetNullFlavor();
}
