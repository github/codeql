pub struct Language {
    pub name: String,
    pub node_types: &'static str,
    /// Optional yeast desugaring configuration. When set with an
    /// `output_node_types_yaml`, the generator uses that YAML for the
    /// dbscheme/QL library instead of `node_types`. The `rules` field is
    /// unused at code-generation time; only the schema matters.
    pub desugar: Option<yeast::DesugaringConfig>,
}
