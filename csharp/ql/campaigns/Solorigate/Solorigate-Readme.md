# Working with Solorigate queries

In early December, 2020 a sophisticated compromise campaign was uncovered, dubbed [Solorigate](https://aka.ms/solorigate).  A key feature of the campaign was a malicious software implant inserted into SolarWinds' Orion product on the build server. Studying the coding patterns and techniques used in the implant, Microsoft authored CodeQL queries as part of a larger effort to analyze our source code for any malicious modification - a brief summary of those efforts can be [found here](https://aka.ms/Solorigate-CodeQL-Blog). These queries here represent a mixture of techniques to look for code that shares features with the malicious Implant code.

This ReadMe walks through what each query does and limitations of the approaches taken, suggestions for modifications, and general advice on using CodeQL to author backdoor hunting queries.  There are two approaches taken with the queries; the first is to look for syntactic characteristics used in the malicious implant, things like names and particular literals.  The second approach looks for semantic patterns – particular functionality and flow associated with the implant.  In both cases it is possible, and sometimes likely, that benign code will coincidentally match the patterns these queries look for, so all findings will need to be reviewed to either verify or rule out the providence of the source code being flagged.  The descriptions of each query try to capture the likely coincidence of findings in code of benign providence.

When editing this queries for open sourcing, we tried to find the right balance between detection capability and false positive rate, mindful that different organizations have differing resources to review the findings.  We also excluded queries that we found to be resource intensive when executing without providing significant detective value over these queries here.  

## Syntactic queries

These queries are targeting specific names/values and other syntactic traits present in the Solorigate IoCs.  They tend to either target syntax that is easy for the malicious actor to alter between operations or syntax that is going to be fairly coincidental, so are either very precise but very fragile, or imprecise but more durable.  However, they are very fast to execute, and very easy to modify, so can be easily repurposed to do first pass analysis in future campaigns to hunt for code IoCs.  Several of them use a list syntax introduced in CodeQL 1.26, so require that version of newer to compile and execute.

### cs/Solorigate/number-of-known-commands-in-enum-above-threshold

**Implemented in:** NumberOfKnownCommandsAboveThreshold.ql

This query looks for enumerations that look like they are defining Command and Control functionality, based on the enumeration in Solorigate.  Enumerations are a convenient way of defining and referencing this functionality, so are likely to be used in other implants.  This query does allow some fuzziness to how many commands are defined, by default looking for any enumeration with at least 10 of the 18 commands but is brittle to changes in the names of the commands.

The specific list of commands it looks for within the enumeration is defined in Solorigate.qll in countSolorigateCommandInEnum.  There are several “clusters” of commands – for example, commands to interact with the file system, with the registry, etc.  If implementing an API for file system or registry interactions it is possible to coincidentally include similar command names, but it is unlikely a single enumeration would coincidentally contain commands to interact with the file system, assembly, handle process execution, etc.  If you know your code performs a subset of those functions, deleting those specific commands from countSolorigateCommandInEnum and lowering the threshold of the query should reduce false positives, though does increase the chance of false negatives.  

This query could be modified to reduce false negatives by decreasing the threshold and changing the name comparisons of the enumeration values to fuzzy matches, but doing so will produce higher false positives.  Fuzzy matching is also more computationally costly, so will increase the execution time.  

### cs/Solorigate/number-of-known-hashes-above-threshold

**Implemented in:** NumberofKnownHashesAboveThreshold.ql

This query looks for the presence of 5 or more of the XOR’ed hashes Solorigate derived from the names of running processes they wanted to avoid(various anti-malware, etc.).  The Solorigate implant would first hash the process name with FNV-1A, and then XOR it with the magic number 6605813339339102567, and then compared to a list of these derived hashes to see if any of the processes the implant wanted to evade were currently running.  Likely the reason for the XOR with a magic number is so that comparison values can be unique per implant, so it is very unlikely they were reused elsewhere.  However, these values are incredibly unlikely to appear coincidentally in source, so if this query does have findings there is a high probability the findings are malicious.

The derived hash literals are defined in Solorigate.qll in “solorigateSuspiciousHashes”.  If a similar campaign happens in the future this query can easily be repurposed by swapping the current hash values with the values for that campaign.  Like now, doing so probably won’t trigger findings as the malicious actor would likely make the values unique per implant, but this is a very quick query to both author/tweak and to execute, so the cost of checking “just in case” is quite low.

“cs/Solorigate/modified-fnv-function-detection” and “cs/backdoor/process-name-to-hash-function” attempt to detect the actual process name hashing technique rather than the particular values, so will be durable to use of different magic numbers.

### cs/Solorigate/number-of-known-literals-above-threshold

**Implemented In:** NumberOfKnownLiteralsAboveThreshold.ql

This query looks for literals present in the implant, however since many of the literals would appear coincidentally in a great deal of code (common IP addresses, host names, etc.), this query does not fire unless at least 30 of the literals are all present.  Many of the literals would need to be reused in other implants if similar functionality were desired (though they could be hidden with a reversable obfuscation technique).

The query is ensuring that these are semantic literals, so will not incorrectly count usages in comments/method names/variable names/etc. – this shows that even for a relatively simple detection CodeQL provides advantages over more simplistic text parsing.  As previously mentioned, many of these literals are incredibly common, so the likelihood that a finding represents malicious modification is low.  Its recommended to triage the other queries first, as triaging the results of this query is more labor intensive and results are less likely to represent malicious activity.  Reducing the threshold value in NumberOfKnownLiteralsAboveThreshold.ql will increase the chance that it catches other implants that used a subset of the literals, but will also significantly increase false positives.  Alternatively, if the first run produces a large number of results, moving the threshold value up helps reduce the findings to only code that more completely mirrors the literals used in Solorigate, while increasing the possibility potential false negatives.

The list of literals is defined in Solorigate.qll in solorigateSuspiciousLiterals.  When run against specific code bases the result set may be more manageable by removing methods and literals known to be legitimately used in that code base, though trimming the list too extensively will increase the chances of false negatives.  This query can easily be repurposed for future campaigns by replacing the literals here with the literals that were features of IoCs in those campaigns.  If the number of IoC literals is greater in future campaigns, moving the threshold value up from 30 would likely increase detection accuracy without significantly increasing false negative rates.  On the flip side, if the number of literals is significantly less, the threshold value will likely need to be decreased from 30.

### cs/solorigate/number-of-known-method-names-above-threshold

**Implemented In:** NumberOfKnownMethodNamesAboveThreshold.ql

This query looks for method names present within the implant, but as with the literals, the method names would appear coincidentally in many code bases as they were intended to blend in.  Because the individual method names are highly likely to be coincidentally used, this query only fires if 50 or more are present.  This query is ensuring that these are used as method names, so will not incorrectly count usage in literals/comments/variable names/etc. While these are common method names, it would be uncommon (but still possible – we had plenty of false positives) for many of them to all be defined within the same project.  Excluding methods that are common overrides in class declarations (ex. ToString) will lower the false positive rate, but with the threshold of 50 we found the result set manageable without that adjustment.  

The list of literals is defined in Solorigate.qll in solorigateSuspiciousMethodNames.  While the previous queries looking for the command Enumeration, Derived process hashes, and literals may provide some value if ported to cover other languages, the specific method list for this query does not, as the methods are particular for C#.  However, if an additional implant targeting another language is discovered in the future, the basic approach used in this query is re-usable even if the method names are not.

## Semantic Queries

The semantic queries are not looking for any specific names or terms unique to the IoCs, but rather techniques or patterns used for the implant’s functionality.  Some can be evaded by implementing the functionality via different semantics, but a malicious agent would need to specifically take pains to do so.  These queries may detect unrelated backdoors, and can also be ported to cover other programming languages to detect the same techniques in those languages.

### cs/Solorigate/modified-fnv-function-detection

**Implemented in:** ModifiedFnvFunctionDetection.ql

The Solorigate implant tries to evade various security detection software by comparing hashes of the process names against an embedded list of values.  However, to make the embedded list unique per implant, the hashes were then XOR’ed with a magic value.  The implant embedded a version of the FNV-1A hash function for this purpose, so this query looks for use of an “FNV-like” implementation with XOR.

The logic that determines what is “FNV-like” is in NonCryptographicHashes.qll, in the predicate “maybeUsedInFNVFunction”.  This logic is not looking for specific known implementations of an FNV function, but rather method code that looks like it is trying to implement one of the FNV functions.  This should avoid evasions based purely on the name of the function, but deliberate attempts to obfuscate the implementation of the function may be able to evade this analysis.  

Separately, and unrelated to Solorigate, this predicate (as well as the one looking for “Elfhash-like”) can be combined with control flow analysis to ensure that these hash functions are not being used in a cryptographic context where their use would be insecure.  

### cs/backdoor/process-name-to-hash-function

**Implemented in:** ProcessNameToHashTaintFlow.ql

This query takes a different approach than the previous two – rather than looking for use of FNV-like methods used specifically in conjunction with an XOR, it instead looks for flow from System.Diagnostics.Process.ProcessName to something that “looks like” a hash function.  It determines what looks like a hash function by looking for methods whose names contain “Hash” or MD4/5 or some variation of SHA, or whose implementation is either “FNV-Like” or “Elf-Like” (see NonCryptographicHashes.qll for the logic that determines FNV or Elf-like – looking at the implementation is durable to simple renaming of the methods). This approach should catch a variety of process name hashing schemes, though it should be noted that there are legitimate reasons to hash a process name.  The flow analysis is interprocedural, so can detect attempts to obfuscate the hashing of process names by distributing the steps across the source.  As the definition of a hash function is intentionally a bit fuzzy this query has a medium precision (i.e. it may falsely catch code that is not attempting to hash the process name), and as there are legitimate reasons to hash a process name the chance that an accurate finding represents a malicious implant is moderate to low depending on the code base.

To add additional hash detections logic to cast a wider net, modify isGetHash in ProcessNameToHashTaintFlow.ql. 

### cs/backdoor/potential-time-bomb

**Implemented in:** PotentialTimeBomb.ql

This query looks for a the Solorigate Implant's time delay functionality.  The Backdoor would not initially activate until 12-14 days *after* the Orion update with the implanted code was installed.  It did this by checking the last file write time, randomly adding between 288 and 336 hours to it, and comparing that against the current system time before it initially called back to the C2 servers controlling the campaign.  This query detects that technique by looking for flow from GetLastWriteTime to an arithmetic operation, and from there to a comparison against the current time.  This query will coincidentally flag any software that invokes an action a certain time after installation - for example, prompting the user to register or activate the product after a certain period has elapsed.  

The accuracy of this query could be improved to reduce those coincidental findings by checking if there is then flow to a remote source (which is the case in the Solorigate implant) or to shell or process execution as they are often features of time bombed malicious code, however the additional flow steps do increase the execution time and increase the chance of false negatives.  This query as is produced a manageable set of false positives when run across our thousands of databases, so we suggest first running it as is, and only making those modifications if the practice appears to be common in your code bases.

To make this query more generic, it could be modified to check for other ways of persisting an initial data on the system - reading a registry key, file contents, system reboot time, etc.  However, each additional data source will increase false positives.  

### cs/Solorigate/swallow-everything-exception

**Implemented in:** SwallowEverythingExceptionHandler.ql

The Solorigate Implant wraps the implanted code in a

    try {  
     //stuff
    } 
    catch (Exception) {}

to ensure that runtime exceptions didn’t tip anyone off.  This query looks for all catches of generic exceptions, with empty exception blocks.  The detection is high precision – it will accurately find all empty generic exception handlers.  However, it is unfortunately a common enough bad programming practice that there are plenty of writeups in existence explaining that it is a bad programming practice, so the likelihood of the findings being a malicious implant are low.  It’s recommended that they be reviewed to ensure this bad practice isn’t hiding latent (or not so latent) bugs in the code.

It can be evaded by including any statements in the catch block, but the existing cs/catch-of-all-exceptions query can be used to catch that evasion.  That query’s findings will be a superset of this query, as it will catch many legitimate situations where the exception was anticipated and the catch block can take action that would make swallowing the exception and continuing on relatively risk free.  By looking at empty catch statements, this query looks for the exact pattern in the Solorigate implant and will generate fewer findings to review.

### cs/backdoor/dangerous-native-functions

**Implemented in:** DangerousNativeFunctionCalls.ql

This query looks for several native Windows API that might be present in backdoor functionality, including several used in Solorigate.  It is also more broadly useful in looking for a technique that can be used to evade queries looking for malicious execution of processes by calling the native platform libraries instead of the .Net Class libraries.  We are including it to act as inspiration for other query developers to think about how they can query not just for backdoor patterns but also how they can hunt for attempts to then evade those queries.

While the results of this query are useful on their own, both to cast a wide net to find this evasion technique, and to review why the developers chose the more error prone PInvoke implementation in benign findings, this query was kept simple specifically to use as an example. It can easily be combined with Data Flow or Taint Flow by adding a call to the isExternMethod predicate in DangerousNativeFunctionCalls to an overridden isSink implementation.  With this relatively simple addition, flow from untrusted sources like web requests into the potentially dangerous API can easily be detected, and at the very least represent a potential security vulnerability that should be reviewed, but may also represent a C2 implementation attempting to evade searches for the standard Class Library functions.

## Build CodeQL Databases from the production Build Servers/Pipelines

The malicious modifications of SolarWinds’ code took place on the build server (more details from [CrowdStrike](https://www.crowdstrike.com/blog/sunspot-malware-technical-analysis/)), so CodeQL databases used for analysis should ideally be built from the same build servers.  CodeQL utilizes the same Roslyn Compiler as MSBuild, so absent the malicious actor specifically building checks for the presence of CodeQL, it is likely the injection technique utilized by the malicious actor would replicate when CodeQL was run.  Alternatively, if building CodeQL databases in an independent environment, other techniques can be used to validate that the code that was compiled into the final binaries is the same as the source code in the source repository.

### FYI

While the step-by-step details are outside the scope of this ReadMe, if the build environment is configured to perform deterministic builds (not all compilers support this, nor default to this if they do), the binaries produced by the build environment can be compared to binaries produced from the same source compiled in a distinct environment.  Additionally, some compilers can be configured to emit a manifest of the source code hashes for the source files that were compiled (MSBuild puts them in the PDB files emitted during compilation), which can be compared to source hashes created in an independent environment.  If the comparison of either the deterministically built binaries or source hashes do not match, that is a clear indicator that further investigation is warranted.  These two techniques can be automated to provide ongoing validation of the build output.  

If comparing source hashes, it is strongly recommended that SHA256 rather than weaker hashes be used.  This can be configured in the following Microsoft compilers by using the specified compiler flags below:

* cl.exe /ZH:SHA_256
* ml.exe /ZH:SHA_256
* ml64.exe /ZH:SHA_256
* armasm.exe -gh:SHA_256
* armasm64.exe -gh:SHA_256
* csc.exe /checksumalgorithm:SHA256
