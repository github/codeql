// Generated automatically from org.openhealthtools.mdht.uml.cda.Order for testing purposes

package org.openhealthtools.mdht.uml.cda;

import java.util.Map;
import org.eclipse.emf.common.util.DiagnosticChain;
import org.eclipse.emf.common.util.EList;
import org.openhealthtools.mdht.uml.cda.InfrastructureRootTypeId;
import org.openhealthtools.mdht.uml.hl7.datatypes.CE;
import org.openhealthtools.mdht.uml.hl7.datatypes.CS;
import org.openhealthtools.mdht.uml.hl7.datatypes.II;
import org.openhealthtools.mdht.uml.hl7.vocab.ActClassRoot;
import org.openhealthtools.mdht.uml.hl7.vocab.ActMood;
import org.openhealthtools.mdht.uml.hl7.vocab.NullFlavor;

public interface Order extends org.openhealthtools.mdht.uml.hl7.rim.Act
{
    ActClassRoot getClassCode();
    ActMood getMoodCode();
    CE getCode();
    CE getPriorityCode();
    EList<CS> getRealmCodes();
    EList<II> getIds();
    EList<II> getTemplateIds();
    InfrastructureRootTypeId getTypeId();
    NullFlavor getNullFlavor();
    boolean isSetClassCode();
    boolean isSetMoodCode();
    boolean isSetNullFlavor();
    boolean validateMoodCode(DiagnosticChain p0, Map<Object, Object> p1);
    void setClassCode(ActClassRoot p0);
    void setCode(CE p0);
    void setMoodCode(ActMood p0);
    void setNullFlavor(NullFlavor p0);
    void setPriorityCode(CE p0);
    void setTypeId(InfrastructureRootTypeId p0);
    void unsetClassCode();
    void unsetMoodCode();
    void unsetNullFlavor();
}
