// Generated automatically from org.openhealthtools.mdht.uml.cda.NonXMLBody for testing purposes

package org.openhealthtools.mdht.uml.cda;

import java.util.Map;
import org.eclipse.emf.common.util.DiagnosticChain;
import org.eclipse.emf.common.util.EList;
import org.openhealthtools.mdht.uml.cda.InfrastructureRootTypeId;
import org.openhealthtools.mdht.uml.hl7.datatypes.CE;
import org.openhealthtools.mdht.uml.hl7.datatypes.CS;
import org.openhealthtools.mdht.uml.hl7.datatypes.ED;
import org.openhealthtools.mdht.uml.hl7.datatypes.II;
import org.openhealthtools.mdht.uml.hl7.vocab.ActClass;
import org.openhealthtools.mdht.uml.hl7.vocab.ActMood;
import org.openhealthtools.mdht.uml.hl7.vocab.NullFlavor;

public interface NonXMLBody extends org.openhealthtools.mdht.uml.hl7.rim.Act
{
    ActClass getClassCode();
    ActMood getMoodCode();
    CE getConfidentialityCode();
    CS getLanguageCode();
    ED getText();
    EList<CS> getRealmCodes();
    EList<II> getTemplateIds();
    InfrastructureRootTypeId getTypeId();
    NullFlavor getNullFlavor();
    boolean isSetClassCode();
    boolean isSetMoodCode();
    boolean isSetNullFlavor();
    boolean validateClassCode(DiagnosticChain p0, Map<Object, Object> p1);
    boolean validateMoodCode(DiagnosticChain p0, Map<Object, Object> p1);
    void setClassCode(ActClass p0);
    void setConfidentialityCode(CE p0);
    void setLanguageCode(CS p0);
    void setMoodCode(ActMood p0);
    void setNullFlavor(NullFlavor p0);
    void setText(ED p0);
    void setTypeId(InfrastructureRootTypeId p0);
    void unsetClassCode();
    void unsetMoodCode();
    void unsetNullFlavor();
}
