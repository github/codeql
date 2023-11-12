// Generated automatically from org.openhealthtools.mdht.uml.cda.Organizer for testing purposes

package org.openhealthtools.mdht.uml.cda;

import org.eclipse.emf.common.util.EList;
import org.openhealthtools.mdht.uml.cda.Author;
import org.openhealthtools.mdht.uml.cda.ClinicalStatement;
import org.openhealthtools.mdht.uml.cda.Component4;
import org.openhealthtools.mdht.uml.cda.Informant12;
import org.openhealthtools.mdht.uml.cda.InfrastructureRootTypeId;
import org.openhealthtools.mdht.uml.cda.Participant2;
import org.openhealthtools.mdht.uml.cda.Performer2;
import org.openhealthtools.mdht.uml.cda.Precondition;
import org.openhealthtools.mdht.uml.cda.Reference;
import org.openhealthtools.mdht.uml.cda.Specimen;
import org.openhealthtools.mdht.uml.cda.Subject;
import org.openhealthtools.mdht.uml.hl7.datatypes.CD;
import org.openhealthtools.mdht.uml.hl7.datatypes.CS;
import org.openhealthtools.mdht.uml.hl7.datatypes.II;
import org.openhealthtools.mdht.uml.hl7.datatypes.IVL_TS;
import org.openhealthtools.mdht.uml.hl7.vocab.ActMood;
import org.openhealthtools.mdht.uml.hl7.vocab.NullFlavor;
import org.openhealthtools.mdht.uml.hl7.vocab.x_ActClassDocumentEntryOrganizer;

public interface Organizer extends ClinicalStatement
{
    ActMood getMoodCode();
    CD getCode();
    CS getStatusCode();
    EList<Author> getAuthors();
    EList<CS> getRealmCodes();
    EList<Component4> getComponents();
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
    boolean isSetNullFlavor();
    void addOrganizer(Organizer p0);
    void setClassCode(x_ActClassDocumentEntryOrganizer p0);
    void setCode(CD p0);
    void setEffectiveTime(IVL_TS p0);
    void setMoodCode(ActMood p0);
    void setNullFlavor(NullFlavor p0);
    void setStatusCode(CS p0);
    void setSubject(Subject p0);
    void setTypeId(InfrastructureRootTypeId p0);
    void unsetClassCode();
    void unsetMoodCode();
    void unsetNullFlavor();
    x_ActClassDocumentEntryOrganizer getClassCode();
}
