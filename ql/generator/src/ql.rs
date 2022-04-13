use std::collections::BTreeSet;
use std::fmt;

#[derive(Clone, Eq, PartialEq, Hash)]
pub enum TopLevel<'a> {
    Class(Class<'a>),
    Import(Import<'a>),
    Module(Module<'a>),
}

impl<'a> fmt::Display for TopLevel<'a> {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            TopLevel::Import(imp) => write!(f, "{}", imp),
            TopLevel::Class(cls) => write!(f, "{}", cls),
            TopLevel::Module(m) => write!(f, "{}", m),
        }
    }
}

#[derive(Clone, Eq, PartialEq, Hash)]
pub struct Import<'a> {
    pub module: &'a str,
    pub alias: Option<&'a str>,
}

impl<'a> fmt::Display for Import<'a> {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "import {}", &self.module)?;
        if let Some(name) = &self.alias {
            write!(f, " as {}", name)?;
        }
        Ok(())
    }
}
#[derive(Clone, Eq, PartialEq, Hash)]
pub struct Class<'a> {
    pub qldoc: Option<String>,
    pub name: &'a str,
    pub is_abstract: bool,
    pub supertypes: BTreeSet<Type<'a>>,
    pub characteristic_predicate: Option<Expression<'a>>,
    pub predicates: Vec<Predicate<'a>>,
}

impl<'a> fmt::Display for Class<'a> {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        if let Some(qldoc) = &self.qldoc {
            write!(f, "/** {} */", qldoc)?;
        }
        if self.is_abstract {
            write!(f, "abstract ")?;
        }
        write!(f, "class {} extends ", &self.name)?;
        for (index, supertype) in self.supertypes.iter().enumerate() {
            if index > 0 {
                write!(f, ", ")?;
            }
            write!(f, "{}", supertype)?;
        }
        writeln!(f, " {{ ")?;

        if let Some(charpred) = &self.characteristic_predicate {
            writeln!(
                f,
                "  {}",
                Predicate {
                    qldoc: None,
                    name: self.name,
                    overridden: false,
                    is_final: false,
                    return_type: None,
                    formal_parameters: vec![],
                    body: charpred.clone(),
                }
            )?;
        }

        for predicate in &self.predicates {
            writeln!(f, "  {}", predicate)?;
        }

        write!(f, "}}")?;

        Ok(())
    }
}

#[derive(Clone, Eq, PartialEq, Hash)]
pub struct Module<'a> {
    pub qldoc: Option<String>,
    pub name: &'a str,
    pub body: Vec<TopLevel<'a>>,
}

impl<'a> fmt::Display for Module<'a> {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        if let Some(qldoc) = &self.qldoc {
            write!(f, "/** {} */", qldoc)?;
        }
        writeln!(f, "module {} {{ ", self.name)?;
        for decl in &self.body {
            writeln!(f, "  {}", decl)?;
        }
        write!(f, "}}")?;
        Ok(())
    }
}
// The QL type of a column.
#[derive(Clone, Eq, PartialEq, Hash, Ord, PartialOrd)]
pub enum Type<'a> {
    /// Primitive `int` type.
    Int,

    /// Primitive `string` type.
    String,

    /// A database type that will need to be referred to with an `@` prefix.
    At(&'a str),

    /// A user-defined type.
    Normal(&'a str),
}

impl<'a> fmt::Display for Type<'a> {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            Type::Int => write!(f, "int"),
            Type::String => write!(f, "string"),
            Type::Normal(name) => write!(f, "{}", name),
            Type::At(name) => write!(f, "@{}", name),
        }
    }
}

#[derive(Clone, Eq, PartialEq, Hash)]
pub enum Expression<'a> {
    Var(&'a str),
    String(&'a str),
    Integer(usize),
    Pred(&'a str, Vec<Expression<'a>>),
    And(Vec<Expression<'a>>),
    Or(Vec<Expression<'a>>),
    Equals(Box<Expression<'a>>, Box<Expression<'a>>),
    Dot(Box<Expression<'a>>, &'a str, Vec<Expression<'a>>),
    Aggregate {
        name: &'a str,
        vars: Vec<FormalParameter<'a>>,
        range: Option<Box<Expression<'a>>>,
        expr: Box<Expression<'a>>,
        second_expr: Option<Box<Expression<'a>>>,
    },
}

impl<'a> fmt::Display for Expression<'a> {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            Expression::Var(x) => write!(f, "{}", x),
            Expression::String(s) => write!(f, "\"{}\"", s),
            Expression::Integer(n) => write!(f, "{}", n),
            Expression::Pred(n, args) => {
                write!(f, "{}(", n)?;
                for (index, arg) in args.iter().enumerate() {
                    if index > 0 {
                        write!(f, ", ")?;
                    }
                    write!(f, "{}", arg)?;
                }
                write!(f, ")")
            }
            Expression::And(conjuncts) => {
                if conjuncts.is_empty() {
                    write!(f, "any()")
                } else {
                    for (index, conjunct) in conjuncts.iter().enumerate() {
                        if index > 0 {
                            write!(f, " and ")?;
                        }
                        write!(f, "({})", conjunct)?;
                    }
                    Ok(())
                }
            }
            Expression::Or(disjuncts) => {
                if disjuncts.is_empty() {
                    write!(f, "none()")
                } else {
                    for (index, disjunct) in disjuncts.iter().enumerate() {
                        if index > 0 {
                            write!(f, " or ")?;
                        }
                        write!(f, "({})", disjunct)?;
                    }
                    Ok(())
                }
            }
            Expression::Equals(a, b) => write!(f, "{} = {}", a, b),
            Expression::Dot(x, member_pred, args) => {
                write!(f, "{}.{}(", x, member_pred)?;
                for (index, arg) in args.iter().enumerate() {
                    if index > 0 {
                        write!(f, ", ")?;
                    }
                    write!(f, "{}", arg)?;
                }
                write!(f, ")")
            }
            Expression::Aggregate {
                name,
                vars,
                range,
                expr,
                second_expr,
            } => {
                write!(f, "{}(", name)?;
                if !vars.is_empty() {
                    for (index, var) in vars.iter().enumerate() {
                        if index > 0 {
                            write!(f, ", ")?;
                        }
                        write!(f, "{}", var)?;
                    }
                    write!(f, " | ")?;
                }
                if let Some(range) = range {
                    write!(f, "{} | ", range)?;
                }
                write!(f, "{}", expr)?;
                if let Some(second_expr) = second_expr {
                    write!(f, ", {}", second_expr)?;
                }
                write!(f, ")")
            }
        }
    }
}

#[derive(Clone, Eq, PartialEq, Hash)]
pub struct Predicate<'a> {
    pub qldoc: Option<String>,
    pub name: &'a str,
    pub overridden: bool,
    pub is_final: bool,
    pub return_type: Option<Type<'a>>,
    pub formal_parameters: Vec<FormalParameter<'a>>,
    pub body: Expression<'a>,
}

impl<'a> fmt::Display for Predicate<'a> {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        if let Some(qldoc) = &self.qldoc {
            write!(f, "/** {} */", qldoc)?;
        }
        if self.is_final {
            write!(f, "final ")?;
        }
        if self.overridden {
            write!(f, "override ")?;
        }
        match &self.return_type {
            None => write!(f, "predicate ")?,
            Some(return_type) => write!(f, "{} ", return_type)?,
        }
        write!(f, "{}(", self.name)?;
        for (index, param) in self.formal_parameters.iter().enumerate() {
            if index > 0 {
                write!(f, ", ")?;
            }
            write!(f, "{}", param)?;
        }
        write!(f, ") {{ {} }}", self.body)?;

        Ok(())
    }
}

#[derive(Clone, Eq, PartialEq, Hash)]
pub struct FormalParameter<'a> {
    pub name: &'a str,
    pub param_type: Type<'a>,
}

impl<'a> fmt::Display for FormalParameter<'a> {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{} {}", self.param_type, self.name)
    }
}

/// Generates a QL library by writing the given `elements` to the `file`.
pub fn write<'a>(file: &mut dyn std::io::Write, elements: &'a [TopLevel]) -> std::io::Result<()> {
    for element in elements {
        write!(file, "{}\n\n", &element)?;
    }
    Ok(())
}
