---
category: minorAnalysis
---
* Tainted members of ASP.NET and ASP.NET Core remote flow source types now also include private fields that data binders populate (fields marked `[DataMember]` or `[JsonProperty]`, fields assigned from `value` in a public property setter, and fields returned by a public get-only collection property), get-only auto-implemented properties of collection type, and members inherited from base types. Public properties that wrap a backing field are no longer tainted directly; taint reaches them through the private field. Constants are no longer tainted.
