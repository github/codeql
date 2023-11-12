// Generated automatically from org.openhealthtools.mdht.uml.hl7.rim.InfrastructureRoot for testing purposes

package org.openhealthtools.mdht.uml.hl7.rim;

import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EObject;
import org.openhealthtools.mdht.uml.hl7.datatypes.CS;
import org.openhealthtools.mdht.uml.hl7.datatypes.II;
import org.openhealthtools.mdht.uml.hl7.vocab.NullFlavor;

public interface InfrastructureRoot extends EObject
{
    EList<CS> getRealmCodes();
    EList<II> getTemplateIds();
    II getTypeId();
    NullFlavor getNullFlavor();
    boolean hasContent();
    boolean isDefined(String p0);
    boolean isNullFlavorDefined();
    boolean isNullFlavorUndefined();
}
