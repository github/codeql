extern crate proc_macro;
use proc_macro::TokenStream;

pub struct Runner {}

impl Runner {
    pub fn new(language: tree_sitter::Language, rules: Vec<Rule>) -> Self {
        Self {}
    }

    pub fn run(&self, _input: &str) -> Ast {
        Ast {}
    }
}

// We probably want to change this
#[derive(PartialEq, Eq, Debug)]
pub struct Ast {}

pub struct Query {}
impl Query {
    pub fn new() -> Self {
        Self {}
    }
}

pub struct Rule {}
impl Rule {
    pub fn new(query: Query, transform: impl Fn(Match) -> Ast) -> Self {
        Self {}
    }
}

pub struct Match {}
