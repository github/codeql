private import Raw

class TypeConstraint extends @type_constraint, AttributeBase {
  override SourceLocation getLocation() { type_constraint_location(this, result) }

  /** Gets the assembly name. */
  string getName() { type_constraint(this, result, _) }

  /** Gets the full name of this type constraint including namespaces. */
  string getFullName() { type_constraint(this, _, result) }
}
