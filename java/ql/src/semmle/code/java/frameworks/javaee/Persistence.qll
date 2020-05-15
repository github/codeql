/**
 * Provides classes and predicates for working with the JavaEE Persistence API.
 */

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
   * Gets the access type for this entity as defined by a `@javax.persistence.Access` annotation, if any.
   */
  string getAccessTypeFromAnnotation() {
    exists(AccessAnnotation accessType | accessType = getAnAnnotation() |
      result =
        accessType.getValue("value").(FieldRead).getField().(EnumConstant).getName().toLowerCase()
    )
  }
}

/*
 * Annotations in the `javax.persistence` package.
 */

/**
 * A `@javax.persistence.Access` annotation.
 */
class AccessAnnotation extends Annotation {
  AccessAnnotation() { this.getType().hasQualifiedName("javax.persistence", "Access") }
}

/**
 * A `@javax.persistence.AccessType` annotation.
 */
class AccessTypeAnnotation extends Annotation {
  AccessTypeAnnotation() { this.getType().hasQualifiedName("javax.persistence", "AccessType") }
}

/**
 * A `@javax.persistence.AssociationOverride` annotation.
 */
class AssociationOverrideAnnotation extends Annotation {
  AssociationOverrideAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "AssociationOverride")
  }
}

/**
 * A `@javax.persistence.AssociationOverrides` annotation.
 */
class AssociationOverridesAnnotation extends Annotation {
  AssociationOverridesAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "AssociationOverrides")
  }
}

/**
 * A `@javax.persistence.AttributeOverride` annotation.
 */
class AttributeOverrideAnnotation extends Annotation {
  AttributeOverrideAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "AttributeOverride")
  }
}

/**
 * A `@javax.persistence.AttributeOverrides` annotation.
 */
class AttributeOverridesAnnotation extends Annotation {
  AttributeOverridesAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "AttributeOverrides")
  }
}

/**
 * A `@javax.persistence.Basic` annotation.
 */
class BasicAnnotation extends Annotation {
  BasicAnnotation() { this.getType().hasQualifiedName("javax.persistence", "Basic") }
}

/**
 * A `@javax.persistence.Cacheable` annotation.
 */
class CacheableAnnotation extends Annotation {
  CacheableAnnotation() { this.getType().hasQualifiedName("javax.persistence", "Cacheable") }
}

/**
 * A `@javax.persistence.CollectionTable` annotation.
 */
class CollectionTableAnnotation extends Annotation {
  CollectionTableAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "CollectionTable")
  }
}

/**
 * A `@javax.persistence.Column` annotation.
 */
class ColumnAnnotation extends Annotation {
  ColumnAnnotation() { this.getType().hasQualifiedName("javax.persistence", "Column") }
}

/**
 * A `@javax.persistence.ColumnResult` annotation.
 */
class ColumnResultAnnotation extends Annotation {
  ColumnResultAnnotation() { this.getType().hasQualifiedName("javax.persistence", "ColumnResult") }
}

/**
 * A `@javax.persistence.DiscriminatorColumn` annotation.
 */
class DiscriminatorColumnAnnotation extends Annotation {
  DiscriminatorColumnAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "DiscriminatorColumn")
  }
}

/**
 * A `@javax.persistence.DiscriminatorValue` annotation.
 */
class DiscriminatorValueAnnotation extends Annotation {
  DiscriminatorValueAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "DiscriminatorValue")
  }
}

/**
 * A `@javax.persistence.ElementCollection` annotation.
 */
class ElementCollectionAnnotation extends Annotation {
  ElementCollectionAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "ElementCollection")
  }
}

/**
 * A `@javax.persistence.Embeddable` annotation.
 */
class EmbeddableAnnotation extends Annotation {
  EmbeddableAnnotation() { this.getType().hasQualifiedName("javax.persistence", "Embeddable") }
}

/**
 * A `@javax.persistence.Embedded` annotation.
 */
class EmbeddedAnnotation extends Annotation {
  EmbeddedAnnotation() { this.getType().hasQualifiedName("javax.persistence", "Embedded") }
}

/**
 * A `@javax.persistence.EmbeddedId` annotation.
 */
class EmbeddedIdAnnotation extends Annotation {
  EmbeddedIdAnnotation() { this.getType().hasQualifiedName("javax.persistence", "EmbeddedId") }
}

/**
 * A `@javax.persistence.Entity` annotation.
 */
class EntityAnnotation extends Annotation {
  EntityAnnotation() { this.getType().hasQualifiedName("javax.persistence", "Entity") }
}

/**
 * A `@javax.persistence.EntityListeners` annotation.
 */
class EntityListenersAnnotation extends Annotation {
  EntityListenersAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "EntityListeners")
  }
}

/**
 * A `@javax.persistence.EntityResult` annotation.
 */
class EntityResultAnnotation extends Annotation {
  EntityResultAnnotation() { this.getType().hasQualifiedName("javax.persistence", "EntityResult") }
}

/**
 * A `@javax.persistence.Enumerated` annotation.
 */
class EnumeratedAnnotation extends Annotation {
  EnumeratedAnnotation() { this.getType().hasQualifiedName("javax.persistence", "Enumerated") }
}

/**
 * A `@javax.persistence.ExcludeDefaultListeners` annotation.
 */
class ExcludeDefaultListenersAnnotation extends Annotation {
  ExcludeDefaultListenersAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "ExcludeDefaultListeners")
  }
}

/**
 * A `@javax.persistence.ExcludeSuperclassListeners` annotation.
 */
class ExcludeSuperclassListenersAnnotation extends Annotation {
  ExcludeSuperclassListenersAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "ExcludeSuperclassListeners")
  }
}

/**
 * A `@javax.persistence.FieldResult` annotation.
 */
class FieldResultAnnotation extends Annotation {
  FieldResultAnnotation() { this.getType().hasQualifiedName("javax.persistence", "FieldResult") }
}

/**
 * A `@javax.persistence.GeneratedValue` annotation.
 */
class GeneratedValueAnnotation extends Annotation {
  GeneratedValueAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "GeneratedValue")
  }
}

/**
 * A `@javax.persistence.Id` annotation.
 */
class IdAnnotation extends Annotation {
  IdAnnotation() { this.getType().hasQualifiedName("javax.persistence", "Id") }
}

/**
 * A `@javax.persistence.IdClass` annotation.
 */
class IdClassAnnotation extends Annotation {
  IdClassAnnotation() { this.getType().hasQualifiedName("javax.persistence", "IdClass") }
}

/**
 * A `@javax.persistence.Inheritance` annotation.
 */
class InheritanceAnnotation extends Annotation {
  InheritanceAnnotation() { this.getType().hasQualifiedName("javax.persistence", "Inheritance") }
}

/**
 * A `@javax.persistence.JoinColumn` annotation.
 */
class JoinColumnAnnotation extends Annotation {
  JoinColumnAnnotation() { this.getType().hasQualifiedName("javax.persistence", "JoinColumn") }
}

/**
 * A `@javax.persistence.JoinColumns` annotation.
 */
class JoinColumnsAnnotation extends Annotation {
  JoinColumnsAnnotation() { this.getType().hasQualifiedName("javax.persistence", "JoinColumns") }
}

/**
 * A `@javax.persistence.JoinTable` annotation.
 */
class JoinTableAnnotation extends Annotation {
  JoinTableAnnotation() { this.getType().hasQualifiedName("javax.persistence", "JoinTable") }
}

/**
 * A `@javax.persistence.Lob` annotation.
 */
class LobAnnotation extends Annotation {
  LobAnnotation() { this.getType().hasQualifiedName("javax.persistence", "Lob") }
}

/**
 * A `@javax.persistence.ManyToMany` annotation.
 */
class ManyToManyAnnotation extends Annotation {
  ManyToManyAnnotation() { this.getType().hasQualifiedName("javax.persistence", "ManyToMany") }
}

/**
 * A `@javax.persistence.ManyToOne` annotation.
 */
class ManyToOneAnnotation extends Annotation {
  ManyToOneAnnotation() { this.getType().hasQualifiedName("javax.persistence", "ManyToOne") }
}

/**
 * A `@javax.persistence.MapKey` annotation.
 */
class MapKeyAnnotation extends Annotation {
  MapKeyAnnotation() { this.getType().hasQualifiedName("javax.persistence", "MapKey") }
}

/**
 * A `@javax.persistence.MapKeyClass` annotation.
 */
class MapKeyClassAnnotation extends Annotation {
  MapKeyClassAnnotation() { this.getType().hasQualifiedName("javax.persistence", "MapKeyClass") }
}

/**
 * A `@javax.persistence.MapKeyColumn` annotation.
 */
class MapKeyColumnAnnotation extends Annotation {
  MapKeyColumnAnnotation() { this.getType().hasQualifiedName("javax.persistence", "MapKeyColumn") }
}

/**
 * A `@javax.persistence.MapKeyEnumerated` annotation.
 */
class MapKeyEnumeratedAnnotation extends Annotation {
  MapKeyEnumeratedAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "MapKeyEnumerated")
  }
}

/**
 * A `@javax.persistence.MapKeyJoinColumn` annotation.
 */
class MapKeyJoinColumnAnnotation extends Annotation {
  MapKeyJoinColumnAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "MapKeyJoinColumn")
  }
}

/**
 * A `@javax.persistence.MapKeyJoinColumns` annotation.
 */
class MapKeyJoinColumnsAnnotation extends Annotation {
  MapKeyJoinColumnsAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "MapKeyJoinColumns")
  }
}

/**
 * A `@javax.persistence.MapKeyTemporal` annotation.
 */
class MapKeyTemporalAnnotation extends Annotation {
  MapKeyTemporalAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "MapKeyTemporal")
  }
}

/**
 * A `@javax.persistence.MappedSuperclass` annotation.
 */
class MappedSuperclassAnnotation extends Annotation {
  MappedSuperclassAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "MappedSuperclass")
  }
}

/**
 * A `@javax.persistence.MapsId` annotation.
 */
class MapsIdAnnotation extends Annotation {
  MapsIdAnnotation() { this.getType().hasQualifiedName("javax.persistence", "MapsId") }
}

/**
 * A `@javax.persistence.NamedNativeQueries` annotation.
 */
class NamedNativeQueriesAnnotation extends Annotation {
  NamedNativeQueriesAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "NamedNativeQueries")
  }
}

/**
 * A `@javax.persistence.NamedNativeQuery` annotation.
 */
class NamedNativeQueryAnnotation extends Annotation {
  NamedNativeQueryAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "NamedNativeQuery")
  }
}

/**
 * A `@javax.persistence.NamedQueries` annotation.
 */
class NamedQueriesAnnotation extends Annotation {
  NamedQueriesAnnotation() { this.getType().hasQualifiedName("javax.persistence", "NamedQueries") }
}

/**
 * A `@javax.persistence.NamedQuery` annotation.
 */
class NamedQueryAnnotation extends Annotation {
  NamedQueryAnnotation() { this.getType().hasQualifiedName("javax.persistence", "NamedQuery") }
}

/**
 * A `@javax.persistence.OneToMany` annotation.
 */
class OneToManyAnnotation extends Annotation {
  OneToManyAnnotation() { this.getType().hasQualifiedName("javax.persistence", "OneToMany") }
}

/**
 * A `@javax.persistence.OneToOne` annotation.
 */
class OneToOneAnnotation extends Annotation {
  OneToOneAnnotation() { this.getType().hasQualifiedName("javax.persistence", "OneToOne") }
}

/**
 * A `@javax.persistence.OrderBy` annotation.
 */
class OrderByAnnotation extends Annotation {
  OrderByAnnotation() { this.getType().hasQualifiedName("javax.persistence", "OrderBy") }
}

/**
 * A `@javax.persistence.OrderColumn` annotation.
 */
class OrderColumnAnnotation extends Annotation {
  OrderColumnAnnotation() { this.getType().hasQualifiedName("javax.persistence", "OrderColumn") }
}

/**
 * A `@javax.persistence.PersistenceContext` annotation.
 */
class PersistenceContextAnnotation extends Annotation {
  PersistenceContextAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "PersistenceContext")
  }
}

/**
 * A `@javax.persistence.PersistenceContexts` annotation.
 */
class PersistenceContextsAnnotation extends Annotation {
  PersistenceContextsAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "PersistenceContexts")
  }
}

/**
 * A `@javax.persistence.PersistenceProperty` annotation.
 */
class PersistencePropertyAnnotation extends Annotation {
  PersistencePropertyAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "PersistenceProperty")
  }
}

/**
 * A `@javax.persistence.PersistenceUnit` annotation.
 */
class PersistenceUnitAnnotation extends Annotation {
  PersistenceUnitAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "PersistenceUnit")
  }
}

/**
 * A `@javax.persistence.PersistenceUnits` annotation.
 */
class PersistenceUnitsAnnotation extends Annotation {
  PersistenceUnitsAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "PersistenceUnits")
  }
}

/**
 * A `@javax.persistence.PostLoad` annotation.
 */
class PostLoadAnnotation extends Annotation {
  PostLoadAnnotation() { this.getType().hasQualifiedName("javax.persistence", "PostLoad") }
}

/**
 * A `@javax.persistence.PostPersist` annotation.
 */
class PostPersistAnnotation extends Annotation {
  PostPersistAnnotation() { this.getType().hasQualifiedName("javax.persistence", "PostPersist") }
}

/**
 * A `@javax.persistence.PostRemove` annotation.
 */
class PostRemoveAnnotation extends Annotation {
  PostRemoveAnnotation() { this.getType().hasQualifiedName("javax.persistence", "PostRemove") }
}

/**
 * A `@javax.persistence.PostUpdate` annotation.
 */
class PostUpdateAnnotation extends Annotation {
  PostUpdateAnnotation() { this.getType().hasQualifiedName("javax.persistence", "PostUpdate") }
}

/**
 * A `@javax.persistence.PrePersist` annotation.
 */
class PrePersistAnnotation extends Annotation {
  PrePersistAnnotation() { this.getType().hasQualifiedName("javax.persistence", "PrePersist") }
}

/**
 * A `@javax.persistence.PreRemove` annotation.
 */
class PreRemoveAnnotation extends Annotation {
  PreRemoveAnnotation() { this.getType().hasQualifiedName("javax.persistence", "PreRemove") }
}

/**
 * A `@javax.persistence.PreUpdate` annotation.
 */
class PreUpdateAnnotation extends Annotation {
  PreUpdateAnnotation() { this.getType().hasQualifiedName("javax.persistence", "PreUpdate") }
}

/**
 * A `@javax.persistence.PrimaryKeyJoinColumn` annotation.
 */
class PrimaryKeyJoinColumnAnnotation extends Annotation {
  PrimaryKeyJoinColumnAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "PrimaryKeyJoinColumn")
  }
}

/**
 * A `@javax.persistence.PrimaryKeyJoinColumns` annotation.
 */
class PrimaryKeyJoinColumnsAnnotation extends Annotation {
  PrimaryKeyJoinColumnsAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "PrimaryKeyJoinColumns")
  }
}

/**
 * A `@javax.persistence.QueryHint` annotation.
 */
class QueryHintAnnotation extends Annotation {
  QueryHintAnnotation() { this.getType().hasQualifiedName("javax.persistence", "QueryHint") }
}

/**
 * A `@javax.persistence.SecondaryTable` annotation.
 */
class SecondaryTableAnnotation extends Annotation {
  SecondaryTableAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "SecondaryTable")
  }
}

/**
 * A `@javax.persistence.SecondaryTables` annotation.
 */
class SecondaryTablesAnnotation extends Annotation {
  SecondaryTablesAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "SecondaryTables")
  }
}

/**
 * A `@javax.persistence.SequenceGenerator` annotation.
 */
class SequenceGeneratorAnnotation extends Annotation {
  SequenceGeneratorAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "SequenceGenerator")
  }
}

/**
 * A `@javax.persistence.SqlResultSetMapping` annotation.
 */
class SqlResultSetMappingAnnotation extends Annotation {
  SqlResultSetMappingAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "SqlResultSetMapping")
  }
}

/**
 * A `@javax.persistence.SqlResultSetMappings` annotation.
 */
class SqlResultSetMappingsAnnotation extends Annotation {
  SqlResultSetMappingsAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "SqlResultSetMappings")
  }
}

/**
 * A `@javax.persistence.Table` annotation.
 */
class TableAnnotation extends Annotation {
  TableAnnotation() { this.getType().hasQualifiedName("javax.persistence", "Table") }
}

/**
 * A `@javax.persistence.TableGenerator` annotation.
 */
class TableGeneratorAnnotation extends Annotation {
  TableGeneratorAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "TableGenerator")
  }
}

/**
 * A `@javax.persistence.Temporal` annotation.
 */
class TemporalAnnotation extends Annotation {
  TemporalAnnotation() { this.getType().hasQualifiedName("javax.persistence", "Temporal") }
}

/**
 * A `@javax.persistence.Transient` annotation.
 */
class TransientAnnotation extends Annotation {
  TransientAnnotation() { this.getType().hasQualifiedName("javax.persistence", "Transient") }
}

/**
 * A `@javax.persistence.UniqueConstraint` annotation.
 */
class UniqueConstraintAnnotation extends Annotation {
  UniqueConstraintAnnotation() {
    this.getType().hasQualifiedName("javax.persistence", "UniqueConstraint")
  }
}

/**
 * A `@javax.persistence.Version` annotation.
 */
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
