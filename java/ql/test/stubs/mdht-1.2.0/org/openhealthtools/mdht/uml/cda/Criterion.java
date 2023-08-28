// Generated automatically from org.openhealthtools.mdht.uml.cda.Criterion for testing purposes

package org.openhealthtools.mdht.uml.cda;

import java.util.Map;
import org.eclipse.emf.common.util.DiagnosticChain;
import org.eclipse.emf.common.util.EList;
import org.openhealthtools.mdht.uml.cda.InfrastructureRootTypeId;
import org.openhealthtools.mdht.uml.hl7.datatypes.ANY;
import org.openhealthtools.mdht.uml.hl7.datatypes.CD;
import org.openhealthtools.mdht.uml.hl7.datatypes.CS;
import org.openhealthtools.mdht.uml.hl7.datatypes.ED;
import org.openhealthtools.mdht.uml.hl7.datatypes.II;
import org.openhealthtools.mdht.uml.hl7.vocab.ActClassObservation;
import org.openhealthtools.mdht.uml.hl7.vocab.ActMood;
import org.openhealthtools.mdht.uml.hl7.vocab.NullFlavor;

public interface Criterion extends org.openhealthtools.mdht.uml.hl7.rim.Act
{
    ANY getValue();
    ActClassObservation getClassCode();
    ActMood getMoodCode();
    CD getCode();
    ED getText();
    EList<CS> getRealmCodes();
    EList<II> getTemplateIds();
    InfrastructureRootTypeId getTypeId();
    NullFlavor getNullFlavor();
    boolean isSetClassCode();
    boolean isSetMoodCode();
    boolean isSetNullFlavor();
    boolean validateMoodCode(DiagnosticChain p0, Map<Object, Object> p1);
    void setClassCode(ActClassObservation p0);
    void setCode(CD p0);
    void setMoodCode(ActMood p0);
    void setNullFlavor(NullFlavor p0);
    void setText(ED p0);
    void setTypeId(InfrastructureRootTypeId p0);
    void setValue(ANY p0);
    void unsetClassCode();
    void unsetMoodCode();
    void unsetNullFlavor();
}
