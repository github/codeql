private import Raw

class PropertyMember extends @property_member, Member {
  override string getName() { property_member(this, _, _, _, _, result, _) }

  override SourceLocation getLocation() { property_member_location(this, result) }

  override predicate isHidden() { property_member(this, true, _, _, _, _, _) }

  override predicate isPrivate() { property_member(this, _, true, _, _, _, _) }

  override predicate isPublic() { property_member(this, _, _, true, _, _, _) }

  override predicate isStatic() { property_member(this, _, _, _, true, _, _) }

  override Attribute getAttribute(int i) { property_member_attribute(this, i, result) }

  override TypeConstraint getTypeConstraint() { property_member_property_type(this, result) }
}
