class OpenedArchetypeType extends @opened_archetype_type {
  string toString() { none() }
}

from OpenedArchetypeType id
where opened_archetype_types(id)
select id
