mod shadow {
    macro_rules! include {
        ($path:literal) => {
            pub mod shadow_child;
        };
    }

    include!("unused.rs");
}

mod shadow_existing {
    macro_rules! include {
        ($path:literal) => {
            pub mod existing_child;
        };
    }

    include!("includes/present.rs");
}

mod literal {
    include!("includes/literal_outer.rs");
}

mod raw_literal {
    include![r#"includes/literal_outer.rs"#];
}

mod nested_literal {
    include!("includes/nested_literal_outer.rs");
}

mod wrapped {
    include!("includes/wrapped_outer.rs");
}

mod nested_shadow {
    include!("includes/nested_shadow_outer.rs");
}

mod nested_shadow_computed {
    include!("includes/nested_shadow_computed_outer.rs");
}

mod computed {
    include!("includes/computed_outer.rs");
}

mod escaped {
    include!("includes/escaped_outer.rs");
}

mod core_wrapper {
    macro_rules! include {
        ($path:literal) => {
            ::core::include!($path);
        };
    }

    include!("includes/core_wrapper.rs");
}

mod std_wrapper {
    macro_rules! include {
        ($path:literal) => {
            std::include!($path);
        };
    }

    include!("includes/std_wrapper.rs");
}

mod shadow_alias {
    macro_rules! generate {
        ($path:literal) => {
            pub mod alias_child;
        };
    }

    use generate as include;
    include!("unused_alias.rs");
}

mod qualified_macro {
    macro_rules! generate {
        ($path:literal) => {
            pub mod qualified_child;
        };
    }

    pub(crate) use generate as include;
}

mod shadow_qualified {
    crate::qualified_macro::include!("unused_qualified.rs");
}

#[macro_use]
mod macro_defs;

mod shadow_imported {
    include!("missing-imported.rs");
}

// Keep the fallback and incorrect outer-directory candidates in the database.
#[path = "computed/computed_child.rs"]
mod computed_fallback;
#[path = "escaped/escaped_child.rs"]
mod escaped_fallback;
#[path = "includes/computed_child.rs"]
mod computed_outer_candidate;
#[path = "includes/escaped_child.rs"]
mod escaped_outer_candidate;

fn main() {
    shadow::shadow_child::shadow_fn();
    shadow_existing::existing_child::existing_fn();
    literal::literal_child::literal_fn();
    raw_literal::literal_child::literal_fn();
    nested_literal::nested_literal_child::nested_literal_fn();
    wrapped::wrapped_child::wrapped_fn();
    nested_shadow::nested_shadow_child::nested_shadow_fn();
    nested_shadow_computed::nested_shadow_computed_child::nested_shadow_computed_fn();
    computed::computed_child::computed_fn();
    escaped::escaped_child::escaped_fn();
    core_wrapper::core_child::core_fn();
    std_wrapper::std_child::std_fn();
    shadow_alias::alias_child::alias_fn();
    shadow_qualified::qualified_child::qualified_fn();
    shadow_imported::imported_child::imported_fn();
}
