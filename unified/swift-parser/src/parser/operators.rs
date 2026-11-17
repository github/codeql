use super::Token;
use std::{
    cmp::Ordering,
    collections::{HashMap, HashSet},
};

#[derive(Clone, Copy, PartialEq, Eq)]
enum Associativity {
    None,
    Left,
    Right,
}

struct Group {
    associativity: Associativity,
    defined: bool,
    higher_than: Vec<usize>,
    lower_than: Vec<usize>,
}

pub(super) struct OperatorTable {
    groups: Vec<Group>,
    names: HashMap<String, usize>,
    operators: HashMap<String, usize>,
}

impl OperatorTable {
    pub fn from_source(source: &str, tokens: &[Token]) -> Self {
        let mut table = Self {
            groups: Vec::new(),
            names: HashMap::new(),
            operators: HashMap::new(),
        };
        let chain = [
            ("AssignmentPrecedence", Associativity::Right),
            ("FunctionArrowPrecedence", Associativity::Right),
            ("TernaryPrecedence", Associativity::Right),
            ("LogicalDisjunctionPrecedence", Associativity::Left),
            ("LogicalConjunctionPrecedence", Associativity::Left),
            ("ComparisonPrecedence", Associativity::None),
            ("NilCoalescingPrecedence", Associativity::Right),
            ("CastingPrecedence", Associativity::None),
            ("RangeFormationPrecedence", Associativity::None),
            ("AdditionPrecedence", Associativity::Left),
            ("MultiplicationPrecedence", Associativity::Left),
            ("BitwiseShiftPrecedence", Associativity::None),
        ];
        let mut previous = None;
        for (name, associativity) in chain {
            let id = table.group(name);
            table.groups[id].defined = true;
            table.groups[id].associativity = associativity;
            if let Some(lower) = previous {
                table.groups[id].higher_than.push(lower);
            }
            previous = Some(id);
        }
        let default = table.group("DefaultPrecedence");
        table.groups[default].defined = true;
        let ternary = table.group("TernaryPrecedence");
        table.groups[default].higher_than.push(ternary);
        let ungrouped = table.group("");
        table.groups[ungrouped].defined = true;
        for (group, operators) in [
            (
                "AssignmentPrecedence",
                "= *= &*= /= %= += &+= -= &-= <<= &<<= >>= &>>= &= ^= |=",
            ),
            ("LogicalDisjunctionPrecedence", "||"),
            ("LogicalConjunctionPrecedence", "&&"),
            ("ComparisonPrecedence", "< <= > >= == != === !== ~="),
            ("NilCoalescingPrecedence", "??"),
            ("RangeFormationPrecedence", "... ..<"),
            ("AdditionPrecedence", "+ &+ - &- | ^"),
            ("MultiplicationPrecedence", "* &* / % &"),
            ("BitwiseShiftPrecedence", "<< &<< >> &>>"),
            ("", "~>"),
        ] {
            let id = table.group(group);
            for op in operators.split_whitespace() {
                table.operators.insert(op.into(), id);
            }
        }
        table.scan(source, tokens);
        table
    }

    fn group(&mut self, name: &str) -> usize {
        if let Some(id) = self.names.get(name) {
            return *id;
        }
        let id = self.groups.len();
        self.names.insert(name.into(), id);
        self.groups.push(Group {
            associativity: Associativity::None,
            defined: false,
            higher_than: Vec::new(),
            lower_than: Vec::new(),
        });
        id
    }

    fn scan(&mut self, source: &str, tokens: &[Token]) {
        let text = |index: usize| {
            tokens
                .get(index)
                .map_or("", |t| &source[t.span.start..t.span.end])
        };
        let mut pos = 0;
        let mut nesting = 0usize;
        let mut conditional = 0usize;
        while pos < tokens.len() {
            match text(pos) {
                "#if" => conditional += 1,
                "#endif" => conditional = conditional.saturating_sub(1),
                "{" | "[" | "(" => nesting += 1,
                "}" | "]" | ")" => nesting = nesting.saturating_sub(1),
                _ => {}
            }
            if nesting != 0 || conditional != 0 {
                pos += 1;
                continue;
            }
            if text(pos) == "infix" && text(pos + 1) == "operator" {
                let name = text(pos + 2);
                let group = if text(pos + 3) == ":" {
                    text(pos + 4)
                } else {
                    ""
                };
                let id = self.group(group);
                self.operators.entry(name.into()).or_insert(id);
                pos += 3;
            } else if text(pos) == "precedencegroup" && text(pos + 2) == "{" {
                let group = self.group(text(pos + 1));
                let record = !self.groups[group].defined;
                self.groups[group].defined = true;
                pos += 3;
                while pos < tokens.len() && text(pos) != "}" {
                    let label = text(pos);
                    pos += 1;
                    if text(pos) != ":" {
                        continue;
                    }
                    pos += 1;
                    match label {
                        "associativity" => {
                            if record {
                                self.groups[group].associativity = match text(pos) {
                                    "left" => Associativity::Left,
                                    "right" => Associativity::Right,
                                    _ => Associativity::None,
                                };
                            }
                            pos += 1;
                        }
                        "higherThan" | "lowerThan" => loop {
                            let related = self.group(text(pos));
                            if record {
                                if label == "higherThan" {
                                    self.groups[group].higher_than.push(related);
                                } else {
                                    self.groups[group].lower_than.push(related);
                                }
                            }
                            pos += 1;
                            if text(pos) != "," {
                                break;
                            }
                            pos += 1;
                        },
                        _ => {
                            pos += 1;
                        }
                    }
                }
            } else {
                pos += 1;
            }
        }
    }

    pub fn lookup(&self, text: &str) -> Option<usize> {
        self.operators
            .get(text)
            .copied()
            .filter(|id| self.groups[*id].defined)
    }
    pub fn named(&self, name: &str) -> usize {
        self.names[name]
    }
    fn reaches(&self, start: usize, target: usize, lower: bool) -> bool {
        let edges = |group: usize| {
            if lower {
                &self.groups[group].lower_than
            } else {
                &self.groups[group].higher_than
            }
        };
        let mut pending = edges(start).clone();
        let mut visited = HashSet::new();
        while let Some(group) = pending.pop() {
            if group == target {
                return true;
            }
            if visited.insert(group) {
                pending.extend(edges(group));
            }
        }
        false
    }
    fn compare(&self, left: usize, right: usize) -> Option<Ordering> {
        if left == right {
            return Some(Ordering::Equal);
        }
        // Match SwiftOperators' ordered, same-direction relationship searches;
        // normalizing lowerThan edges would change the pinned oracle's trees.
        if self.reaches(right, left, true) {
            Some(Ordering::Less)
        } else if self.reaches(left, right, false) || self.reaches(left, right, true) {
            Some(Ordering::Greater)
        } else if self.reaches(right, left, false) {
            Some(Ordering::Less)
        } else {
            None
        }
    }
    pub fn fold_before(&self, left: usize, right: usize) -> Option<bool> {
        // An operator declaration without a group has nil precedence in
        // SwiftOperators, which recovers leftward without a named-group error.
        let ungrouped = self.names[""];
        if left == ungrouped || right == ungrouped {
            return Some(true);
        }
        match self.compare(left, right)? {
            Ordering::Greater => Some(true),
            Ordering::Less => Some(false),
            Ordering::Equal => match self.groups[left].associativity {
                Associativity::Left => Some(true),
                Associativity::Right => Some(false),
                Associativity::None => None,
            },
        }
    }
    pub fn can_fold(&self, groups: impl Iterator<Item = Option<usize>>) -> bool {
        let mut stack = Vec::new();
        for group in groups {
            let Some(group) = group else {
                return false;
            };
            while let Some(left) = stack.last().copied() {
                match self.fold_before(left, group) {
                    Some(true) => {
                        stack.pop();
                    }
                    Some(false) => break,
                    None => return false,
                }
            }
            stack.push(group);
        }
        true
    }
}
