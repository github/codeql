/**
 * Provides classes and predicates for working with the JavaEE Persistence API.
 */

import java

/**
 * Gets a JavaEE Persistence API package name.
 */
string getAPersistencePackageName() { result = ["javax.persistence", "jakarta.persistence"] }

/**
 * A `RefType` with the `@Entity` annotation that indicates that it can be persisted using a JPA
 * compatible framework.
 */
class PersistentEntity extends RefType {
  PersistentEntity() {
    this.getAnAnnotation() instanceof EntityAnnotation or
    this.getAnAnnotation() instanceof EmbeddableAnnotation
  }

  /**
   * Gets the access type for this entity.
   *
   * The access type is either FIELD or METHOD. In the former case, persistence is achieved by
   * reading and writing the fields directly. In the latter case, setters and getters are used
   * instead.
   */
  string getAccessType() {
    if exists(this.getAccessTypeFromAnnotation())
    then result = this.getAccessTypeFromAnnotation()
    else
      // If the access type is not explicit, then the location of the `Id` annotation determines
      // which access type is used.
      if this.getAMethod().hasAnnotation(getAPersistencePackageName(), "Id")
      then result = "property"
      else result = "field"
  }

  /**
   * Gets the access type for this entity as defined by a `@{javax,jakarta}.persistence.Access` annotation,
   * if any, in lower case.
   */
  string getAccessTypeFromAnnotation() {
    exists(AccessAnnotation accessType | accessType = this.getAnAnnotation() |
      result = accessType.getEnumConstantValue("value").getName().toLowerCase()
    )
  }
}

/*
 * Annotations in the `{javax,jakarta}.persistence` package.
 */

/**
 * A `@{javax,jakarta}.persistence.Access` annotation.
 */
class AccessAnnotation extends Annotation {
  AccessAnnotation() { this.getType().hasQualifiedName(getAPersistencePackageName(), "Access") }
}

/**
 * A `@{javax,jakarta}.persistence.AccessType` annotation.
 */
class AccessTypeAnnotation extends Annotation {
  AccessTypeAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "AccessType")
  }
}

/**
 * A `@{javax,jakarta}.persistence.AssociationOverride` annotation.
 */
class AssociationOverrideAnnotation extends Annotation {
  AssociationOverrideAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "AssociationOverride")
  }
}

/**
 * A `@{javax,jakarta}.persistence.AssociationOverrides` annotation.
 */
class AssociationOverridesAnnotation extends Annotation {
  AssociationOverridesAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "AssociationOverrides")
  }
}

/**
 * A `@{javax,jakarta}.persistence.AttributeOverride` annotation.
 */
class AttributeOverrideAnnotation extends Annotation {
  AttributeOverrideAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "AttributeOverride")
  }
}

/**
 * A `@{javax,jakarta}.persistence.AttributeOverrides` annotation.
 */
class AttributeOverridesAnnotation extends Annotation {
  AttributeOverridesAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "AttributeOverrides")
  }
}

/**
 * A `@{javax,jakarta}.persistence.Basic` annotation.
 */
class BasicAnnotation extends Annotation {
  BasicAnnotation() { this.getType().hasQualifiedName(getAPersistencePackageName(), "Basic") }
}

/**
 * A `@{javax,jakarta}.persistence.Cacheable` annotation.
 */
class CacheableAnnotation extends Annotation {
  CacheableAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "Cacheable")
  }
}

/**
 * A `@{javax,jakarta}.persistence.CollectionTable` annotation.
 */
class CollectionTableAnnotation extends Annotation {
  CollectionTableAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "CollectionTable")
  }
}

/**
 * A `@{javax,jakarta}.persistence.Column` annotation.
 */
class ColumnAnnotation extends Annotation {
  ColumnAnnotation() { this.getType().hasQualifiedName(getAPersistencePackageName(), "Column") }
}

/**
 * A `@{javax,jakarta}.persistence.ColumnResult` annotation.
 */
class ColumnResultAnnotation extends Annotation {
  ColumnResultAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "ColumnResult")
  }
}

/**
 * A `@{javax,jakarta}.persistence.DiscriminatorColumn` annotation.
 */
class DiscriminatorColumnAnnotation extends Annotation {
  DiscriminatorColumnAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "DiscriminatorColumn")
  }
}

/**
 * A `@{javax,jakarta}.persistence.DiscriminatorValue` annotation.
 */
class DiscriminatorValueAnnotation extends Annotation {
  DiscriminatorValueAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "DiscriminatorValue")
  }
}

/**
 * A `@{javax,jakarta}.persistence.ElementCollection` annotation.
 */
class ElementCollectionAnnotation extends Annotation {
  ElementCollectionAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "ElementCollection")
  }
}

/**
 * A `@{javax,jakarta}.persistence.Embeddable` annotation.
 */
class EmbeddableAnnotation extends Annotation {
  EmbeddableAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "Embeddable")
  }
}

/**
 * A `@{javax,jakarta}.persistence.Embedded` annotation.
 */
class EmbeddedAnnotation extends Annotation {
  EmbeddedAnnotation() { this.getType().hasQualifiedName(getAPersistencePackageName(), "Embedded") }
}

/**
 * A `@{javax,jakarta}.persistence.EmbeddedId` annotation.
 */
class EmbeddedIdAnnotation extends Annotation {
  EmbeddedIdAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "EmbeddedId")
  }
}

/**
 * A `@{javax,jakarta}.persistence.Entity` annotation.
 */
class EntityAnnotation extends Annotation {
  EntityAnnotation() { this.getType().hasQualifiedName(getAPersistencePackageName(), "Entity") }
}

/**
 * A `@{javax,jakarta}.persistence.EntityListeners` annotation.
 */
class EntityListenersAnnotation extends Annotation {
  EntityListenersAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "EntityListeners")
  }
}

/**
 * A `@{javax,jakarta}.persistence.EntityResult` annotation.
 */
class EntityResultAnnotation extends Annotation {
  EntityResultAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "EntityResult")
  }
}

/**
 * A `@{javax,jakarta}.persistence.Enumerated` annotation.
 */
class EnumeratedAnnotation extends Annotation {
  EnumeratedAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "Enumerated")
  }
}

/**
 * A `@{javax,jakarta}.persistence.ExcludeDefaultListeners` annotation.
 */
class ExcludeDefaultListenersAnnotation extends Annotation {
  ExcludeDefaultListenersAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "ExcludeDefaultListeners")
  }
}

/**
 * A `@{javax,jakarta}.persistence.ExcludeSuperclassListeners` annotation.
 */
class ExcludeSuperclassListenersAnnotation extends Annotation {
  ExcludeSuperclassListenersAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "ExcludeSuperclassListeners")
  }
}

/**
 * A `@{javax,jakarta}.persistence.FieldResult` annotation.
 */
class FieldResultAnnotation extends Annotation {
  FieldResultAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "FieldResult")
  }
}

/**
 * A `@{javax,jakarta}.persistence.GeneratedValue` annotation.
 */
class GeneratedValueAnnotation extends Annotation {
  GeneratedValueAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "GeneratedValue")
  }
}

/**
 * A `@{javax,jakarta}.persistence.Id` annotation.
 */
class IdAnnotation extends Annotation {
  IdAnnotation() { this.getType().hasQualifiedName(getAPersistencePackageName(), "Id") }
}

/**
 * A `@{javax,jakarta}.persistence.IdClass` annotation.
 */
class IdClassAnnotation extends Annotation {
  IdClassAnnotation() { this.getType().hasQualifiedName(getAPersistencePackageName(), "IdClass") }
}

/**
 * A `@{javax,jakarta}.persistence.Inheritance` annotation.
 */
class InheritanceAnnotation extends Annotation {
  InheritanceAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "Inheritance")
  }
}

/**
 * A `@{javax,jakarta}.persistence.JoinColumn` annotation.
 */
class JoinColumnAnnotation extends Annotation {
  JoinColumnAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "JoinColumn")
  }
}

/**
 * A `@{javax,jakarta}.persistence.JoinColumns` annotation.
 */
class JoinColumnsAnnotation extends Annotation {
  JoinColumnsAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "JoinColumns")
  }
}

/**
 * A `@{javax,jakarta}.persistence.JoinTable` annotation.
 */
class JoinTableAnnotation extends Annotation {
  JoinTableAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "JoinTable")
  }
}

/**
 * A `@{javax,jakarta}.persistence.Lob` annotation.
 */
class LobAnnotation extends Annotation {
  LobAnnotation() { this.getType().hasQualifiedName(getAPersistencePackageName(), "Lob") }
}

/**
 * A `@{javax,jakarta}.persistence.ManyToMany` annotation.
 */
class ManyToManyAnnotation extends Annotation {
  ManyToManyAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "ManyToMany")
  }
}

/**
 * A `@{javax,jakarta}.persistence.ManyToOne` annotation.
 */
class ManyToOneAnnotation extends Annotation {
  ManyToOneAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "ManyToOne")
  }
}

/**
 * A `@{javax,jakarta}.persistence.MapKey` annotation.
 */
class MapKeyAnnotation extends Annotation {
  MapKeyAnnotation() { this.getType().hasQualifiedName(getAPersistencePackageName(), "MapKey") }
}

/**
 * A `@{javax,jakarta}.persistence.MapKeyClass` annotation.
 */
class MapKeyClassAnnotation extends Annotation {
  MapKeyClassAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "MapKeyClass")
  }
}

/**
 * A `@{javax,jakarta}.persistence.MapKeyColumn` annotation.
 */
class MapKeyColumnAnnotation extends Annotation {
  MapKeyColumnAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "MapKeyColumn")
  }
}

/**
 * A `@{javax,jakarta}.persistence.MapKeyEnumerated` annotation.
 */
class MapKeyEnumeratedAnnotation extends Annotation {
  MapKeyEnumeratedAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "MapKeyEnumerated")
  }
}

/**
 * A `@{javax,jakarta}.persistence.MapKeyJoinColumn` annotation.
 */
class MapKeyJoinColumnAnnotation extends Annotation {
  MapKeyJoinColumnAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "MapKeyJoinColumn")
  }
}

/**
 * A `@{javax,jakarta}.persistence.MapKeyJoinColumns` annotation.
 */
class MapKeyJoinColumnsAnnotation extends Annotation {
  MapKeyJoinColumnsAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "MapKeyJoinColumns")
  }
}

/**
 * A `@{javax,jakarta}.persistence.MapKeyTemporal` annotation.
 */
class MapKeyTemporalAnnotation extends Annotation {
  MapKeyTemporalAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "MapKeyTemporal")
  }
}

/**
 * A `@{javax,jakarta}.persistence.MappedSuperclass` annotation.
 */
class MappedSuperclassAnnotation extends Annotation {
  MappedSuperclassAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "MappedSuperclass")
  }
}

/**
 * A `@{javax,jakarta}.persistence.MapsId` annotation.
 */
class MapsIdAnnotation extends Annotation {
  MapsIdAnnotation() { this.getType().hasQualifiedName(getAPersistencePackageName(), "MapsId") }
}

/**
 * A `@{javax,jakarta}.persistence.NamedNativeQueries` annotation.
 */
class NamedNativeQueriesAnnotation extends Annotation {
  NamedNativeQueriesAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "NamedNativeQueries")
  }
}

/**
 * A `@{javax,jakarta}.persistence.NamedNativeQuery` annotation.
 */
class NamedNativeQueryAnnotation extends Annotation {
  NamedNativeQueryAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "NamedNativeQuery")
  }
}

/**
 * A `@{javax,jakarta}.persistence.NamedQueries` annotation.
 */
class NamedQueriesAnnotation extends Annotation {
  NamedQueriesAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "NamedQueries")
  }
}

/**
 * A `@{javax,jakarta}.persistence.NamedQuery` annotation.
 */
class NamedQueryAnnotation extends Annotation {
  NamedQueryAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "NamedQuery")
  }
}

/**
 * A `@{javax,jakarta}.persistence.OneToMany` annotation.
 */
class OneToManyAnnotation extends Annotation {
  OneToManyAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "OneToMany")
  }
}

/**
 * A `@{javax,jakarta}.persistence.OneToOne` annotation.
 */
class OneToOneAnnotation extends Annotation {
  OneToOneAnnotation() { this.getType().hasQualifiedName(getAPersistencePackageName(), "OneToOne") }
}

/**
 * A `@{javax,jakarta}.persistence.OrderBy` annotation.
 */
class OrderByAnnotation extends Annotation {
  OrderByAnnotation() { this.getType().hasQualifiedName(getAPersistencePackageName(), "OrderBy") }
}

/**
 * A `@{javax,jakarta}.persistence.OrderColumn` annotation.
 */
class OrderColumnAnnotation extends Annotation {
  OrderColumnAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "OrderColumn")
  }
}

/**
 * A `@{javax,jakarta}.persistence.PersistenceContext` annotation.
 */
class PersistenceContextAnnotation extends Annotation {
  PersistenceContextAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "PersistenceContext")
  }
}

/**
 * A `@{javax,jakarta}.persistence.PersistenceContexts` annotation.
 */
class PersistenceContextsAnnotation extends Annotation {
  PersistenceContextsAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "PersistenceContexts")
  }
}

/**
 * A `@{javax,jakarta}.persistence.PersistenceProperty` annotation.
 */
class PersistencePropertyAnnotation extends Annotation {
  PersistencePropertyAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "PersistenceProperty")
  }
}

/**
 * A `@{javax,jakarta}.persistence.PersistenceUnit` annotation.
 */
class PersistenceUnitAnnotation extends Annotation {
  PersistenceUnitAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "PersistenceUnit")
  }
}

/**
 * A `@{javax,jakarta}.persistence.PersistenceUnits` annotation.
 */
class PersistenceUnitsAnnotation extends Annotation {
  PersistenceUnitsAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "PersistenceUnits")
  }
}

/**
 * A `@{javax,jakarta}.persistence.PostLoad` annotation.
 */
class PostLoadAnnotation extends Annotation {
  PostLoadAnnotation() { this.getType().hasQualifiedName(getAPersistencePackageName(), "PostLoad") }
}

/**
 * A `@{javax,jakarta}.persistence.PostPersist` annotation.
 */
class PostPersistAnnotation extends Annotation {
  PostPersistAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "PostPersist")
  }
}

/**
 * A `@{javax,jakarta}.persistence.PostRemove` annotation.
 */
class PostRemoveAnnotation extends Annotation {
  PostRemoveAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "PostRemove")
  }
}

/**
 * A `@{javax,jakarta}.persistence.PostUpdate` annotation.
 */
class PostUpdateAnnotation extends Annotation {
  PostUpdateAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "PostUpdate")
  }
}

/**
 * A `@{javax,jakarta}.persistence.PrePersist` annotation.
 */
class PrePersistAnnotation extends Annotation {
  PrePersistAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "PrePersist")
  }
}

/**
 * A `@{javax,jakarta}.persistence.PreRemove` annotation.
 */
class PreRemoveAnnotation extends Annotation {
  PreRemoveAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "PreRemove")
  }
}

/**
 * A `@{javax,jakarta}.persistence.PreUpdate` annotation.
 */
class PreUpdateAnnotation extends Annotation {
  PreUpdateAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "PreUpdate")
  }
}

/**
 * A `@{javax,jakarta}.persistence.PrimaryKeyJoinColumn` annotation.
 */
class PrimaryKeyJoinColumnAnnotation extends Annotation {
  PrimaryKeyJoinColumnAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "PrimaryKeyJoinColumn")
  }
}

/**
 * A `@{javax,jakarta}.persistence.PrimaryKeyJoinColumns` annotation.
 */
class PrimaryKeyJoinColumnsAnnotation extends Annotation {
  PrimaryKeyJoinColumnsAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "PrimaryKeyJoinColumns")
  }
}

/**
 * A `@{javax,jakarta}.persistence.QueryHint` annotation.
 */
class QueryHintAnnotation extends Annotation {
  QueryHintAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "QueryHint")
  }
}

/**
 * A `@{javax,jakarta}.persistence.SecondaryTable` annotation.
 */
class SecondaryTableAnnotation extends Annotation {
  SecondaryTableAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "SecondaryTable")
  }
}

/**
 * A `@{javax,jakarta}.persistence.SecondaryTables` annotation.
 */
class SecondaryTablesAnnotation extends Annotation {
  SecondaryTablesAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "SecondaryTables")
  }
}

/**
 * A `@{javax,jakarta}.persistence.SequenceGenerator` annotation.
 */
class SequenceGeneratorAnnotation extends Annotation {
  SequenceGeneratorAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "SequenceGenerator")
  }
}

/**
 * A `@{javax,jakarta}.persistence.SqlResultSetMapping` annotation.
 */
class SqlResultSetMappingAnnotation extends Annotation {
  SqlResultSetMappingAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "SqlResultSetMapping")
  }
}

/**
 * A `@{javax,jakarta}.persistence.SqlResultSetMappings` annotation.
 */
class SqlResultSetMappingsAnnotation extends Annotation {
  SqlResultSetMappingsAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "SqlResultSetMappings")
  }
}

/**
 * A `@{javax,jakarta}.persistence.Table` annotation.
 */
class TableAnnotation extends Annotation {
  TableAnnotation() { this.getType().hasQualifiedName(getAPersistencePackageName(), "Table") }
}

/**
 * A `@{javax,jakarta}.persistence.TableGenerator` annotation.
 */
class TableGeneratorAnnotation extends Annotation {
  TableGeneratorAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "TableGenerator")
  }
}

/**
 * A `@{javax,jakarta}.persistence.Temporal` annotation.
 */
class TemporalAnnotation extends Annotation {
  TemporalAnnotation() { this.getType().hasQualifiedName(getAPersistencePackageName(), "Temporal") }
}

/**
 * A `@{javax,jakarta}.persistence.Transient` annotation.
 */
class TransientAnnotation extends Annotation {
  TransientAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "Transient")
  }
}

/**
 * A `@{javax,jakarta}.persistence.UniqueConstraint` annotation.
 */
class UniqueConstraintAnnotation extends Annotation {
  UniqueConstraintAnnotation() {
    this.getType().hasQualifiedName(getAPersistencePackageName(), "UniqueConstraint")
  }
}

/**
 * A `@{javax,jakarta}.persistence.Version` annotation.
 */
class VersionAnnotation extends Annotation {
  VersionAnnotation() { this.getType().hasQualifiedName(getAPersistencePackageName(), "Version") }
}

/** The interface `{javax,jakarta}.persistence.EntityManager`. */
class TypeEntityManager extends Interface {
  TypeEntityManager() { this.hasQualifiedName(getAPersistencePackageName(), "EntityManager") }

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

/** The interface `{javax,jakarta}.persistence.Query`, which represents queries in the Java Persistence Query Language. */
class TypeQuery extends Interface {
  TypeQuery() { this.hasQualifiedName(getAPersistencePackageName(), "Query") }

  /** Gets a method named `setParameter` declared in the `Query` interface. */
  Method getASetParameterMethod() {
    result.hasName("setParameter") and
    result = this.getAMethod()
  }
}
