class ExistentialArchetypeType extends @existential_archetype_type {
  string toString() { none() }
}

from ExistentialArchetypeType id
where existential_archetype_types(id)
select id
