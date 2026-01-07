import csharp
import semmle.code.csharp.dataflow.Nullness

from MaybeNullExpr mne
where mne.getFile().getBaseName() = "NullConditional.cs"
select mne
