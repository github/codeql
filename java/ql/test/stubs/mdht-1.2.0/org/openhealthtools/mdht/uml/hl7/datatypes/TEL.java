// Generated automatically from org.openhealthtools.mdht.uml.hl7.datatypes.TEL for testing purposes

package org.openhealthtools.mdht.uml.hl7.datatypes;

import org.eclipse.emf.common.util.EList;
import org.openhealthtools.mdht.uml.hl7.datatypes.SXCM_TS;
import org.openhealthtools.mdht.uml.hl7.datatypes.URL;
import org.openhealthtools.mdht.uml.hl7.vocab.TelecommunicationAddressUse;

public interface TEL extends URL
{
    EList<SXCM_TS> getUseablePeriods();
    EList<TelecommunicationAddressUse> getUses();
    boolean isSetUses();
    void unsetUses();
}
