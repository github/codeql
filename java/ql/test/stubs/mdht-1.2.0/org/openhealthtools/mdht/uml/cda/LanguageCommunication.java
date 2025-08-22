// Generated automatically from org.openhealthtools.mdht.uml.cda.LanguageCommunication for testing purposes

package org.openhealthtools.mdht.uml.cda;

import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EObject;
import org.openhealthtools.mdht.uml.cda.InfrastructureRootTypeId;
import org.openhealthtools.mdht.uml.hl7.datatypes.BL;
import org.openhealthtools.mdht.uml.hl7.datatypes.CE;
import org.openhealthtools.mdht.uml.hl7.datatypes.CS;
import org.openhealthtools.mdht.uml.hl7.datatypes.II;
import org.openhealthtools.mdht.uml.hl7.vocab.NullFlavor;

public interface LanguageCommunication extends EObject
{
    BL getPreferenceInd();
    CE getModeCode();
    CE getProficiencyLevelCode();
    CS getLanguageCode();
    EList<CS> getRealmCodes();
    EList<II> getTemplateIds();
    InfrastructureRootTypeId getTypeId();
    NullFlavor getNullFlavor();
    boolean isSetNullFlavor();
    void setLanguageCode(CS p0);
    void setModeCode(CE p0);
    void setNullFlavor(NullFlavor p0);
    void setPreferenceInd(BL p0);
    void setProficiencyLevelCode(CE p0);
    void setTypeId(InfrastructureRootTypeId p0);
    void unsetNullFlavor();
}
