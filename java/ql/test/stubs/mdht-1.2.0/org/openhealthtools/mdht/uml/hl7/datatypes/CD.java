// Generated automatically from org.openhealthtools.mdht.uml.hl7.datatypes.CD for testing purposes

package org.openhealthtools.mdht.uml.hl7.datatypes;

import org.eclipse.emf.common.util.EList;
import org.openhealthtools.mdht.uml.hl7.datatypes.ANY;
import org.openhealthtools.mdht.uml.hl7.datatypes.CR;
import org.openhealthtools.mdht.uml.hl7.datatypes.ED;

public interface CD extends ANY
{
    ED getOriginalText();
    EList<CD> getTranslations();
    EList<CR> getQualifiers();
    String getCode();
    String getCodeSystem();
    String getCodeSystemName();
    String getCodeSystemVersion();
    String getDisplayName();
    void setCode(String p0);
    void setCodeSystem(String p0);
    void setCodeSystemName(String p0);
    void setCodeSystemVersion(String p0);
    void setDisplayName(String p0);
    void setOriginalText(ED p0);
}
