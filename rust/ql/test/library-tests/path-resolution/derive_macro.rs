macro_rules! build_via_macro {
    () => {
        pub struct MacroGenerated;
    };
}

#[derive(proc_macro::GenerateBuilder)] // $ item=derive
pub struct Config;

pub fn make() -> ConfigBuilder { // $ item=ConfigBuilder
    ConfigBuilder // $ item=ConfigBuilder
}

#[derive(proc_macro::GenerateBuilderViaMacro)] // $ item=derive
struct MacroDerive;

pub fn make_macro_generated() -> MacroGenerated { // $ item=MacroGenerated
    MacroGenerated // $ item=MacroGenerated
}

#[derive(proc_macro::GenerateBuilderViaAttribute)] // $ item=derive
struct AttributeDerive;

pub fn make_attribute_generated() -> AttributeGenerated { // $ item=AttributeGenerated
    AttributeGenerated // $ item=AttributeGenerated
}

mod glob_shadowing {
    mod helper {
        pub struct GlobCollision;
    }

    struct GlobCollision;

    #[derive(proc_macro::GenerateGlobUse)] // $ item=derive
    struct DeriveGlobUse;

    fn check() {
        let _: GlobCollision; // $ item=GlobCollision
    }
}
