use std::fmt;

pub struct Class {
    pub name: String,
    pub is_abstract: bool,
    pub supertypes: Vec<Type>,
    pub fields: Vec<Field>,
    pub characteristic_predicate: Option<Term>,
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

        for field in &self.fields {
            write!(f, "  {}\n", &field)?;
        }

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
#[derive(Clone)]
pub enum Type {
    /// Primitive `int` type.
    Int,

    /// Primitive `string` type.
    String,

    /// A user-defined type.
    Normal(String),

    /// A database type that will need to be referred to with an `@` prefix.
    AtType(String),
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

#[derive(Clone)]
pub struct Field {
    pub name: String,
    pub r#type: Type,
}

impl fmt::Display for Field {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{} {};", self.r#type, self.name)
    }
}

#[derive(Clone)]
pub enum Term {
    Expr(Expression),
    Or(Box<Term>, Box<Term>),
    Equals(Expression, Expression),
}

impl fmt::Display for Term {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            Term::Expr(e) => write!(f, "{}", e),
            Term::Or(a, b) => write!(f, "({}) or ({})", a, b),
            Term::Equals(a, b) => write!(f, "{} = {}", a, b),
        }
    }
}

#[derive(Clone)]
pub enum Expression {
    Var(String),
    String(String),
    Pred(String, Vec<Expression>),
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
        }
    }
}

#[derive(Clone)]
pub struct Predicate {
    pub name: String,
    pub overridden: bool,
    pub return_type: Option<Type>,
    pub formal_parameters: Vec<FormalParameter>,
    pub body: Term,
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

#[derive(Clone)]
pub struct FormalParameter {
    pub name: String,
    pub r#type: Type,
}

impl fmt::Display for FormalParameter {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{} {}", self.r#type, self.name)
    }
}

/// Generates a QL library by writing the given `classes` to the `file`.
pub fn write(
    language_name: &str,
    file: &mut dyn std::io::Write,
    classes: &[Class],
) -> std::io::Result<()> {
    write!(file, "/*\n")?;
    write!(file, " * CodeQL library for {}\n", language_name)?;
    write!(
        file,
        " * Automatically generated from the tree-sitter grammar; do not edit\n"
    )?;
    write!(file, " */\n\n")?;

    for class in classes {
        write!(file, "{}\n\n", &class)?;
    }

    Ok(())
}
