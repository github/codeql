// Generated automatically from org.openhealthtools.mdht.uml.cda.Act for testing purposes

package org.openhealthtools.mdht.uml.cda;

import org.eclipse.emf.common.util.EList;
import org.openhealthtools.mdht.uml.cda.Author;
import org.openhealthtools.mdht.uml.cda.ClinicalStatement;
import org.openhealthtools.mdht.uml.cda.EntryRelationship;
import org.openhealthtools.mdht.uml.cda.Informant12;
import org.openhealthtools.mdht.uml.cda.InfrastructureRootTypeId;
import org.openhealthtools.mdht.uml.cda.Participant2;
import org.openhealthtools.mdht.uml.cda.Performer2;
import org.openhealthtools.mdht.uml.cda.Precondition;
import org.openhealthtools.mdht.uml.cda.Reference;
import org.openhealthtools.mdht.uml.cda.Specimen;
import org.openhealthtools.mdht.uml.cda.Subject;
import org.openhealthtools.mdht.uml.hl7.datatypes.CD;
import org.openhealthtools.mdht.uml.hl7.datatypes.CE;
import org.openhealthtools.mdht.uml.hl7.datatypes.CS;
import org.openhealthtools.mdht.uml.hl7.datatypes.ED;
import org.openhealthtools.mdht.uml.hl7.datatypes.II;
import org.openhealthtools.mdht.uml.hl7.datatypes.IVL_TS;
import org.openhealthtools.mdht.uml.hl7.vocab.NullFlavor;
import org.openhealthtools.mdht.uml.hl7.vocab.x_ActClassDocumentEntryAct;
import org.openhealthtools.mdht.uml.hl7.vocab.x_DocumentActMood;

public interface Act extends ClinicalStatement
{
    Boolean getNegationInd();
    CD getCode();
    CE getPriorityCode();
    CS getLanguageCode();
    CS getStatusCode();
    ED getText();
    EList<Author> getAuthors();
    EList<CS> getRealmCodes();
    EList<EntryRelationship> getEntryRelationships();
    EList<II> getIds();
    EList<II> getTemplateIds();
    EList<Informant12> getInformants();
    EList<Participant2> getParticipants();
    EList<Performer2> getPerformers();
    EList<Precondition> getPreconditions();
    EList<Reference> getReferences();
    EList<Specimen> getSpecimens();
    IVL_TS getEffectiveTime();
    InfrastructureRootTypeId getTypeId();
    NullFlavor getNullFlavor();
    Subject getSubject();
    boolean isSetClassCode();
    boolean isSetMoodCode();
    boolean isSetNegationInd();
    boolean isSetNullFlavor();
    void setClassCode(x_ActClassDocumentEntryAct p0);
    void setCode(CD p0);
    void setEffectiveTime(IVL_TS p0);
    void setLanguageCode(CS p0);
    void setMoodCode(x_DocumentActMood p0);
    void setNegationInd(Boolean p0);
    void setNullFlavor(NullFlavor p0);
    void setPriorityCode(CE p0);
    void setStatusCode(CS p0);
    void setSubject(Subject p0);
    void setText(ED p0);
    void setTypeId(InfrastructureRootTypeId p0);
    void unsetClassCode();
    void unsetMoodCode();
    void unsetNegationInd();
    void unsetNullFlavor();
    x_ActClassDocumentEntryAct getClassCode();
    x_DocumentActMood getMoodCode();
}
