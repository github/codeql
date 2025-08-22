// Generated automatically from org.openhealthtools.mdht.uml.cda.Author for testing purposes

package org.openhealthtools.mdht.uml.cda;

import java.util.Map;
import org.eclipse.emf.common.util.DiagnosticChain;
import org.eclipse.emf.common.util.EList;
import org.openhealthtools.mdht.uml.cda.AssignedAuthor;
import org.openhealthtools.mdht.uml.cda.ClinicalDocument;
import org.openhealthtools.mdht.uml.cda.InfrastructureRootTypeId;
import org.openhealthtools.mdht.uml.hl7.datatypes.CE;
import org.openhealthtools.mdht.uml.hl7.datatypes.CS;
import org.openhealthtools.mdht.uml.hl7.datatypes.II;
import org.openhealthtools.mdht.uml.hl7.datatypes.TS;
import org.openhealthtools.mdht.uml.hl7.rim.Participation;
import org.openhealthtools.mdht.uml.hl7.vocab.ContextControl;
import org.openhealthtools.mdht.uml.hl7.vocab.NullFlavor;
import org.openhealthtools.mdht.uml.hl7.vocab.ParticipationType;

public interface Author extends Participation
{
    AssignedAuthor getAssignedAuthor();
    CE getFunctionCode();
    ClinicalDocument getClinicalDocument();
    ContextControl getContextControlCode();
    EList<CS> getRealmCodes();
    EList<II> getTemplateIds();
    InfrastructureRootTypeId getTypeId();
    NullFlavor getNullFlavor();
    ParticipationType getTypeCode();
    TS getTime();
    boolean isSetContextControlCode();
    boolean isSetNullFlavor();
    boolean isSetTypeCode();
    boolean validateContextControlCode(DiagnosticChain p0, Map<Object, Object> p1);
    boolean validateTypeCode(DiagnosticChain p0, Map<Object, Object> p1);
    void setAssignedAuthor(AssignedAuthor p0);
    void setContextControlCode(ContextControl p0);
    void setFunctionCode(CE p0);
    void setNullFlavor(NullFlavor p0);
    void setTime(TS p0);
    void setTypeCode(ParticipationType p0);
    void setTypeId(InfrastructureRootTypeId p0);
    void unsetContextControlCode();
    void unsetNullFlavor();
    void unsetTypeCode();
}
