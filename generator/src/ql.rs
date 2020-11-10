use std::collections::BTreeSet;
use std::fmt;

pub enum TopLevel {
    Class(Class),
    Import(String),
}

impl fmt::Display for TopLevel {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            TopLevel::Import(x) => write!(f, "import {}", x),
            TopLevel::Class(cls) => write!(f, "{}", cls),
        }
    }
}

#[derive(Clone, Eq, PartialEq, Hash)]
pub struct Class {
    pub name: String,
    pub is_abstract: bool,
    pub supertypes: BTreeSet<Type>,
    pub characteristic_predicate: Option<Expression>,
    pub predicates: Vec<Predicate>,
}

impl fmt::Display for Class {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
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
        write!(f, " {{ \n")?;

        if let Some(charpred) = &self.characteristic_predicate {
            write!(
                f,
                "  {}\n",
                Predicate {
                    name: self.name.clone(),
                    overridden: false,
                    return_type: None,
                    formal_parameters: vec![],
                    body: charpred.clone(),
                }
            )?;
        }

        for predicate in &self.predicates {
            write!(f, "  {}\n", predicate)?;
        }

        write!(f, "}}")?;

        Ok(())
    }
}

// The QL type of a column.
#[derive(Clone, Eq, PartialEq, Hash, Ord, PartialOrd)]
pub enum Type {
    /// Primitive `int` type.
    Int,

    /// Primitive `string` type.
    String,

    /// A database type that will need to be referred to with an `@` prefix.
    AtType(String),

    /// A user-defined type.
    Normal(String),
}

impl fmt::Display for Type {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            Type::Int => write!(f, "int"),
            Type::String => write!(f, "string"),
            Type::Normal(name) => write!(f, "{}", name),
            Type::AtType(name) => write!(f, "@{}", name),
        }
    }
}

#[derive(Clone, Eq, PartialEq, Hash)]
pub enum Expression {
    Var(String),
    String(String),
    Pred(String, Vec<Expression>),
    Or(Vec<Expression>),
    Equals(Box<Expression>, Box<Expression>),
    Dot(Box<Expression>, String, Vec<Expression>),
}

impl fmt::Display for Expression {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            Expression::Var(x) => write!(f, "{}", x),
            Expression::String(s) => write!(f, "\"{}\"", s),
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
        }
    }
}

#[derive(Clone, Eq, PartialEq, Hash)]
pub struct Predicate {
    pub name: String,
    pub overridden: bool,
    pub return_type: Option<Type>,
    pub formal_parameters: Vec<FormalParameter>,
    pub body: Expression,
}

impl fmt::Display for Predicate {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
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
pub struct FormalParameter {
    pub name: String,
    pub param_type: Type,
}

impl fmt::Display for FormalParameter {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{} {}", self.param_type, self.name)
    }
}

/// Generates a QL library by writing the given `classes` to the `file`.
pub fn write(
    language_name: &str,
    file: &mut dyn std::io::Write,
    elements: &[TopLevel],
) -> std::io::Result<()> {
    write!(file, "/*\n")?;
    write!(file, " * CodeQL library for {}\n", language_name)?;
    write!(
        file,
        " * Automatically generated from the tree-sitter grammar; do not edit\n"
    )?;
    write!(file, " */\n\n")?;

    for element in elements {
        write!(file, "{}\n\n", &element)?;
    }

    Ok(())
}
