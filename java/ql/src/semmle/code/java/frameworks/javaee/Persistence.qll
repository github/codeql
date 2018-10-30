import java

/**
 * A `RefType` with the `@Entity` annotation that indicates that it can be persisted using a JPA
 * compatible framework.
 */
class PersistentEntity extends RefType {
  PersistentEntity() {
    getAnAnnotation() instanceof EntityAnnotation or
    getAnAnnotation() instanceof EmbeddableAnnotation
  }

  /**
   * Gets the access type for this entity.
   *
   * The access type is either FIELD or METHOD. In the former case, persistence is achieved by
   * reading and writing the fields directly. In the latter case, setters and getters are used
   * instead.
   */
  string getAccessType() {
    if exists(getAccessTypeFromAnnotation())
    then result = getAccessTypeFromAnnotation()
    else
      // If the access type is not explicit, then the location of the `Id` annotation determines
      // which access type is used.
      if getAMethod().hasAnnotation("javax.persistence", "Id")
      then result = "property"
      else result = "field"
  }

  /**
   * If there is an annotation on this class defining the access type, then this is the type.
   */
  string getAccessTypeFromAnnotation() {
    exists(AccessAnnotation accessType | accessType = getAnAnnotation() |
      result = accessType
            .getValue("value")
            .(FieldRead)
            .getField()
            .(EnumConstant)
            .getName()
            .toLowerCase()
    )
  }
}

/*
 * Annotations in the `javax.persistence` package.
 */

class AccessAnnotation extends Annotation {
  AccessAnnotation() { this.getType().hasQualifiedName("javax.persistence", "Access") }
}

class AccessTypeAnnotation extends Annotation {
  AccessTypeAnnotation() { this.getType().hasQualifiedName("javax.persistence", "AccessType") }
}

class AssociationOverrideAnnotation extends Annotation {
  AssociationOverrideAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "AssociationOverride")
  }
}

class AssociationOverridesAnnotation extends Annotation {
  AssociationOverridesAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "AssociationOverrides")
  }
}

class AttributeOverrideAnnotation extends Annotation {
  AttributeOverrideAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "AttributeOverride")
  }
}

class AttributeOverridesAnnotation extends Annotation {
  AttributeOverridesAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "AttributeOverrides")
  }
}

class BasicAnnotation extends Annotation {
  BasicAnnotation() { this.getType().hasQualifiedName("javax.persistence", "Basic") }
}

class CacheableAnnotation extends Annotation {
  CacheableAnnotation() { this.getType().hasQualifiedName("javax.persistence", "Cacheable") }
}

class CollectionTableAnnotation extends Annotation {
  CollectionTableAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "CollectionTable")
  }
}

class ColumnAnnotation extends Annotation {
  ColumnAnnotation() { this.getType().hasQualifiedName("javax.persistence", "Column") }
}

class ColumnResultAnnotation extends Annotation {
  ColumnResultAnnotation() { this.getType().hasQualifiedName("javax.persistence", "ColumnResult") }
}

class DiscriminatorColumnAnnotation extends Annotation {
  DiscriminatorColumnAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "DiscriminatorColumn")
  }
}

class DiscriminatorValueAnnotation extends Annotation {
  DiscriminatorValueAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "DiscriminatorValue")
  }
}

class ElementCollectionAnnotation extends Annotation {
  ElementCollectionAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "ElementCollection")
  }
}

class EmbeddableAnnotation extends Annotation {
  EmbeddableAnnotation() { this.getType().hasQualifiedName("javax.persistence", "Embeddable") }
}

class EmbeddedAnnotation extends Annotation {
  EmbeddedAnnotation() { this.getType().hasQualifiedName("javax.persistence", "Embedded") }
}

class EmbeddedIdAnnotation extends Annotation {
  EmbeddedIdAnnotation() { this.getType().hasQualifiedName("javax.persistence", "EmbeddedId") }
}

class EntityAnnotation extends Annotation {
  EntityAnnotation() { this.getType().hasQualifiedName("javax.persistence", "Entity") }
}

class EntityListenersAnnotation extends Annotation {
  EntityListenersAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "EntityListeners")
  }
}

class EntityResultAnnotation extends Annotation {
  EntityResultAnnotation() { this.getType().hasQualifiedName("javax.persistence", "EntityResult") }
}

class EnumeratedAnnotation extends Annotation {
  EnumeratedAnnotation() { this.getType().hasQualifiedName("javax.persistence", "Enumerated") }
}

class ExcludeDefaultListenersAnnotation extends Annotation {
  ExcludeDefaultListenersAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "ExcludeDefaultListeners")
  }
}

class ExcludeSuperclassListenersAnnotation extends Annotation {
  ExcludeSuperclassListenersAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "ExcludeSuperclassListeners")
  }
}

class FieldResultAnnotation extends Annotation {
  FieldResultAnnotation() { this.getType().hasQualifiedName("javax.persistence", "FieldResult") }
}

class GeneratedValueAnnotation extends Annotation {
  GeneratedValueAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "GeneratedValue")
  }
}

class IdAnnotation extends Annotation {
  IdAnnotation() { this.getType().hasQualifiedName("javax.persistence", "Id") }
}

class IdClassAnnotation extends Annotation {
  IdClassAnnotation() { this.getType().hasQualifiedName("javax.persistence", "IdClass") }
}

class InheritanceAnnotation extends Annotation {
  InheritanceAnnotation() { this.getType().hasQualifiedName("javax.persistence", "Inheritance") }
}

class JoinColumnAnnotation extends Annotation {
  JoinColumnAnnotation() { this.getType().hasQualifiedName("javax.persistence", "JoinColumn") }
}

class JoinColumnsAnnotation extends Annotation {
  JoinColumnsAnnotation() { this.getType().hasQualifiedName("javax.persistence", "JoinColumns") }
}

class JoinTableAnnotation extends Annotation {
  JoinTableAnnotation() { this.getType().hasQualifiedName("javax.persistence", "JoinTable") }
}

class LobAnnotation extends Annotation {
  LobAnnotation() { this.getType().hasQualifiedName("javax.persistence", "Lob") }
}

class ManyToManyAnnotation extends Annotation {
  ManyToManyAnnotation() { this.getType().hasQualifiedName("javax.persistence", "ManyToMany") }
}

class ManyToOneAnnotation extends Annotation {
  ManyToOneAnnotation() { this.getType().hasQualifiedName("javax.persistence", "ManyToOne") }
}

class MapKeyAnnotation extends Annotation {
  MapKeyAnnotation() { this.getType().hasQualifiedName("javax.persistence", "MapKey") }
}

class MapKeyClassAnnotation extends Annotation {
  MapKeyClassAnnotation() { this.getType().hasQualifiedName("javax.persistence", "MapKeyClass") }
}

class MapKeyColumnAnnotation extends Annotation {
  MapKeyColumnAnnotation() { this.getType().hasQualifiedName("javax.persistence", "MapKeyColumn") }
}

class MapKeyEnumeratedAnnotation extends Annotation {
  MapKeyEnumeratedAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "MapKeyEnumerated")
  }
}

class MapKeyJoinColumnAnnotation extends Annotation {
  MapKeyJoinColumnAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "MapKeyJoinColumn")
  }
}

class MapKeyJoinColumnsAnnotation extends Annotation {
  MapKeyJoinColumnsAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "MapKeyJoinColumns")
  }
}

class MapKeyTemporalAnnotation extends Annotation {
  MapKeyTemporalAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "MapKeyTemporal")
  }
}

class MappedSuperclassAnnotation extends Annotation {
  MappedSuperclassAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "MappedSuperclass")
  }
}

class MapsIdAnnotation extends Annotation {
  MapsIdAnnotation() { this.getType().hasQualifiedName("javax.persistence", "MapsId") }
}

class NamedNativeQueriesAnnotation extends Annotation {
  NamedNativeQueriesAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "NamedNativeQueries")
  }
}

class NamedNativeQueryAnnotation extends Annotation {
  NamedNativeQueryAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "NamedNativeQuery")
  }
}

class NamedQueriesAnnotation extends Annotation {
  NamedQueriesAnnotation() { this.getType().hasQualifiedName("javax.persistence", "NamedQueries") }
}

class NamedQueryAnnotation extends Annotation {
  NamedQueryAnnotation() { this.getType().hasQualifiedName("javax.persistence", "NamedQuery") }
}

class OneToManyAnnotation extends Annotation {
  OneToManyAnnotation() { this.getType().hasQualifiedName("javax.persistence", "OneToMany") }
}

class OneToOneAnnotation extends Annotation {
  OneToOneAnnotation() { this.getType().hasQualifiedName("javax.persistence", "OneToOne") }
}

class OrderByAnnotation extends Annotation {
  OrderByAnnotation() { this.getType().hasQualifiedName("javax.persistence", "OrderBy") }
}

class OrderColumnAnnotation extends Annotation {
  OrderColumnAnnotation() { this.getType().hasQualifiedName("javax.persistence", "OrderColumn") }
}

class PersistenceContextAnnotation extends Annotation {
  PersistenceContextAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "PersistenceContext")
  }
}

class PersistenceContextsAnnotation extends Annotation {
  PersistenceContextsAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "PersistenceContexts")
  }
}

class PersistencePropertyAnnotation extends Annotation {
  PersistencePropertyAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "PersistenceProperty")
  }
}

class PersistenceUnitAnnotation extends Annotation {
  PersistenceUnitAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "PersistenceUnit")
  }
}

class PersistenceUnitsAnnotation extends Annotation {
  PersistenceUnitsAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "PersistenceUnits")
  }
}

class PostLoadAnnotation extends Annotation {
  PostLoadAnnotation() { this.getType().hasQualifiedName("javax.persistence", "PostLoad") }
}

class PostPersistAnnotation extends Annotation {
  PostPersistAnnotation() { this.getType().hasQualifiedName("javax.persistence", "PostPersist") }
}

class PostRemoveAnnotation extends Annotation {
  PostRemoveAnnotation() { this.getType().hasQualifiedName("javax.persistence", "PostRemove") }
}

class PostUpdateAnnotation extends Annotation {
  PostUpdateAnnotation() { this.getType().hasQualifiedName("javax.persistence", "PostUpdate") }
}

class PrePersistAnnotation extends Annotation {
  PrePersistAnnotation() { this.getType().hasQualifiedName("javax.persistence", "PrePersist") }
}

class PreRemoveAnnotation extends Annotation {
  PreRemoveAnnotation() { this.getType().hasQualifiedName("javax.persistence", "PreRemove") }
}

class PreUpdateAnnotation extends Annotation {
  PreUpdateAnnotation() { this.getType().hasQualifiedName("javax.persistence", "PreUpdate") }
}

class PrimaryKeyJoinColumnAnnotation extends Annotation {
  PrimaryKeyJoinColumnAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "PrimaryKeyJoinColumn")
  }
}

class PrimaryKeyJoinColumnsAnnotation extends Annotation {
  PrimaryKeyJoinColumnsAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "PrimaryKeyJoinColumns")
  }
}

class QueryHintAnnotation extends Annotation {
  QueryHintAnnotation() { this.getType().hasQualifiedName("javax.persistence", "QueryHint") }
}

class SecondaryTableAnnotation extends Annotation {
  SecondaryTableAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "SecondaryTable")
  }
}

class SecondaryTablesAnnotation extends Annotation {
  SecondaryTablesAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "SecondaryTables")
  }
}

class SequenceGeneratorAnnotation extends Annotation {
  SequenceGeneratorAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "SequenceGenerator")
  }
}

class SqlResultSetMappingAnnotation extends Annotation {
  SqlResultSetMappingAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "SqlResultSetMapping")
  }
}

class SqlResultSetMappingsAnnotation extends Annotation {
  SqlResultSetMappingsAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "SqlResultSetMappings")
  }
}

class TableAnnotation extends Annotation {
  TableAnnotation() { this.getType().hasQualifiedName("javax.persistence", "Table") }
}

class TableGeneratorAnnotation extends Annotation {
  TableGeneratorAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "TableGenerator")
  }
}

class TemporalAnnotation extends Annotation {
  TemporalAnnotation() { this.getType().hasQualifiedName("javax.persistence", "Temporal") }
}

class TransientAnnotation extends Annotation {
  TransientAnnotation() { this.getType().hasQualifiedName("javax.persistence", "Transient") }
}

class UniqueConstraintAnnotation extends Annotation {
  UniqueConstraintAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "UniqueConstraint")
  }
}

class VersionAnnotation extends Annotation {
  VersionAnnotation() { this.getType().hasQualifiedName("javax.persistence", "Version") }
}

/** The interface `javax.persistence.EntityManager`. */
class TypeEntityManager extends Interface {
  TypeEntityManager() { this.hasQualifiedName("javax.persistence", "EntityManager") }

  /** Gets a method named `createQuery` declared in the `EntityManager` interface. */
  Method getACreateQueryMethod() {
    result.hasName("createQuery") and
    result = this.getAMethod()
  }

  /** Gets a method named `createNamedQuery` declared in the `EntityManager` interface. */
  Method getACreateNamedQueryMethod() {
    result.hasName("createNamedQuery") and
    result = this.getAMethod()
  }

  /** Gets a method named `createNativeQuery` declared in the `EntityManager` interface. */
  Method getACreateNativeQueryMethod() {
    result.hasName("createNativeQuery") and
    result = this.getAMethod()
  }
}

/** The interface `javax.persistence.Query`, which represents queries in the Java Persistence Query Language. */
class TypeQuery extends Interface {
  TypeQuery() { this.hasQualifiedName("javax.persistence", "Query") }

  /** Gets a method named `setParameter` declared in the `Query` interface. */
  Method getASetParameterMethod() {
    result.hasName("setParameter") and
    result = this.getAMethod()
  }
}
