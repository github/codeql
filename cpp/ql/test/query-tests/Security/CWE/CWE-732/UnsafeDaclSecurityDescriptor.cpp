// semmle-extractor-options: --microsoft
typedef unsigned long       DWORD;
typedef unsigned long       ULONG;
typedef unsigned char       BYTE;
typedef unsigned short      WORD;
typedef int                 BOOL;
typedef void                *PVOID;
#define TRUE                1
#define FALSE               0
#define ERROR_SUCCESS       0L
#define NULL                0

typedef PVOID PSECURITY_DESCRIPTOR;

typedef struct _ACL {
    BYTE  AclRevision;
    BYTE  Sbz1;
    WORD   AclSize;
    WORD   AceCount;
    WORD   Sbz2;
} ACL;
typedef ACL *PACL;

typedef enum _ACCESS_MODE
{
    NOT_USED_ACCESS = 0,
    GRANT_ACCESS,
    SET_ACCESS,
    DENY_ACCESS,
    REVOKE_ACCESS,
    SET_AUDIT_SUCCESS,
    SET_AUDIT_FAILURE
} ACCESS_MODE;

typedef int TRUSTEE_W;

typedef struct _EXPLICIT_ACCESS_W
{
    DWORD        grfAccessPermissions;
    ACCESS_MODE  grfAccessMode;
    DWORD        grfInheritance;
    TRUSTEE_W    Trustee;
} EXPLICIT_ACCESS_W, *PEXPLICIT_ACCESS_W, EXPLICIT_ACCESSW, *PEXPLICIT_ACCESSW;

BOOL
SetSecurityDescriptorDacl(
    PSECURITY_DESCRIPTOR pSecurityDescriptor,
    BOOL bDaclPresent,
    PACL pDacl,
    BOOL bDaclDefaulted
) {
    return TRUE;
}

DWORD SetEntriesInAcl(
    ULONG              cCountOfExplicitEntries,
    PEXPLICIT_ACCESS_W pListOfExplicitEntries,
    PACL               OldAcl,
    PACL               *NewAcl
)
{
    *NewAcl = (PACL)0xFFFFFF;
    return ERROR_SUCCESS;
}

void Test()
{
    PSECURITY_DESCRIPTOR pSecurityDescriptor;
    BOOL b;
    b = SetSecurityDescriptorDacl(pSecurityDescriptor,
        TRUE,       // Dacl Present
        NULL,       // NULL pointer to DACL  == BUG
        FALSE);

    PACL pDacl = NULL;
    b = SetSecurityDescriptorDacl(pSecurityDescriptor,
        TRUE,       // Dacl Present
        pDacl,      // NULL pointer to DACL  == BUG
        FALSE);

    SetEntriesInAcl(0, NULL, NULL, &pDacl);
    b = SetSecurityDescriptorDacl(pSecurityDescriptor,
        TRUE,       // Dacl Present
        pDacl,      // Should have been set by SetEntriesInAcl ==> should not be flagged
        FALSE);

    b = SetSecurityDescriptorDacl(pSecurityDescriptor,
        FALSE,      // Dacl is not Present
        NULL,       // DACL is going to be removed from security descriptor. Default/inherited access ==> should not be flagged
        FALSE);

}

PACL returnUnknownAcl();

PACL returnNull() {
  return NULL;
}

PACL returnMaybeAcl(bool b) {
  PACL pDacl = NULL;
  if (b) {
    SetEntriesInAcl(0, NULL, NULL, &pDacl);
  }
  return pDacl;
}

void Test2()
{
    PSECURITY_DESCRIPTOR pSecurityDescriptor;

    PACL pDacl1 = returnUnknownAcl();
    SetSecurityDescriptorDacl(
        pSecurityDescriptor,
        TRUE,       // Dacl Present
        pDacl1,     // Give `returnUnknownAcl` the benefit of the doubt ==> should not be flagged
        FALSE);

    PACL pDacl2 = returnNull();
    SetSecurityDescriptorDacl(
        pSecurityDescriptor,
        TRUE,       // Dacl Present
        pDacl2,     // NULL pointer to DACL  == BUG
        FALSE);

    PACL pDacl3 = returnMaybeAcl(true);
    SetSecurityDescriptorDacl(
        pSecurityDescriptor,
        TRUE,       // Dacl Present
        pDacl3,     // should not be flagged
        FALSE);
}
