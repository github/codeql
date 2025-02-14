typedef unsigned long ULONG;
typedef unsigned short USHORT;
typedef unsigned long       DWORD;
typedef long NTSTATUS;
#define STATUS_INVALID_PARAMETER         ((DWORD   )0xC000000DL)    

typedef enum {
    PmiMeasurementConfiguration,
    PmiBudgetingConfiguration,
    PmiThresholdConfiguration,
    PmiConfigurationMax
} PMI_CONFIGURATION_TYPE;

typedef struct _PMI_CONFIGURATION {
    ULONG Version;
    USHORT Size;
    PMI_CONFIGURATION_TYPE ConfigurationType;
} PMI_CONFIGURATION, *PPMI_CONFIGURATION;

typedef
NTSTATUS
PMI_CONFIGURATION_TO_ACPI(
    ULONG something
);

typedef
NTSTATUS
PMI_ACPI_TO_CAPABILITIES(
    ULONG something
);

typedef PMI_ACPI_TO_CAPABILITIES *PPMI_ACPI_TO_CAPABILITIES;

NTSTATUS
AcpiPmipBuildReportedCapabilities(
    ULONG something
) {
    return 0;
}

NTSTATUS
AcpiPmipBuildMeteredHardwareInformation(
    ULONG something
) {
    return 0;
}

typedef enum {
    PmiReportedCapabilities,
    PmiMeteredHardware,
    PmiCapabilitiesMax
} PMI_CAPABILITIES_TYPE;

PPMI_ACPI_TO_CAPABILITIES PmiAcpiToCapabilities[PmiCapabilitiesMax] = {
    AcpiPmipBuildReportedCapabilities,        // PmiReportedCapabilities 
    AcpiPmipBuildMeteredHardwareInformation,  // PmiMeteredHardware
};

typedef struct _PMI_CAPABILITIES {
    ULONG Version;
    ULONG Size;
    PMI_CAPABILITIES_TYPE CapabilityType;
} PMI_CAPABILITIES, *PPMI_CAPABILITIES;

NTSTATUS Test_NoLowerBoundCheckUsageAfterIfBlock(PPMI_CAPABILITIES PmiCapabilitiesInput)
{
    NTSTATUS Status = 0;
    int CapabilityType;

    CapabilityType = PmiCapabilitiesInput->CapabilityType;
    if (CapabilityType >= PmiCapabilitiesMax)
    {
        Status = STATUS_INVALID_PARAMETER;
        goto IoctlGetCapabilitiesExit;
    }
    // ...
    PmiAcpiToCapabilities[CapabilityType](0);    // BUG

IoctlGetCapabilitiesExit:
    return Status;
}

// If it fires == false positive
// unsigned type
NTSTATUS Test_NoLowerBoundCheckUsageAfterIfBlock_FP(PPMI_CAPABILITIES PmiCapabilitiesInput)
{
    NTSTATUS Status = 0;
    PMI_CAPABILITIES_TYPE CapabilityType;

    CapabilityType = PmiCapabilitiesInput->CapabilityType;
    if (CapabilityType >= PmiCapabilitiesMax)
    {
        Status = STATUS_INVALID_PARAMETER;
        goto IoctlGetCapabilitiesExit;
    }
    // ...
    PmiAcpiToCapabilities[CapabilityType](0);  // NOT A BUG, CapabilityType is unsigned

IoctlGetCapabilitiesExit:
    return Status;
}

NTSTATUS Test_NoLowerBoundCheckUsageWithinIfBlock(PPMI_CAPABILITIES PmiCapabilitiesInput)
{
    NTSTATUS Status = 0;
    int CapabilityType;

    CapabilityType = PmiCapabilitiesInput->CapabilityType;
    if (CapabilityType < PmiCapabilitiesMax)
    {
        PmiAcpiToCapabilities[CapabilityType](1);  // BUG
    }
    else
    {
        Status = STATUS_INVALID_PARAMETER;
        goto IoctlGetCapabilitiesExit;
    }
    // ...

IoctlGetCapabilitiesExit:
    return Status;
}

// Should not fire an event as this doesn't meet the criteria
// CapabilityType is unsigned, so it will never be < 0
// If it fires == false positive
NTSTATUS Test_NoLowerBoundCheckUsageWithinIfBlock_FP(PPMI_CAPABILITIES PmiCapabilitiesInput)
{
    NTSTATUS Status = 0;
    PMI_CAPABILITIES_TYPE CapabilityType;

    CapabilityType = PmiCapabilitiesInput->CapabilityType;
    if (CapabilityType < PmiCapabilitiesMax)
    {
        PmiAcpiToCapabilities[CapabilityType](1);  // NOT A BUG, CapabilityType is unsigned
    }
    else
    {
        Status = STATUS_INVALID_PARAMETER;
        goto IoctlGetCapabilitiesExit;
    }
    // ...

IoctlGetCapabilitiesExit:
    return Status;
}

// Should not fire an event as this doesn't meet the criteria
// If it fires == false positive
NTSTATUS Test_NotMeetingUpperboundCheckCritieria(PPMI_CAPABILITIES PmiCapabilitiesInput)
{
    NTSTATUS Status = 0;
    PMI_CAPABILITIES_TYPE CapabilityType;

    CapabilityType = PmiCapabilitiesInput->CapabilityType;
    if (CapabilityType == PmiMeteredHardware)
    {
        PmiAcpiToCapabilities[CapabilityType](1);
    }
    else
    {
        Status = STATUS_INVALID_PARAMETER;
        goto IoctlGetCapabilitiesExit;
    }
    // ...

IoctlGetCapabilitiesExit:
    return Status;
}

// No bug - Correct Usage
NTSTATUS Test_CorrectUsage(PPMI_CAPABILITIES PmiCapabilitiesInput)
{
    NTSTATUS Status = 0;
    DWORD x = 0;
    PMI_CAPABILITIES_TYPE CapabilityType;

    CapabilityType = PmiCapabilitiesInput->CapabilityType;
    if (CapabilityType < 0 || CapabilityType >= PmiCapabilitiesMax)
    {
        Status = STATUS_INVALID_PARAMETER;
        goto IoctlGetCapabilitiesExit;
    }
    // ...

    x = 1;

    PmiAcpiToCapabilities[CapabilityType](2);

IoctlGetCapabilitiesExit:
    return Status;
}

// No bug - Correct Usage
NTSTATUS Test_CorrectUsage2(PPMI_CAPABILITIES PmiCapabilitiesInput)
{
    NTSTATUS Status = 0;
    DWORD x = 0;
    int CapabilityType;

    CapabilityType = PmiCapabilitiesInput->CapabilityType;
    if (CapabilityType < 0 || CapabilityType >= PmiCapabilitiesMax)
    {
        Status = STATUS_INVALID_PARAMETER;
        goto IoctlGetCapabilitiesExit;
    }
    // ...

    x = 1;

    PmiAcpiToCapabilities[CapabilityType](2);

IoctlGetCapabilitiesExit:
    return Status;
}

// Should not fire as the Guard is not an If statement. The for loop has an implicit lower bound
// If it fires == false positive
NTSTATUS Test_GuardIsNotAnIfStatement(PPMI_CAPABILITIES PmiCapabilitiesInput)
{
    NTSTATUS Status = 0;
    DWORD x = 0;
    int CapabilityType;

    for (CapabilityType = PmiReportedCapabilities; CapabilityType <= PmiCapabilitiesMax; CapabilityType++)
    {
        PmiAcpiToCapabilities[CapabilityType](2);
    }
    // ...
    return Status;
}


// If it fires == false positive
NTSTATUS Test_GuardIsAnIfStatementButVariableLowerBound(PPMI_CAPABILITIES PmiCapabilitiesInput)
{
    NTSTATUS Status = 0;
    DWORD x = 0;
    int CapabilityType = 0;  //==> Lower bound

    while (1)
    {
        if (CapabilityType >= PmiCapabilitiesMax)
        {
            break;
        }
        // ...

        PmiAcpiToCapabilities[CapabilityType](0);   // NOT A BUG - Lower bound == 0
        // ...
        CapabilityType++;
    }
    // ...
    return Status;
}

NTSTATUS Test_GuardIsAnIfStatementButVariableLowerBound_notbound(PPMI_CAPABILITIES PmiCapabilitiesInput, int initialBound)
{
    NTSTATUS Status = 0;
    DWORD x = 0;
    int CapabilityType = initialBound;  //==> Lower bound

    while (1)
    {
        if (CapabilityType >= PmiCapabilitiesMax)
        {
            break;
        }
        // ...

        PmiAcpiToCapabilities[CapabilityType](0);   //BUG - Lowerbound is unknown
        // ...
        CapabilityType++;
    }
    // ...
    return Status;
}

NTSTATUS Test_GuardIsAnIfStatementButVariableLowerBound_outofBounds(PPMI_CAPABILITIES PmiCapabilitiesInput)
{
    NTSTATUS Status = 0;
    DWORD x = 0;
    int CapabilityType = -1;  //==> Lower bound

    while (1)
    {
        if (CapabilityType >= PmiCapabilitiesMax)
        {
            break;
        }
        // ...

        PmiAcpiToCapabilities[CapabilityType](0);  // BUG - lower bound is < 0
        // ...
        CapabilityType++;
    }
    // ...
    return Status;
}
