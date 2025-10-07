/**
 * Provides classes modeling security-relevant aspects of the `django` PyPI package.
 * See https://www.djangoproject.com/.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.frameworks.PEP249
private import semmle.python.frameworks.Stdlib
private import semmle.python.regex
private import semmle.python.frameworks.internal.PoorMansFunctionResolution
private import semmle.python.frameworks.internal.SelfRefMixin
private import semmle.python.frameworks.internal.InstanceTaintStepsHelper
private import semmle.python.security.dataflow.UrlRedirectCustomizations
private import semmle.python.frameworks.data.ModelsAsData

/**
 * INTERNAL: Do not use.
 *
 * Provides models for the `django` PyPI package.
 * See https://www.djangoproject.com/.
 */
module Django {
  /** Provides models for the `django.views` module */
  module Views {
    /**
     * Provides models for the `django.views.generic.View` class and subclasses.
     *
     * See
     *  - https://docs.djangoproject.com/en/3.1/topics/class-based-views/
     *  - https://docs.djangoproject.com/en/3.1/ref/class-based-views/
     */
    module View {
      /**
       * An `API::Node` representing the `django.views.generic.View` class or any subclass
       * that has explicitly been modeled in the CodeQL libraries.
       */
      abstract class ModeledSubclass extends API::Node {
        override string toString() { result = this.(API::Node).toString() }
      }

      /** A Django view subclass in the `django` package. */
      private class DjangoViewSubclassesInDjango extends ModeledSubclass {
        DjangoViewSubclassesInDjango() {
          exists(string moduleName, string className |
            // canonical definition
            this =
              API::moduleImport("django")
                  .getMember("views")
                  .getMember("generic")
                  .getMember(moduleName)
                  .getMember(className)
            or
            // aliases from `django.views.generic`
            this =
              API::moduleImport("django")
                  .getMember("views")
                  .getMember("generic")
                  .getMember(className)
          |
            moduleName = "base" and
            className in ["RedirectView", "TemplateView", "View"]
            or
            moduleName = "dates" and
            className in [
                "ArchiveIndexView", "DateDetailView", "DayArchiveView", "MonthArchiveView",
                "TodayArchiveView", "WeekArchiveView", "YearArchiveView"
              ]
            or
            moduleName = "detail" and
            className = "DetailView"
            or
            moduleName = "edit" and
            className in ["CreateView", "DeleteView", "FormView", "UpdateView"]
            or
            moduleName = "list" and
            className = "ListView"
          )
          or
          // `django.views.View` alias
          this = API::moduleImport("django").getMember("views").getMember("View")
        }
      }

      private class MaDSubclass extends ModeledSubclass {
        MaDSubclass() { this = ModelOutput::getATypeNode("Django.Views.View~Subclass") }
      }

      /** Gets a reference to the `django.views.generic.View` class or any subclass. */
      API::Node subclassRef() { result = any(ModeledSubclass subclass).getASubclass*() }
    }
  }

  /** Provides models for django forms (defined in the `django.forms` module) */
  module Forms {
    /**
     * Provides models for the `django.forms.forms.BaseForm` class and subclasses. This
     * is usually used by the `django.forms.forms.Form` class, which is also available
     * under the more commonly used alias `django.forms.Form`.
     *
     * See https://docs.djangoproject.com/en/3.1/ref/forms/api/
     */
    module Form {
      /**
       * An `API::Node` representing the `django.forms.forms.BaseForm` class or any subclass
       * that has explicitly been modeled in the CodeQL libraries.
       */
      abstract class ModeledSubclass extends API::Node {
        override string toString() { result = this.(API::Node).toString() }
      }

      /** A Django form subclass in the `django` package. */
      private class DjangoFormSubclassesInDjango extends ModeledSubclass {
        DjangoFormSubclassesInDjango() {
          // canonical definition
          this =
            API::moduleImport("django")
                .getMember("forms")
                .getMember("forms")
                .getMember(["BaseForm", "Form"])
          or
          this =
            API::moduleImport("django")
                .getMember("forms")
                .getMember("models")
                .getMember(["BaseModelForm", "ModelForm"])
          or
          // aliases from `django.forms`
          this =
            API::moduleImport("django")
                .getMember("forms")
                .getMember(["BaseForm", "Form", "BaseModelForm", "ModelForm"])
          or
          // other Form subclasses defined in Django
          this =
            API::moduleImport("django")
                .getMember("contrib")
                .getMember("admin")
                .getMember("forms")
                .getMember(["AdminAuthenticationForm", "AdminPasswordChangeForm"])
          or
          this =
            API::moduleImport("django")
                .getMember("contrib")
                .getMember("admin")
                .getMember("helpers")
                .getMember("ActionForm")
          or
          this =
            API::moduleImport("django")
                .getMember("contrib")
                .getMember("admin")
                .getMember("views")
                .getMember("main")
                .getMember("ChangeListSearchForm")
          or
          this =
            API::moduleImport("django")
                .getMember("contrib")
                .getMember("auth")
                .getMember("forms")
                .getMember([
                    "PasswordResetForm", "UserChangeForm", "SetPasswordForm",
                    "AdminPasswordChangeForm", "PasswordChangeForm", "AuthenticationForm",
                    "UserCreationForm"
                  ])
          or
          this =
            API::moduleImport("django")
                .getMember("contrib")
                .getMember("flatpages")
                .getMember("forms")
                .getMember("FlatpageForm")
          or
          this =
            API::moduleImport("django")
                .getMember("forms")
                .getMember("formsets")
                .getMember("ManagementForm")
          or
          this =
            API::moduleImport("django")
                .getMember("forms")
                .getMember("models")
                .getMember(["ModelForm", "BaseModelForm"])
        }
      }

      private class MaDSubclass extends ModeledSubclass {
        MaDSubclass() { this = ModelOutput::getATypeNode("django.forms.BaseForm~Subclass") }
      }

      /** Gets a reference to the `django.forms.forms.BaseForm` class or any subclass. */
      API::Node subclassRef() { result = any(ModeledSubclass subclass).getASubclass*() }
    }

    /**
     * Provides models for the `django.forms.fields.Field` class and subclasses. This is
     * also available under the more commonly used alias `django.forms.Field`.
     *
     * See https://docs.djangoproject.com/en/3.1/ref/forms/fields/
     */
    module Field {
      /**
       * An `API::Node` representing the `django.forms.fields.Field` class or any subclass
       * that has explicitly been modeled in the CodeQL libraries.
       */
      abstract class ModeledSubclass extends API::Node {
        override string toString() { result = this.(API::Node).toString() }
      }

      /** A Django field subclass in the `django` package. */
      private class DjangoFieldSubclassesInDjango extends ModeledSubclass {
        DjangoFieldSubclassesInDjango() {
          exists(string moduleName, string className |
            // canonical definition
            this =
              API::moduleImport("django")
                  .getMember("forms")
                  .getMember(moduleName)
                  .getMember(className)
            or
            // aliases from `django.forms`
            this = API::moduleImport("django").getMember("forms").getMember(className)
          |
            moduleName = "fields" and
            className in [
                "Field",
                // Known subclasses
                "BooleanField", "IntegerField", "CharField", "SlugField", "DateTimeField",
                "EmailField", "DateField", "TimeField", "DurationField", "DecimalField",
                "FloatField", "GenericIPAddressField", "UUIDField", "JSONField", "FilePathField",
                "NullBooleanField", "URLField", "TypedChoiceField", "FileField", "ImageField",
                "RegexField", "ChoiceField", "MultipleChoiceField", "ComboField", "MultiValueField",
                "SplitDateTimeField", "TypedMultipleChoiceField", "BaseTemporalField"
              ]
            or
            // Known subclasses from `django.forms.models`
            moduleName = "models" and
            className in ["ModelChoiceField", "ModelMultipleChoiceField", "InlineForeignKeyField"]
          )
          or
          // other Field subclasses defined in Django
          this =
            API::moduleImport("django")
                .getMember("contrib")
                .getMember("auth")
                .getMember("forms")
                .getMember(["ReadOnlyPasswordHashField", "UsernameField"])
          or
          this =
            API::moduleImport("django")
                .getMember("contrib")
                .getMember("gis")
                .getMember("forms")
                .getMember("fields")
                .getMember([
                    "GeometryCollectionField", "GeometryField", "LineStringField",
                    "MultiLineStringField", "MultiPointField", "MultiPolygonField", "PointField",
                    "PolygonField"
                  ])
          or
          this =
            API::moduleImport("django")
                .getMember("contrib")
                .getMember("postgres")
                .getMember("forms")
                .getMember("array")
                .getMember(["SimpleArrayField", "SplitArrayField"])
          or
          this =
            API::moduleImport("django")
                .getMember("contrib")
                .getMember("postgres")
                .getMember("forms")
                .getMember("hstore")
                .getMember("HStoreField")
          or
          this =
            API::moduleImport("django")
                .getMember("contrib")
                .getMember("postgres")
                .getMember("forms")
                .getMember("ranges")
                .getMember([
                    "BaseRangeField", "DateRangeField", "DateTimeRangeField", "DecimalRangeField",
                    "IntegerRangeField"
                  ])
          or
          this =
            API::moduleImport("django")
                .getMember("forms")
                .getMember("models")
                .getMember(["InlineForeignKeyField", "ModelChoiceField", "ModelMultipleChoiceField"])
        }
      }

      private class MaDSubclass extends ModeledSubclass {
        MaDSubclass() { this = ModelOutput::getATypeNode("Django.Forms.Field~Subclass") }
      }

      /** Gets a reference to the `django.forms.fields.Field` class or any subclass. */
      API::Node subclassRef() { result = any(ModeledSubclass subclass).getASubclass*() }
    }
  }

  /**
   * Provides models for the `django.utils.datastructures.MultiValueDict` class
   *
   * See
   * - https://docs.djangoproject.com/en/3.0/ref/request-response/#django.http.QueryDict (subclass that has proper docs)
   * - https://www.kite.com/python/docs/django.utils.datastructures.MultiValueDict
   */
  module MultiValueDict {
    /** Gets a reference to the `django.utils.datastructures.MultiValueDict` class. */
    private API::Node classRef() {
      result =
        API::moduleImport("django")
            .getMember("utils")
            .getMember("datastructures")
            .getMember("MultiValueDict")
    }

    /**
     * A source of instances of `django.utils.datastructures.MultiValueDict`, extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use the predicate `MultiValueDict::instance()` to get references to instances of `django.utils.datastructures.MultiValueDict`.
     */
    abstract class InstanceSource extends DataFlow::LocalSourceNode { }

    /** A direct instantiation of `django.utils.datastructures.MultiValueDict`. */
    private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
      ClassInstantiation() { this = classRef().getACall() }
    }

    /** Gets a reference to an instance of `django.utils.datastructures.MultiValueDict`. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of `django.utils.datastructures.MultiValueDict`. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

    /**
     * Taint propagation for `django.utils.datastructures.MultiValueDict`.
     */
    private class InstanceTaintSteps extends InstanceTaintStepsHelper {
      InstanceTaintSteps() { this = "django.utils.datastructures.MultiValueDict" }

      override DataFlow::Node getInstance() { result = instance() }

      override string getAttributeName() { none() }

      override string getMethodName() {
        result in ["getlist", "lists", "popitem", "dict", "urlencode"]
      }

      override string getAsyncMethodName() { none() }
    }

    /**
     * Extra taint propagation for `django.utils.datastructures.MultiValueDict`, not covered by `InstanceTaintSteps`.
     */
    private class AdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
      override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
        // class instantiation
        exists(ClassInstantiation call |
          nodeFrom = call.getArg(0) and
          nodeTo = call
        )
      }
    }
  }

  /**
   * Provides models for the `django.contrib.auth.models.User` class
   *
   * See https://docs.djangoproject.com/en/3.2/ref/contrib/auth/#user-model.
   */
  module User {
    /**
     * A source of instances of `django.contrib.auth.models.User`, extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use the predicate `User::instance()` to get references to instances of `django.contrib.auth.models.User`.
     */
    abstract class InstanceSource extends DataFlow::LocalSourceNode { }

    /** Gets a reference to an instance of `django.contrib.auth.models.User`. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of `django.contrib.auth.models.User`. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

    /**
     * Taint propagation for `django.contrib.auth.models.User`.
     */
    private class InstanceTaintSteps extends InstanceTaintStepsHelper {
      InstanceTaintSteps() { this = "django.contrib.auth.models.User" }

      override DataFlow::Node getInstance() { result = instance() }

      override string getAttributeName() {
        result in ["username", "first_name", "last_name", "email"]
      }

      override string getMethodName() { none() }

      override string getAsyncMethodName() { none() }
    }
  }

  /**
   * Provides models for the `django.core.files.uploadedfile.UploadedFile` class
   *
   * See https://docs.djangoproject.com/en/3.0/ref/files/uploads/#django.core.files.uploadedfile.UploadedFile.
   */
  module UploadedFile {
    /**
     * A source of instances of `django.core.files.uploadedfile.UploadedFile`, extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use the predicate `UploadedFile::instance()` to get references to instances of `django.core.files.uploadedfile.UploadedFile`.
     */
    abstract class InstanceSource extends DataFlow::LocalSourceNode { }

    /** Gets a reference to an instance of `django.core.files.uploadedfile.UploadedFile`. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of `django.core.files.uploadedfile.UploadedFile`. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

    /**
     * Taint propagation for `django.core.files.uploadedfile.UploadedFile`.
     */
    private class InstanceTaintSteps extends InstanceTaintStepsHelper {
      InstanceTaintSteps() { this = "django.core.files.uploadedfile.UploadedFile" }

      override DataFlow::Node getInstance() { result = instance() }

      override string getAttributeName() {
        result in [
            "content_type", "content_type_extra", "content_type_extra", "charset", "name", "file"
          ]
      }

      override string getMethodName() { none() }

      override string getAsyncMethodName() { none() }
    }

    /** A file-like object instance that originates from a `UploadedFile`. */
    class UploadedFileFileLikeInstances extends Stdlib::FileLikeObject::InstanceSource {
      UploadedFileFileLikeInstances() {
        // in the bottom of
        // https://docs.djangoproject.com/en/4.0/ref/files/file/#django.core.files.File
        // it's mentioned that the File object itself has proxy methods for
        // `read`/`write`/... that forwards to the underlying file object.
        this = instance()
        or
        this.(DataFlow::AttrRead).accesses(instance(), "file")
      }
    }
  }

  /**
   * Provides models for the `django.urls.ResolverMatch` class
   *
   * See https://docs.djangoproject.com/en/3.0/ref/urlresolvers/#django.urls.ResolverMatch.
   */
  module ResolverMatch {
    /**
     * A source of instances of `django.urls.ResolverMatch`, extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use the predicate `ResolverMatch::instance()` to get references to instances of `django.urls.ResolverMatch`.
     */
    abstract class InstanceSource extends DataFlow::LocalSourceNode { }

    /** Gets a reference to an instance of `django.urls.ResolverMatch`. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of `django.urls.ResolverMatch`. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

    /**
     * Taint propagation for `django.urls.ResolverMatch`.
     */
    private class InstanceTaintSteps extends InstanceTaintStepsHelper {
      InstanceTaintSteps() { this = "django.urls.ResolverMatch" }

      override DataFlow::Node getInstance() { result = instance() }

      override string getAttributeName() { result in ["args", "kwargs"] }

      override string getMethodName() { none() }

      override string getAsyncMethodName() { none() }
    }
  }
}

/**
 * INTERNAL: Do not use.
 *
 * Provides models for the `django` PyPI package (that we are not quite ready to publicly expose yet).
 * See https://www.djangoproject.com/.
 */
module PrivateDjango {
  // ---------------------------------------------------------------------------
  // django
  // ---------------------------------------------------------------------------
  /** Gets a reference to the `django` module. */
  API::Node django() { result = API::moduleImport("django") }

  /** Provides models for the `django` module. */
  module DjangoImpl {
    // -------------------------------------------------------------------------
    // django.db
    // -------------------------------------------------------------------------
    /** Gets a reference to the `django.db` module. */
    API::Node db() { result = django().getMember("db") }

    /**
     * `django.db` implements PEP249, providing ways to execute SQL statements against a database.
     */
    private class DjangoDb extends PEP249::PEP249ModuleApiNode {
      DjangoDb() { this = API::moduleImport("django").getMember("db") }
    }

    /** Provides models for the `django.db` module. */
    module DB {
      /** Gets a reference to the `django.db.connection` object. */
      API::Node connection() { result = db().getMember("connection") }

      /** A `django.db.connection` is a PEP249 compliant DB connection. */
      class DjangoDbConnection extends PEP249::DatabaseConnection {
        DjangoDbConnection() { this = connection() }
      }

      // -------------------------------------------------------------------------
      // django.db.models
      // -------------------------------------------------------------------------
      /** Gets a reference to the `django.db.models` module. */
      API::Node models() { result = db().getMember("models") }

      /** Provides models for the `django.db.models` module. */
      module Models {
        /**
         * Provides models for the `django.db.models.Model` class and subclasses.
         *
         * See https://docs.djangoproject.com/en/3.1/topics/db/models/.
         */
        module Model {
          /** Gets a reference to the `django.db.models.Model` class or any subclass. */
          API::Node subclassRef() {
            result =
              API::moduleImport("django")
                  .getMember("db")
                  .getMember("models")
                  .getMember("Model")
                  .getASubclass*()
            or
            result =
              API::moduleImport("django")
                  .getMember("db")
                  .getMember("models")
                  .getMember("base")
                  .getMember("Model")
                  .getASubclass*()
            or
            result =
              API::moduleImport("polymorphic")
                  .getMember("models")
                  .getMember("PolymorphicModel")
                  .getASubclass*()
            or
            result = ModelOutput::getATypeNode("Django.db.models.Model~Subclass").getASubclass*()
          }

          /**
           * A source of instances of `django.db.models.Model` class or any subclass, extend this class to model new instances.
           *
           * This can include instantiations of the class, return values from function
           * calls, or a special parameter that will be set when functions are called by an external
           * library.
           *
           * Use the predicate `Model::instance()` to get references to instances of `django.db.models.Model` class or any subclass.
           */
          abstract class InstanceSource extends DataFlow::LocalSourceNode {
            /** Gets the model class that this is an instance source of. */
            abstract API::Node getModelClass();

            /** Holds if this instance-source is fetching data from the DB. */
            abstract predicate isDbFetch();
          }

          /** A direct instantiation of `django.db.models.Model` class or any subclass. */
          private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
            API::Node modelClass;

            ClassInstantiation() {
              modelClass = subclassRef() and
              this = modelClass.getACall()
            }

            override API::Node getModelClass() { result = modelClass }

            override predicate isDbFetch() { none() }
          }

          /** A method call on a query-set or manager that returns an instance of a django model. */
          private class QuerySetMethod extends InstanceSource, DataFlow::CallCfgNode {
            API::Node modelClass;
            string methodName;

            QuerySetMethod() {
              modelClass = subclassRef() and
              methodName in ["get", "create", "earliest", "latest", "first", "last"] and
              this = [manager(modelClass), querySet(modelClass)].getMember(methodName).getACall()
            }

            override API::Node getModelClass() { result = modelClass }

            override predicate isDbFetch() { not methodName = "create" }
          }

          /**
           * A method call on a query-set or manager that returns a collection
           * containing instances of a django model.
           */
          class QuerySetMethodInstanceCollection extends DataFlow::CallCfgNode {
            API::Node modelClass;
            string methodName;

            QuerySetMethodInstanceCollection() {
              modelClass = subclassRef() and
              this = querySetReturningMethod(modelClass, methodName).getACall() and
              not methodName in ["none", "datetimes", "dates", "values", "values_list"]
              or
              // TODO: When we have flow-summaries, we should be able to model `values` and `values_list`
              // Potentially by doing `synthetic ===store of list element==> <Model>.objects`, and then
              // `.all()` just keeps that content, and `.first()` will do a read step (of the list element).
              //
              // So for `Model.objects.filter().exclude().first()` we would have
              // 1: <Synthetic node for Model> ===store of list element==> Model.objects
              // 2: Model.objects ==> Model.objects.filter()
              // 3: Model.objects.filter() ==> Model.objects.filter().exclude()
              // 4: Model.objects.filter().exclude() ===read of list element==> Model.objects.filter().exclude().first()
              //
              // This also means that `.none()` could clear contents. Right now we
              // think that the result of `Model.objects.none().all()` can contain
              // Model objects, but it will be empty due to the `.none()` part. Not
              // that this is important, since no-one would need to write
              // `.none().all()` code anyway, but it would be cool to be able to model it properly :D
              //
              //
              // The big benefit is for how we could then model `values`/`values_list`. For example,
              // `Model.objects.value_list(name, description)` would result in (for the attribute description)
              // 0: <Synthetic node for Model> -- [attr description]
              // 1: ==> Model.objects [ListElement, attr description]
              // 2: ==> .value_list(...) [ListElement, TupleIndex 1]
              //
              // but for now, we just model a store step directly from the synthetic
              // node to the method call.
              //
              // extra method on query-set/manager that does _not_ return a query-set,
              // but a collection of instances.
              modelClass = subclassRef() and
              methodName in ["iterator", "bulk_create"] and
              this = [manager(modelClass), querySet(modelClass)].getMember(methodName).getACall()
            }

            /** Gets the model class that this is an instance source of. */
            API::Node getModelClass() { result = modelClass }

            /** Holds if this instance-source is fetching data from the DB. */
            predicate isDbFetch() { not methodName = "bulk_create" }
          }

          /**
           * A method call on a query-set or manager that returns a dictionary
           * containing instances of a django models as the values.
           */
          class QuerySetMethodInstanceDictValue extends DataFlow::CallCfgNode {
            API::Node modelClass;

            QuerySetMethodInstanceDictValue() {
              modelClass = subclassRef() and
              this = [manager(modelClass), querySet(modelClass)].getMember("in_bulk").getACall()
            }

            /** Gets the model class that this is an instance source of. */
            API::Node getModelClass() { result = modelClass }

            /** Holds if this instance-source is fetching data from the DB. */
            predicate isDbFetch() { any() }
          }

          /**
           * Gets a reference to an instance of `django.db.models.Model` class or any subclass,
           * where `modelClass` specifies the class.
           */
          private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t, API::Node modelClass) {
            t.start() and
            modelClass = result.(InstanceSource).getModelClass()
            or
            exists(DataFlow::TypeTracker t2 | result = instance(t2, modelClass).track(t2, t))
          }

          /**
           * Gets a reference to an instance of `django.db.models.Model` class or any subclass,
           * where `modelClass` specifies the class.
           */
          DataFlow::Node instance(API::Node modelClass) {
            instance(DataFlow::TypeTracker::end(), modelClass).flowsTo(result)
          }
        }

        /**
         * Provides models for the `django.db.models.FileField` class and `ImageField` subclasses.
         *
         * See
         * - https://docs.djangoproject.com/en/3.1/ref/models/fields/#django.db.models.FileField
         * - https://docs.djangoproject.com/en/3.1/ref/models/fields/#django.db.models.ImageField
         */
        module FileField {
          /** Gets a reference to the `django.db.models.FileField` or  the `django.db.models.ImageField` class or any subclass. */
          API::Node subclassRef() {
            exists(string className | className in ["FileField", "ImageField"] |
              // commonly used alias
              result =
                API::moduleImport("django")
                    .getMember("db")
                    .getMember("models")
                    .getMember(className)
                    .getASubclass*()
              or
              // actual class definition
              result =
                API::moduleImport("django")
                    .getMember("db")
                    .getMember("models")
                    .getMember("fields")
                    .getMember("files")
                    .getMember(className)
                    .getASubclass*()
            )
            or
            result =
              ModelOutput::getATypeNode("django.db.models.FileField~Subclass").getASubclass*()
          }
        }

        /**
         * Gets a reference to the Manager (django.db.models.Manager) for the django Model `modelClass`,
         * accessed by `<modelClass>.objects`.
         */
        API::Node manager(API::Node modelClass) {
          modelClass = Model::subclassRef() and
          result = modelClass.getMember("objects")
        }

        /**
         * Gets a method with `name` that returns a QuerySet.
         * This method can originate on a QuerySet or a Manager.
         * `modelClass` specifies the django Model that this query-set originates from.
         *
         * See https://docs.djangoproject.com/en/3.1/ref/models/querysets/
         */
        API::Node querySetReturningMethod(API::Node modelClass, string name) {
          name in [
              "none", "all", "filter", "exclude", "complex_filter", "union", "intersection",
              "difference", "select_for_update", "select_related", "prefetch_related", "order_by",
              "distinct", "reverse", "defer", "only", "using", "annotate", "extra", "raw",
              "datetimes", "dates", "values", "values_list", "alias"
            ] and
          result = [manager(modelClass), querySet(modelClass)].getMember(name)
          or
          name = "get_queryset" and
          result = manager(modelClass).getMember(name)
        }

        /**
         * Gets a reference to a QuerySet (django.db.models.query.QuerySet).
         * `modelClass` specifies the django Model that this query-set originates from.
         *
         * See https://docs.djangoproject.com/en/3.1/ref/models/querysets/
         */
        API::Node querySet(API::Node modelClass) {
          result = querySetReturningMethod(modelClass, _).getReturn()
        }

        /** Gets a reference to the `django.db.models.expressions` module. */
        API::Node expressions() { result = models().getMember("expressions") }

        /** Provides models for the `django.db.models.expressions` module. */
        module Expressions {
          /** Provides models for the `django.db.models.expressions.RawSql` class. */
          module RawSql {
            /**
             * Gets an reference to the `django.db.models.expressions.RawSQL` class.
             */
            API::Node classRef() {
              result = expressions().getMember("RawSQL")
              or
              // Commonly used alias
              result = models().getMember("RawSQL")
              or
              result =
                ModelOutput::getATypeNode("django.db.models.expressions.RawSQL~Subclass")
                    .getASubclass*()
            }

            /**
             * Gets an instance of the `django.db.models.expressions.RawSQL` class,
             * that was initiated with the SQL represented by `sql`.
             */
            private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t, DataFlow::Node sql) {
              t.start() and
              exists(DataFlow::CallCfgNode c | result = c |
                c = classRef().getACall() and
                c.getArg(0) = sql
              )
              or
              exists(DataFlow::TypeTracker t2 | result = instance(t2, sql).track(t2, t))
            }

            /**
             * Gets an instance of the `django.db.models.expressions.RawSQL` class,
             * that was initiated with the SQL represented by `sql`.
             */
            DataFlow::Node instance(DataFlow::Node sql) {
              instance(DataFlow::TypeTracker::end(), sql).flowsTo(result)
            }
          }
        }

        /** This internal module provides data-flow modeling of Django ORM. */
        private module OrmDataflow {
          private import semmle.python.dataflow.new.internal.DataFlowPrivate::Orm

          /** Gets the (AST) class of the Django model class `modelClass`. */
          Class getModelClassClass(API::Node modelClass) {
            result.getParent() = modelClass.asSource().asExpr() and
            modelClass = Model::subclassRef()
          }

          /** A synthetic node representing the data for an Django ORM model saved in a DB. */
          class SyntheticDjangoOrmModelNode extends SyntheticOrmModelNode {
            API::Node modelClass;

            SyntheticDjangoOrmModelNode() { this.getClass() = getModelClassClass(modelClass) }

            /** Gets the API node for this Django model class. */
            API::Node getModelClass() { result = modelClass }
          }

          /**
           * Gets a synthetic node where the data in the attribute `fieldName` can flow
           * to, when a DB store is made on `subModel`, taking ORM inheritance into
           * account.
           *
           * If `fieldName` is defined in class `base`, the results will include the
           * synthetic node for `base` itself, the synthetic node for `subModel`, as
           * well as all the classes in-between (in the class hierarchy).
           */
          SyntheticDjangoOrmModelNode nodeToStoreIn(API::Node subModel, string fieldName) {
            exists(Class base, API::Node baseModel, API::Node resultModel |
              baseModel = Model::subclassRef() and
              resultModel = Model::subclassRef() and
              baseModel.getASubclass*() = subModel and
              base = getModelClassClass(baseModel) and
              exists(Variable v |
                base.getBody().getAnItem().(AssignStmt).defines(v) and
                v.getId() = fieldName
              )
            |
              baseModel.getASubclass*() = resultModel and
              resultModel.getASubclass*() = subModel and
              result.getModelClass() = resultModel
            )
          }

          /**
           * Gets the synthetic node where data could be loaded from, when a fetch is
           * made on `modelClass`.
           *
           * In vanilla Django inheritance, this is simply the model itself, but if a
           * model is based on `polymorphic.models.PolymorphicModel`, a fetch of the
           * base-class can also yield instances of its subclasses.
           */
          SyntheticDjangoOrmModelNode nodeToLoadFrom(API::Node modelClass) {
            result.getModelClass() = modelClass
            or
            exists(API::Node polymorphicModel |
              polymorphicModel =
                API::moduleImport("polymorphic").getMember("models").getMember("PolymorphicModel")
            |
              polymorphicModel.getASubclass+() = modelClass and
              modelClass.getASubclass+() = result.getModelClass()
            )
          }

          /** Additional data-flow steps for Django ORM models. */
          class DjangOrmSteps extends AdditionalOrmSteps {
            override predicate storeStep(
              DataFlow::Node nodeFrom, DataFlow::Content c, DataFlow::Node nodeTo
            ) {
              // attribute value from constructor call -> object created
              exists(DataFlow::CallCfgNode call, string fieldName |
                // Note: Currently only supports kwargs, which should by far be the most
                // common way to do things. We _should_ investigate how often
                // positional-args are used.
                call = Model::subclassRef().getACall() and
                nodeFrom = call.getArgByName(fieldName) and
                c.(DataFlow::AttributeContent).getAttribute() = fieldName and
                nodeTo = call
              )
              or
              // attribute store in `<Model>.objects.create`, `get_or_create`, and `update_or_create`
              // see https://docs.djangoproject.com/en/4.0/ref/models/querysets/#create
              // see https://docs.djangoproject.com/en/4.0/ref/models/querysets/#get-or-create
              // see https://docs.djangoproject.com/en/4.0/ref/models/querysets/#update-or-create
              // TODO: This does currently not handle values passed in the `defaults` dictionary
              exists(
                DataFlow::CallCfgNode call, API::Node modelClass, string fieldName,
                string methodName
              |
                modelClass = Model::subclassRef() and
                methodName in ["create", "get_or_create", "update_or_create"] and
                call = modelClass.getMember("objects").getMember(methodName).getACall() and
                nodeFrom = call.getArgByName(fieldName) and
                c.(DataFlow::AttributeContent).getAttribute() = fieldName and
                (
                  // -> object created
                  (
                    methodName = "create" and nodeTo = call
                    or
                    // TODO: for these two methods, the result is a tuple `(<Model>, bool)`,
                    // which we need flow-summaries to model properly
                    methodName in ["get_or_create", "update_or_create"] and none()
                  )
                  or
                  // -> DB store on synthetic node
                  nodeTo = nodeToStoreIn(modelClass, fieldName)
                )
              )
              or
              // attribute store in `<Model>.objects.[<QuerySet>].update()` -> synthetic
              // see https://docs.djangoproject.com/en/4.0/ref/models/querysets/#update
              exists(DataFlow::CallCfgNode call, API::Node modelClass, string fieldName |
                call = [manager(modelClass), querySet(modelClass)].getMember("update").getACall() and
                nodeFrom = call.getArgByName(fieldName) and
                c.(DataFlow::AttributeContent).getAttribute() = fieldName and
                nodeTo = nodeToStoreIn(modelClass, fieldName)
              )
              or
              // synthetic -> method-call that returns collection of ORM models (all/filter/...)
              exists(API::Node modelClass |
                nodeFrom = nodeToLoadFrom(modelClass) and
                nodeTo.(Model::QuerySetMethodInstanceCollection).getModelClass() = modelClass and
                nodeTo.(Model::QuerySetMethodInstanceCollection).isDbFetch() and
                c instanceof DataFlow::ListElementContent
              )
              or
              // synthetic -> method-call that returns dictionary with ORM models as values
              exists(API::Node modelClass |
                nodeFrom = nodeToLoadFrom(modelClass) and
                nodeTo.(Model::QuerySetMethodInstanceDictValue).getModelClass() = modelClass and
                nodeTo.(Model::QuerySetMethodInstanceDictValue).isDbFetch() and
                c instanceof DataFlow::DictionaryElementAnyContent
              )
            }

            override predicate jumpStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
              // save -> synthetic
              exists(API::Node modelClass, DataFlow::MethodCallNode saveCall |
                // TODO: The `nodeTo` should be restricted more, such that flow to
                // base-classes are only for the fields that are defined in the
                // base-class... but only passing on flow for a specific attribute requires flow-summaries,
                // so we can do
                // `obj (in obj.save call) ==read of attr==> synthetic attr on base-class ==store of attr==> synthetic for base-class`
                nodeTo = nodeToStoreIn(modelClass, _) and
                saveCall.calls(Model::instance(modelClass), "save") and
                nodeFrom = saveCall.getObject()
              )
              or
              // synthetic -> method-call that returns single ORM model (get/first/...)
              exists(API::Node modelClass |
                nodeFrom = nodeToLoadFrom(modelClass) and
                nodeTo.(Model::InstanceSource).getModelClass() = modelClass and
                nodeTo.(Model::InstanceSource).isDbFetch()
              )
            }
          }
        }
      }
    }

    /**
     * A call to the `annotate` function on a model using a `RawSQL` argument.
     *
     * TODO: Consider reworking this to use taint tracking.
     *
     * See https://docs.djangoproject.com/en/3.1/ref/models/querysets/#annotate
     */
    private class ObjectsAnnotate extends SqlExecution::Range, DataFlow::CallCfgNode {
      DataFlow::Node sql;

      ObjectsAnnotate() {
        this = DjangoImpl::DB::Models::querySetReturningMethod(_, "annotate").getACall() and
        DjangoImpl::DB::Models::Expressions::RawSql::instance(sql) in [
            this.getArg(_), this.getArgByName(_)
          ]
      }

      override DataFlow::Node getSql() { result = sql }
    }

    /**
     * A call to the `alias` function on a model using a `RawSQL` argument.
     *
     * See https://docs.djangoproject.com/en/3.2/ref/models/querysets/#alias
     */
    private class ObjectsAlias extends SqlExecution::Range, DataFlow::CallCfgNode {
      DataFlow::Node sql;

      ObjectsAlias() {
        this = DjangoImpl::DB::Models::querySetReturningMethod(_, "alias").getACall() and
        DjangoImpl::DB::Models::Expressions::RawSql::instance(sql) in [
            this.getArg(_), this.getArgByName(_)
          ]
      }

      override DataFlow::Node getSql() { result = sql }
    }

    /**
     * A call to the `raw` function on a model.
     *
     * See
     * - https://docs.djangoproject.com/en/3.1/topics/db/sql/#django.db.models.Manager.raw
     * - https://docs.djangoproject.com/en/3.1/ref/models/querysets/#raw
     */
    private class ObjectsRaw extends SqlExecution::Range, DataFlow::CallCfgNode {
      ObjectsRaw() { this = DjangoImpl::DB::Models::querySetReturningMethod(_, "raw").getACall() }

      override DataFlow::Node getSql() { result = this.getArg(0) }
    }

    /**
     * A call to the `extra` function on a model.
     *
     * See https://docs.djangoproject.com/en/3.1/ref/models/querysets/#extra
     */
    private class ObjectsExtra extends SqlExecution::Range, DataFlow::CallCfgNode {
      ObjectsExtra() {
        this = DjangoImpl::DB::Models::querySetReturningMethod(_, "extra").getACall()
      }

      override DataFlow::Node getSql() {
        result in [
            this.getArg([0, 1, 3, 4]), this.getArgByName(["select", "where", "tables", "order_by"])
          ]
      }
    }

    // -------------------------------------------------------------------------
    // django.urls
    // -------------------------------------------------------------------------
    /** Gets a reference to the `django.urls` module. */
    API::Node urls() { result = django().getMember("urls") }

    /** Provides models for the `django.urls` module */
    module Urls {
      /**
       * Gets a reference to the `django.urls.path` function.
       * See https://docs.djangoproject.com/en/3.0/ref/urls/#path
       */
      API::Node path() { result = urls().getMember("path") }

      /**
       * Gets a reference to the `django.urls.re_path` function.
       * See https://docs.djangoproject.com/en/3.0/ref/urls/#re_path
       */
      API::Node re_path() { result = urls().getMember("re_path") }
    }

    // -------------------------------------------------------------------------
    // django.conf
    // -------------------------------------------------------------------------
    /** Gets a reference to the `django.conf` module. */
    API::Node conf() { result = django().getMember("conf") }

    /** Provides models for the `django.conf` module */
    module Conf {
      /** Provides models for the `django.conf.urls` module */
      module ConfUrls {
        // -------------------------------------------------------------------------
        // django.conf.urls
        // -------------------------------------------------------------------------
        // NOTE: had to rename due to shadowing rules in QL
        /** Gets a reference to the `django.conf.urls` module. */
        API::Node conf_urls() { result = conf().getMember("urls") }

        /**
         * Gets a reference to the `django.conf.urls.url` function.
         *
         * See https://docs.djangoproject.com/en/1.11/ref/urls/#django.conf.urls.url
         */
        API::Node url() { result = conf_urls().getMember("url") }
      }
    }

    // -------------------------------------------------------------------------
    // django.http
    // -------------------------------------------------------------------------
    /** Gets a reference to the `django.http` module. */
    API::Node http() { result = django().getMember("http") }

    /** Provides models for the `django.http` module */
    module DjangoHttp {
      // ---------------------------------------------------------------------------
      // django.http.request
      // ---------------------------------------------------------------------------
      /** Gets a reference to the `django.http.request` module. */
      API::Node request() { result = http().getMember("request") }

      /** Provides models for the `django.http.request` module. */
      module Request {
        /**
         * Provides models for the `django.http.request.HttpRequest` class
         *
         * See https://docs.djangoproject.com/en/3.0/ref/request-response/#httprequest-objects
         */
        module HttpRequest {
          /** Gets a reference to the `django.http.request.HttpRequest` class. */
          API::Node classRef() {
            result = request().getMember("HttpRequest")
            or
            // handle django.http.HttpRequest alias
            result = http().getMember("HttpRequest")
            or
            result =
              ModelOutput::getATypeNode("django.http.request.HttpRequest~Subclass").getASubclass*()
          }

          /**
           * A source of instances of `django.http.request.HttpRequest`, extend this class to model new instances.
           *
           * This can include instantiations of the class, return values from function
           * calls, or a special parameter that will be set when functions are called by an external
           * library.
           *
           * Use `django::http::request::HttpRequest::instance()` predicate to get
           * references to instances of `django.http.request.HttpRequest`.
           */
          abstract class InstanceSource extends DataFlow::Node { }

          /** Gets a reference to an instance of `django.http.request.HttpRequest`. */
          private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
            t.start() and
            result instanceof InstanceSource
            or
            exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
          }

          /** Gets a reference to an instance of `django.http.request.HttpRequest`. */
          DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

          /**
           * Taint propagation for `django.http.request.HttpRequest`.
           */
          private class InstanceTaintSteps extends InstanceTaintStepsHelper {
            InstanceTaintSteps() { this = "django.http.request.HttpRequest" }

            override DataFlow::Node getInstance() { result = instance() }

            override string getAttributeName() {
              result in [
                  // str / bytes
                  "body", "path", "path_info", "method", "encoding", "content_type",
                  // django.http.QueryDict
                  "GET", "POST",
                  // dict[str, str]
                  "content_params", "COOKIES",
                  // dict[str, Any]
                  "META",
                  // HttpHeaders (case insensitive dict-like)
                  "headers",
                  // MultiValueDict[str, UploadedFile]
                  "FILES",
                  // django.urls.ResolverMatch
                  "resolver_match"
                ]
              // TODO: Handle that a HttpRequest is iterable
            }

            override string getMethodName() {
              result in ["get_full_path", "get_full_path_info", "read", "readline", "readlines"]
            }

            override string getAsyncMethodName() { none() }
          }

          /**
           * Extra taint propagation for `django.http.request.HttpRequest`, not covered by `InstanceTaintSteps`.
           */
          private class AdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
            override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
              // special handling of the `build_absolute_uri` method, see
              // https://docs.djangoproject.com/en/3.0/ref/request-response/#django.http.HttpRequest.build_absolute_uri
              exists(DataFlow::AttrRead attr, DataFlow::CallCfgNode call, DataFlow::Node instance |
                instance = DjangoImpl::DjangoHttp::Request::HttpRequest::instance() and
                attr.getObject() = instance
              |
                attr.getAttributeName() = "build_absolute_uri" and
                nodeTo.(DataFlow::CallCfgNode).getFunction() = attr and
                call = nodeTo and
                (
                  not exists(call.getArg(_)) and
                  not exists(call.getArgByName(_)) and
                  nodeFrom = instance
                  or
                  nodeFrom = call.getArg(0)
                  or
                  nodeFrom = call.getArgByName("location")
                )
              )
            }
          }

          /** An attribute read on an django request that is a `MultiValueDict` instance. */
          private class DjangoHttpRequestMultiValueDictInstances extends Django::MultiValueDict::InstanceSource
          {
            DjangoHttpRequestMultiValueDictInstances() {
              this.(DataFlow::AttrRead).getObject() = instance() and
              this.(DataFlow::AttrRead).getAttributeName() in ["GET", "POST", "FILES"]
            }
          }

          /** An attribute read on an django request that is a `ResolverMatch` instance. */
          private class DjangoHttpRequestResolverMatchInstances extends Django::ResolverMatch::InstanceSource
          {
            DjangoHttpRequestResolverMatchInstances() {
              this.(DataFlow::AttrRead).getObject() = instance() and
              this.(DataFlow::AttrRead).getAttributeName() = "resolver_match"
            }
          }

          /** An `UploadedFile` instance that originates from a django request. */
          private class DjangoHttpRequestUploadedFileInstances extends Django::UploadedFile::InstanceSource
          {
            DjangoHttpRequestUploadedFileInstances() {
              // TODO: this currently only works in local-scope, since writing type-trackers for
              // this is a little too much effort. Once API-graphs are available for more
              // things, we can rewrite this.
              //
              // TODO: This approach for identifying member-access is very adhoc, and we should
              // be able to do something more structured for providing modeling of the members
              // of a container-object.
              //
              // dicts
              exists(DataFlow::AttrRead files, DataFlow::Node dict |
                files.accesses(instance(), "FILES") and
                (
                  dict = files
                  or
                  dict.(DataFlow::MethodCallNode).calls(files, "dict")
                )
              |
                this.asCfgNode().(SubscriptNode).getObject() = dict.asCfgNode()
                or
                this.(DataFlow::MethodCallNode).calls(dict, "get")
              )
              or
              // getlist
              exists(DataFlow::AttrRead files, DataFlow::MethodCallNode getlistCall |
                files.accesses(instance(), "FILES") and
                getlistCall.calls(files, "getlist") and
                this.asCfgNode().(SubscriptNode).getObject() = getlistCall.asCfgNode()
              )
            }
          }
        }
      }

      // -------------------------------------------------------------------------
      // django.http.response
      // -------------------------------------------------------------------------
      /** Gets a reference to the `django.http.response` module. */
      API::Node response() { result = http().getMember("response") }

      /** Provides models for the `django.http.response` module */
      module Response {
        /**
         * Provides models for the `django.http.response.HttpResponse` class
         *
         * See https://docs.djangoproject.com/en/3.1/ref/request-response/#django.http.HttpResponse.
         */
        module HttpResponse {
          /** Gets a reference to the `django.http.response.HttpResponse` class. */
          API::Node baseClassRef() {
            result = response().getMember("HttpResponse")
            or
            // Handle `django.http.HttpResponse` alias
            result = http().getMember("HttpResponse")
          }

          /** Gets a reference to the `django.http.response.HttpResponse` class or any subclass. */
          API::Node classRef() {
            result = baseClassRef().getASubclass*()
            or
            result =
              ModelOutput::getATypeNode("django.http.response.HttpResponse~Subclass")
                  .getASubclass*()
          }

          /**
           * A source of instances of `django.http.response.HttpResponse`, extend this class to model new instances.
           *
           * This can include instantiations of the class, return values from function
           * calls, or a special parameter that will be set when functions are called by an external
           * library.
           *
           * Use the predicate `HttpResponse::instance()` to get references to instances of `django.http.response.HttpResponse`.
           */
          abstract class InstanceSource extends Http::Server::HttpResponse::Range, DataFlow::Node {
          }

          /** A direct instantiation of `django.http.response.HttpResponse`. */
          private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
            ClassInstantiation() { this = classRef().getACall() }

            override DataFlow::Node getBody() {
              result in [this.getArg(0), this.getArgByName("content")]
            }

            // How to support the `headers` argument here?
            override DataFlow::Node getMimetypeOrContentTypeArg() {
              result in [this.getArg(1), this.getArgByName("content_type")]
            }

            override string getMimetypeDefault() { result = "text/html" }
          }

          /** Gets a reference to an instance of `django.http.response.HttpResponse`. */
          private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
            t.start() and
            result instanceof InstanceSource
            or
            exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
          }

          /** Gets a reference to an instance of `django.http.response.HttpResponse`. */
          DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }
        }

        // ---------------------------------------------------------------------------
        // HttpResponse subclasses
        // see https://docs.djangoproject.com/en/3.1/ref/request-response/#httpresponse-subclasses
        // ---------------------------------------------------------------------------
        /**
         * Provides models for the `django.http.response.HttpResponseRedirect` class
         *
         * See https://docs.djangoproject.com/en/3.1/ref/request-response/#django.http.HttpResponseRedirect.
         */
        module HttpResponseRedirect {
          /** Gets a reference to the `django.http.response.HttpResponseRedirect` class. */
          API::Node baseClassRef() {
            result = response().getMember("HttpResponseRedirect")
            or
            // Handle `django.http.HttpResponseRedirect` alias
            result = http().getMember("HttpResponseRedirect")
          }

          /** Gets a reference to a subclass of the `django.http.response.HttpResponseRedirect` class. */
          API::Node classRef() {
            result = baseClassRef().getASubclass*() or
            result =
              ModelOutput::getATypeNode("django.http.response.HttpResponseRedirect~Subclass")
                  .getASubclass*()
          }

          /**
           * A source of instances of `django.http.response.HttpResponseRedirect`, extend this class to model new instances.
           *
           * This can include instantiations of the class, return values from function
           * calls, or a special parameter that will be set when functions are called by an external
           * library.
           *
           * Use the predicate `HttpResponseRedirect::instance()` to get references to instances of `django.http.response.HttpResponseRedirect`.
           */
          abstract class InstanceSource extends HttpResponse::InstanceSource,
            Http::Server::HttpRedirectResponse::Range, DataFlow::Node
          { }

          /** A direct instantiation of `django.http.response.HttpResponseRedirect`. */
          private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
            ClassInstantiation() { this = classRef().getACall() }

            override DataFlow::Node getBody() {
              // note that even though browsers like Chrome usually doesn't fetch the
              // content of a redirect, it is possible to observe the body (for example,
              // with cURL).
              result in [this.getArg(1), this.getArgByName("content")]
            }

            override DataFlow::Node getRedirectLocation() {
              result in [this.getArg(0), this.getArgByName("redirect_to")]
            }

            // How to support the `headers` argument here?
            override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

            override string getMimetypeDefault() { result = "text/html" }
          }

          /** Gets a reference to an instance of `django.http.response.HttpResponseRedirect`. */
          private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
            t.start() and
            result instanceof InstanceSource
            or
            exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
          }

          /** Gets a reference to an instance of `django.http.response.HttpResponseRedirect`. */
          DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }
        }

        /**
         * Provides models for the `django.http.response.HttpResponsePermanentRedirect` class
         *
         * See https://docs.djangoproject.com/en/3.1/ref/request-response/#django.http.HttpResponsePermanentRedirect.
         */
        module HttpResponsePermanentRedirect {
          /** Gets a reference to the `django.http.response.HttpResponsePermanentRedirect` class. */
          API::Node baseClassRef() {
            result = response().getMember("HttpResponsePermanentRedirect")
            or
            // Handle `django.http.HttpResponsePermanentRedirect` alias
            result = http().getMember("HttpResponsePermanentRedirect")
          }

          /** Gets a reference to the `django.http.response.HttpResponsePermanentRedirect` class. */
          API::Node classRef() {
            result = baseClassRef().getASubclass*() or
            result =
              ModelOutput::getATypeNode("django.http.response.HttpResponsePermanentRedirect~Subclass")
                  .getASubclass*()
          }

          /**
           * A source of instances of `django.http.response.HttpResponsePermanentRedirect`, extend this class to model new instances.
           *
           * This can include instantiations of the class, return values from function
           * calls, or a special parameter that will be set when functions are called by an external
           * library.
           *
           * Use the predicate `HttpResponsePermanentRedirect::instance()` to get references to instances of `django.http.response.HttpResponsePermanentRedirect`.
           */
          abstract class InstanceSource extends HttpResponse::InstanceSource,
            Http::Server::HttpRedirectResponse::Range, DataFlow::Node
          { }

          /** A direct instantiation of `django.http.response.HttpResponsePermanentRedirect`. */
          private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
            ClassInstantiation() { this = classRef().getACall() }

            override DataFlow::Node getBody() {
              // note that even though browsers like Chrome usually doesn't fetch the
              // content of a redirect, it is possible to observe the body (for example,
              // with cURL).
              result in [this.getArg(1), this.getArgByName("content")]
            }

            override DataFlow::Node getRedirectLocation() {
              result in [this.getArg(0), this.getArgByName("redirect_to")]
            }

            // How to support the `headers` argument here?
            override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

            override string getMimetypeDefault() { result = "text/html" }
          }

          /** Gets a reference to an instance of `django.http.response.HttpResponsePermanentRedirect`. */
          private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
            t.start() and
            result instanceof InstanceSource
            or
            exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
          }

          /** Gets a reference to an instance of `django.http.response.HttpResponsePermanentRedirect`. */
          DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }
        }

        /**
         * Provides models for the `django.http.response.HttpResponseNotModified` class
         *
         * See https://docs.djangoproject.com/en/3.1/ref/request-response/#django.http.HttpResponseNotModified.
         */
        module HttpResponseNotModified {
          /** Gets a reference to the `django.http.response.HttpResponseNotModified` class. */
          API::Node baseClassRef() {
            result = response().getMember("HttpResponseNotModified")
            or
            // TODO: remove/expand this part of the template as needed
            // Handle `django.http.HttpResponseNotModified` alias
            result = http().getMember("HttpResponseNotModified")
          }

          /** Gets a reference to the `django.http.response.HttpResponseNotModified` class. */
          API::Node classRef() {
            result = baseClassRef().getASubclass*() or
            result =
              ModelOutput::getATypeNode("django.http.response.HttpResponseNotModified~Subclass")
                  .getASubclass*()
          }

          /**
           * A source of instances of `django.http.response.HttpResponseNotModified`, extend this class to model new instances.
           *
           * This can include instantiations of the class, return values from function
           * calls, or a special parameter that will be set when functions are called by an external
           * library.
           *
           * Use the predicate `HttpResponseNotModified::instance()` to get references to instances of `django.http.response.HttpResponseNotModified`.
           */
          abstract class InstanceSource extends HttpResponse::InstanceSource, DataFlow::Node { }

          /** A direct instantiation of `django.http.response.HttpResponseNotModified`. */
          private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
            ClassInstantiation() { this = classRef().getACall() }

            override DataFlow::Node getBody() { none() }

            // How to support the `headers` argument here?
            override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

            override string getMimetypeDefault() { none() }
          }

          /** Gets a reference to an instance of `django.http.response.HttpResponseNotModified`. */
          private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
            t.start() and
            result instanceof InstanceSource
            or
            exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
          }

          /** Gets a reference to an instance of `django.http.response.HttpResponseNotModified`. */
          DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }
        }

        /**
         * Provides models for the `django.http.response.HttpResponseBadRequest` class
         *
         * See https://docs.djangoproject.com/en/3.1/ref/request-response/#django.http.HttpResponseBadRequest.
         */
        module HttpResponseBadRequest {
          /** Gets a reference to the `django.http.response.HttpResponseBadRequest` class. */
          API::Node baseClassRef() {
            result = response().getMember("HttpResponseBadRequest")
            or
            // Handle `django.http.HttpResponseBadRequest` alias
            result = http().getMember("HttpResponseBadRequest")
          }

          /** Gets a reference to the `django.http.response.HttpResponseBadRequest` class. */
          API::Node classRef() {
            result = baseClassRef().getASubclass*() or
            result =
              ModelOutput::getATypeNode("django.http.response.HttpResponseBadRequest~Subclass")
                  .getASubclass*()
          }

          /**
           * A source of instances of `django.http.response.HttpResponseBadRequest`, extend this class to model new instances.
           *
           * This can include instantiations of the class, return values from function
           * calls, or a special parameter that will be set when functions are called by an external
           * library.
           *
           * Use the predicate `HttpResponseBadRequest::instance()` to get references to instances of `django.http.response.HttpResponseBadRequest`.
           */
          abstract class InstanceSource extends HttpResponse::InstanceSource, DataFlow::Node { }

          /** A direct instantiation of `django.http.response.HttpResponseBadRequest`. */
          private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
            ClassInstantiation() { this = classRef().getACall() }

            override DataFlow::Node getBody() {
              result in [this.getArg(0), this.getArgByName("content")]
            }

            // How to support the `headers` argument here?
            override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

            override string getMimetypeDefault() { result = "text/html" }
          }

          /** Gets a reference to an instance of `django.http.response.HttpResponseBadRequest`. */
          private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
            t.start() and
            result instanceof InstanceSource
            or
            exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
          }

          /** Gets a reference to an instance of `django.http.response.HttpResponseBadRequest`. */
          DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }
        }

        /**
         * Provides models for the `django.http.response.HttpResponseNotFound` class
         *
         * See https://docs.djangoproject.com/en/3.1/ref/request-response/#django.http.HttpResponseNotFound.
         */
        module HttpResponseNotFound {
          /** Gets a reference to the `django.http.response.HttpResponseNotFound` class. */
          API::Node baseClassRef() {
            result = response().getMember("HttpResponseNotFound")
            or
            // Handle `django.http.HttpResponseNotFound` alias
            result = http().getMember("HttpResponseNotFound")
          }

          /** Gets a reference to the `django.http.response.HttpResponseNotFound` class. */
          API::Node classRef() {
            result = baseClassRef().getASubclass*() or
            result =
              ModelOutput::getATypeNode("django.http.response.HttpResponseNotFound~Subclass")
                  .getASubclass*()
          }

          /**
           * A source of instances of `django.http.response.HttpResponseNotFound`, extend this class to model new instances.
           *
           * This can include instantiations of the class, return values from function
           * calls, or a special parameter that will be set when functions are called by an external
           * library.
           *
           * Use the predicate `HttpResponseNotFound::instance()` to get references to instances of `django.http.response.HttpResponseNotFound`.
           */
          abstract class InstanceSource extends HttpResponse::InstanceSource, DataFlow::Node { }

          /** A direct instantiation of `django.http.response.HttpResponseNotFound`. */
          private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
            ClassInstantiation() { this = classRef().getACall() }

            override DataFlow::Node getBody() {
              result in [this.getArg(0), this.getArgByName("content")]
            }

            // How to support the `headers` argument here?
            override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

            override string getMimetypeDefault() { result = "text/html" }
          }

          /** Gets a reference to an instance of `django.http.response.HttpResponseNotFound`. */
          private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
            t.start() and
            result instanceof InstanceSource
            or
            exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
          }

          /** Gets a reference to an instance of `django.http.response.HttpResponseNotFound`. */
          DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }
        }

        /**
         * Provides models for the `django.http.response.HttpResponseForbidden` class
         *
         * See https://docs.djangoproject.com/en/3.1/ref/request-response/#django.http.HttpResponseForbidden.
         */
        module HttpResponseForbidden {
          /** Gets a reference to the `django.http.response.HttpResponseForbidden` class. */
          API::Node baseClassRef() {
            result = response().getMember("HttpResponseForbidden")
            or
            // Handle `django.http.HttpResponseForbidden` alias
            result = http().getMember("HttpResponseForbidden")
          }

          /** Gets a reference to the `django.http.response.HttpResponseForbidden` class. */
          API::Node classRef() {
            result = baseClassRef().getASubclass*() or
            result =
              ModelOutput::getATypeNode("django.http.response.HttpResponseForbidden~Subclass")
                  .getASubclass*()
          }

          /**
           * A source of instances of `django.http.response.HttpResponseForbidden`, extend this class to model new instances.
           *
           * This can include instantiations of the class, return values from function
           * calls, or a special parameter that will be set when functions are called by an external
           * library.
           *
           * Use the predicate `HttpResponseForbidden::instance()` to get references to instances of `django.http.response.HttpResponseForbidden`.
           */
          abstract class InstanceSource extends HttpResponse::InstanceSource, DataFlow::Node { }

          /** A direct instantiation of `django.http.response.HttpResponseForbidden`. */
          private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
            ClassInstantiation() { this = classRef().getACall() }

            override DataFlow::Node getBody() {
              result in [this.getArg(0), this.getArgByName("content")]
            }

            // How to support the `headers` argument here?
            override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

            override string getMimetypeDefault() { result = "text/html" }
          }

          /** Gets a reference to an instance of `django.http.response.HttpResponseForbidden`. */
          private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
            t.start() and
            result instanceof InstanceSource
            or
            exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
          }

          /** Gets a reference to an instance of `django.http.response.HttpResponseForbidden`. */
          DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }
        }

        /**
         * Provides models for the `django.http.response.HttpResponseNotAllowed` class
         *
         * See https://docs.djangoproject.com/en/3.1/ref/request-response/#django.http.HttpResponseNotAllowed.
         */
        module HttpResponseNotAllowed {
          /** Gets a reference to the `django.http.response.HttpResponseNotAllowed` class. */
          API::Node baseClassRef() {
            result = response().getMember("HttpResponseNotAllowed")
            or
            // Handle `django.http.HttpResponseNotAllowed` alias
            result = http().getMember("HttpResponseNotAllowed")
          }

          /** Gets a reference to the `django.http.response.HttpResponseNotAllowed` class. */
          API::Node classRef() {
            result = baseClassRef().getASubclass*() or
            result =
              ModelOutput::getATypeNode("django.http.response.HttpResponseNotAllowed~Subclass")
                  .getASubclass*()
          }

          /**
           * A source of instances of `django.http.response.HttpResponseNotAllowed`, extend this class to model new instances.
           *
           * This can include instantiations of the class, return values from function
           * calls, or a special parameter that will be set when functions are called by an external
           * library.
           *
           * Use the predicate `HttpResponseNotAllowed::instance()` to get references to instances of `django.http.response.HttpResponseNotAllowed`.
           */
          abstract class InstanceSource extends HttpResponse::InstanceSource, DataFlow::Node { }

          /** A direct instantiation of `django.http.response.HttpResponseNotAllowed`. */
          private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
            ClassInstantiation() { this = classRef().getACall() }

            override DataFlow::Node getBody() {
              // First argument is permitted methods
              result in [this.getArg(1), this.getArgByName("content")]
            }

            // How to support the `headers` argument here?
            override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

            override string getMimetypeDefault() { result = "text/html" }
          }

          /** Gets a reference to an instance of `django.http.response.HttpResponseNotAllowed`. */
          private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
            t.start() and
            result instanceof InstanceSource
            or
            exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
          }

          /** Gets a reference to an instance of `django.http.response.HttpResponseNotAllowed`. */
          DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }
        }

        /**
         * Provides models for the `django.http.response.HttpResponseGone` class
         *
         * See https://docs.djangoproject.com/en/3.1/ref/request-response/#django.http.HttpResponseGone.
         */
        module HttpResponseGone {
          /** Gets a reference to the `django.http.response.HttpResponseGone` class. */
          API::Node baseClassRef() {
            result = response().getMember("HttpResponseGone")
            or
            // Handle `django.http.HttpResponseGone` alias
            result = http().getMember("HttpResponseGone")
          }

          /** Gets a reference to the `django.http.response.HttpResponseGone` class. */
          API::Node classRef() {
            result = baseClassRef().getASubclass*() or
            result =
              ModelOutput::getATypeNode("django.http.response.HttpResponseGone~Subclass")
                  .getASubclass*()
          }

          /**
           * A source of instances of `django.http.response.HttpResponseGone`, extend this class to model new instances.
           *
           * This can include instantiations of the class, return values from function
           * calls, or a special parameter that will be set when functions are called by an external
           * library.
           *
           * Use the predicate `HttpResponseGone::instance()` to get references to instances of `django.http.response.HttpResponseGone`.
           */
          abstract class InstanceSource extends HttpResponse::InstanceSource, DataFlow::Node { }

          /** A direct instantiation of `django.http.response.HttpResponseGone`. */
          private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
            ClassInstantiation() { this = classRef().getACall() }

            override DataFlow::Node getBody() {
              result in [this.getArg(0), this.getArgByName("content")]
            }

            // How to support the `headers` argument here?
            override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

            override string getMimetypeDefault() { result = "text/html" }
          }

          /** Gets a reference to an instance of `django.http.response.HttpResponseGone`. */
          private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
            t.start() and
            result instanceof InstanceSource
            or
            exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
          }

          /** Gets a reference to an instance of `django.http.response.HttpResponseGone`. */
          DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }
        }

        /**
         * Provides models for the `django.http.response.HttpResponseServerError` class
         *
         * See https://docs.djangoproject.com/en/3.1/ref/request-response/#django.http.HttpResponseServerError.
         */
        module HttpResponseServerError {
          /** Gets a reference to the `django.http.response.HttpResponseServerError` class. */
          API::Node baseClassRef() {
            result = response().getMember("HttpResponseServerError")
            or
            // Handle `django.http.HttpResponseServerError` alias
            result = http().getMember("HttpResponseServerError")
          }

          /** Gets a reference to the `django.http.response.HttpResponseServerError` class. */
          API::Node classRef() {
            result = baseClassRef().getASubclass*() or
            result =
              ModelOutput::getATypeNode("django.http.response.HttpResponseServerError~Subclass")
                  .getASubclass*()
          }

          /**
           * A source of instances of `django.http.response.HttpResponseServerError`, extend this class to model new instances.
           *
           * This can include instantiations of the class, return values from function
           * calls, or a special parameter that will be set when functions are called by an external
           * library.
           *
           * Use the predicate `HttpResponseServerError::instance()` to get references to instances of `django.http.response.HttpResponseServerError`.
           */
          abstract class InstanceSource extends HttpResponse::InstanceSource, DataFlow::Node { }

          /** A direct instantiation of `django.http.response.HttpResponseServerError`. */
          private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
            ClassInstantiation() { this = classRef().getACall() }

            override DataFlow::Node getBody() {
              result in [this.getArg(0), this.getArgByName("content")]
            }

            // How to support the `headers` argument here?
            override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

            override string getMimetypeDefault() { result = "text/html" }
          }

          /** Gets a reference to an instance of `django.http.response.HttpResponseServerError`. */
          private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
            t.start() and
            result instanceof InstanceSource
            or
            exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
          }

          /** Gets a reference to an instance of `django.http.response.HttpResponseServerError`. */
          DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }
        }

        /**
         * Provides models for the `django.http.response.JsonResponse` class
         *
         * See https://docs.djangoproject.com/en/3.1/ref/request-response/#jsonresponse-objects.
         */
        module JsonResponse {
          /** Gets a reference to the `django.http.response.JsonResponse` class. */
          API::Node baseClassRef() {
            result = response().getMember("JsonResponse")
            or
            // Handle `django.http.JsonResponse` alias
            result = http().getMember("JsonResponse")
          }

          /** Gets a reference to the `django.http.response.JsonResponse` class. */
          API::Node classRef() {
            result = baseClassRef().getASubclass*() or
            result =
              ModelOutput::getATypeNode("django.http.response.JsonResponse~Subclass")
                  .getASubclass*()
          }

          /**
           * A source of instances of `django.http.response.JsonResponse`, extend this class to model new instances.
           *
           * This can include instantiations of the class, return values from function
           * calls, or a special parameter that will be set when functions are called by an external
           * library.
           *
           * Use the predicate `JsonResponse::instance()` to get references to instances of `django.http.response.JsonResponse`.
           */
          abstract class InstanceSource extends HttpResponse::InstanceSource, DataFlow::Node { }

          /** A direct instantiation of `django.http.response.JsonResponse`. */
          private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
            ClassInstantiation() { this = classRef().getACall() }

            override DataFlow::Node getBody() {
              result in [this.getArg(0), this.getArgByName("data")]
            }

            // How to support the `headers` argument here?
            override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

            override string getMimetypeDefault() { result = "application/json" }
          }

          /** Gets a reference to an instance of `django.http.response.JsonResponse`. */
          private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
            t.start() and
            result instanceof InstanceSource
            or
            exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
          }

          /** Gets a reference to an instance of `django.http.response.JsonResponse`. */
          DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }
        }

        // ---------------------------------------------------------------------------
        // HttpResponse-like classes
        // ---------------------------------------------------------------------------
        /**
         * Provides models for the `django.http.response.StreamingHttpResponse` class
         *
         * See https://docs.djangoproject.com/en/3.1/ref/request-response/#streaminghttpresponse-objects.
         */
        module StreamingHttpResponse {
          /** Gets a reference to the `django.http.response.StreamingHttpResponse` class. */
          API::Node baseClassRef() {
            result = response().getMember("StreamingHttpResponse")
            or
            // Handle `django.http.StreamingHttpResponse` alias
            result = http().getMember("StreamingHttpResponse")
          }

          /** Gets a reference to the `django.http.response.StreamingHttpResponse` class. */
          API::Node classRef() {
            result = baseClassRef().getASubclass*() or
            result =
              ModelOutput::getATypeNode("django.http.response.StreamingHttpResponse~Subclass")
                  .getASubclass*()
          }

          /**
           * A source of instances of `django.http.response.StreamingHttpResponse`, extend this class to model new instances.
           *
           * This can include instantiations of the class, return values from function
           * calls, or a special parameter that will be set when functions are called by an external
           * library.
           *
           * Use the predicate `StreamingHttpResponse::instance()` to get references to instances of `django.http.response.StreamingHttpResponse`.
           */
          abstract class InstanceSource extends HttpResponse::InstanceSource, DataFlow::Node { }

          /** A direct instantiation of `django.http.response.StreamingHttpResponse`. */
          private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
            ClassInstantiation() { this = classRef().getACall() }

            override DataFlow::Node getBody() {
              result in [this.getArg(0), this.getArgByName("streaming_content")]
            }

            // How to support the `headers` argument here?
            override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

            override string getMimetypeDefault() { result = "text/html" }
          }

          /** Gets a reference to an instance of `django.http.response.StreamingHttpResponse`. */
          private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
            t.start() and
            result instanceof InstanceSource
            or
            exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
          }

          /** Gets a reference to an instance of `django.http.response.StreamingHttpResponse`. */
          DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }
        }

        /**
         * Provides models for the `django.http.response.FileResponse` class
         *
         * See https://docs.djangoproject.com/en/3.1/ref/request-response/#fileresponse-objects.
         */
        module FileResponse {
          /** Gets a reference to the `django.http.response.FileResponse` class. */
          API::Node baseClassRef() {
            result = response().getMember("FileResponse")
            or
            // Handle `django.http.FileResponse` alias
            result = http().getMember("FileResponse")
          }

          /** Gets a reference to the `django.http.response.FileResponse` class. */
          API::Node classRef() {
            result = baseClassRef().getASubclass*() or
            result =
              ModelOutput::getATypeNode("django.http.response.FileResponse~Subclass")
                  .getASubclass*()
          }

          /**
           * A source of instances of `django.http.response.FileResponse`, extend this class to model new instances.
           *
           * This can include instantiations of the class, return values from function
           * calls, or a special parameter that will be set when functions are called by an external
           * library.
           *
           * Use the predicate `FileResponse::instance()` to get references to instances of `django.http.response.FileResponse`.
           */
          abstract class InstanceSource extends HttpResponse::InstanceSource, DataFlow::Node { }

          /** A direct instantiation of `django.http.response.FileResponse`. */
          private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
            ClassInstantiation() { this = classRef().getACall() }

            override DataFlow::Node getBody() {
              result in [this.getArg(0), this.getArgByName("streaming_content")]
            }

            // How to support the `headers` argument here?
            override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

            override string getMimetypeDefault() {
              // see https://github.com/django/django/blob/ebb08d19424c314c75908bc6048ff57c2f872269/django/http/response.py#L471-L479
              result = "application/octet-stream"
            }
          }

          /** Gets a reference to an instance of `django.http.response.FileResponse`. */
          private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
            t.start() and
            result instanceof InstanceSource
            or
            exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
          }

          /** Gets a reference to an instance of `django.http.response.FileResponse`. */
          DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }
        }

        /** Gets a reference to the `django.http.response.HttpResponse.write` function. */
        private DataFlow::TypeTrackingNode write(
          DjangoImpl::DjangoHttp::Response::HttpResponse::InstanceSource instance,
          DataFlow::TypeTracker t
        ) {
          t.startInAttr("write") and
          instance = DjangoImpl::DjangoHttp::Response::HttpResponse::instance() and
          result = instance
          or
          exists(DataFlow::TypeTracker t2 | result = write(instance, t2).track(t2, t))
        }

        /** Gets a reference to the `django.http.response.HttpResponse.write` function. */
        DataFlow::Node write(DjangoImpl::DjangoHttp::Response::HttpResponse::InstanceSource instance) {
          write(instance, DataFlow::TypeTracker::end()).flowsTo(result)
        }

        /**
         * A call to the `django.http.response.HttpResponse.write` function.
         *
         * See https://docs.djangoproject.com/en/3.1/ref/request-response/#django.http.HttpResponse.write
         */
        class HttpResponseWriteCall extends Http::Server::HttpResponse::Range, DataFlow::CallCfgNode
        {
          DjangoImpl::DjangoHttp::Response::HttpResponse::InstanceSource instance;

          HttpResponseWriteCall() { this.getFunction() = write(instance) }

          override DataFlow::Node getBody() {
            result in [this.getArg(0), this.getArgByName("content")]
          }

          override DataFlow::Node getMimetypeOrContentTypeArg() {
            result = instance.getMimetypeOrContentTypeArg()
          }

          override string getMimetypeDefault() { result = instance.getMimetypeDefault() }
        }

        /**
         * A call to `set_cookie` on a HTTP Response.
         */
        class DjangoResponseSetCookieCall extends Http::Server::SetCookieCall,
          DataFlow::MethodCallNode
        {
          DjangoResponseSetCookieCall() {
            this.calls(DjangoImpl::DjangoHttp::Response::HttpResponse::instance(), "set_cookie")
          }

          override DataFlow::Node getHeaderArg() { none() }

          override DataFlow::Node getNameArg() {
            result in [this.getArg(0), this.getArgByName("key")]
          }

          override DataFlow::Node getValueArg() {
            result in [this.getArg(1), this.getArgByName("value")]
          }
        }

        /**
         * A call to `delete_cookie` on a HTTP Response.
         */
        class DjangoResponseDeleteCookieCall extends Http::Server::CookieWrite::Range,
          DataFlow::MethodCallNode
        {
          DjangoResponseDeleteCookieCall() {
            this.calls(DjangoImpl::DjangoHttp::Response::HttpResponse::instance(), "delete_cookie")
          }

          override DataFlow::Node getHeaderArg() { none() }

          override DataFlow::Node getNameArg() {
            result in [this.getArg(0), this.getArgByName("key")]
          }

          override DataFlow::Node getValueArg() { none() }
        }

        /**
         * A dict-like write to an item of the `cookies` attribute on a HTTP response, such as
         * `response.cookies[name] = value`.
         */
        class DjangoResponseCookieSubscriptWrite extends Http::Server::CookieWrite::Range {
          DataFlow::Node index;
          DataFlow::Node value;

          DjangoResponseCookieSubscriptWrite() {
            exists(SubscriptNode subscript, DataFlow::AttrRead cookieLookup |
              // To give `this` a value, we need to choose between either LHS or RHS,
              // and just go with the LHS
              this.asCfgNode() = subscript
            |
              cookieLookup.getAttributeName() = "cookies" and
              cookieLookup.getObject() = DjangoImpl::DjangoHttp::Response::HttpResponse::instance() and
              exists(DataFlow::Node subscriptObj |
                subscriptObj.asCfgNode() = subscript.getObject()
              |
                cookieLookup.flowsTo(subscriptObj)
              ) and
              value.asCfgNode() = subscript.(DefinitionNode).getValue() and
              index.asCfgNode() = subscript.getIndex()
            )
          }

          override DataFlow::Node getHeaderArg() { none() }

          override DataFlow::Node getNameArg() { result = index }

          override DataFlow::Node getValueArg() { result = value }
        }

        /**
         * A dict-like write to an item of the `headers` attribute on a HTTP response, such as
         * `response.headers[name] = value`.
         */
        class DjangoResponseHeaderSubscriptWrite extends Http::Server::ResponseHeaderWrite::Range {
          DataFlow::Node index;
          DataFlow::Node value;

          DjangoResponseHeaderSubscriptWrite() {
            exists(SubscriptNode subscript, DataFlow::AttrRead headerLookup |
              // To give `this` a value, we need to choose between either LHS or RHS,
              // and just go with the LHS
              this.asCfgNode() = subscript
            |
              headerLookup
                  .accesses(DjangoImpl::DjangoHttp::Response::HttpResponse::instance(), "headers") and
              exists(DataFlow::Node subscriptObj |
                subscriptObj.asCfgNode() = subscript.getObject()
              |
                headerLookup.flowsTo(subscriptObj)
              ) and
              value.asCfgNode() = subscript.(DefinitionNode).getValue() and
              index.asCfgNode() = subscript.getIndex()
            )
          }

          override DataFlow::Node getNameArg() { result = index }

          override DataFlow::Node getValueArg() { result = value }

          override predicate nameAllowsNewline() { none() }

          override predicate valueAllowsNewline() { none() }
        }

        /**
         * A dict-like write to an item of an HTTP response, which is treated as a header write,
         * such as `response[headerName] = value`
         */
        class DjangoResponseSubscriptWrite extends Http::Server::ResponseHeaderWrite::Range {
          DataFlow::Node index;
          DataFlow::Node value;

          DjangoResponseSubscriptWrite() {
            exists(SubscriptNode subscript |
              // To give `this` a value, we need to choose between either LHS or RHS,
              // and just go with the LHS
              this.asCfgNode() = subscript
            |
              subscript.getObject() =
                DjangoImpl::DjangoHttp::Response::HttpResponse::instance().asCfgNode() and
              value.asCfgNode() = subscript.(DefinitionNode).getValue() and
              index.asCfgNode() = subscript.getIndex()
            )
          }

          override DataFlow::Node getNameArg() { result = index }

          override DataFlow::Node getValueArg() { result = value }

          override predicate nameAllowsNewline() { none() }

          override predicate valueAllowsNewline() { none() }
        }
      }
    }

    // -------------------------------------------------------------------------
    // django.shortcuts
    // -------------------------------------------------------------------------
    /** Gets a reference to the `django.shortcuts` module. */
    API::Node shortcuts() { result = django().getMember("shortcuts") }

    /** Provides models for the `django.shortcuts` module */
    module Shortcuts {
      /**
       * Gets a reference to the `django.shortcuts.redirect` function
       *
       * See https://docs.djangoproject.com/en/3.1/topics/http/shortcuts/#redirect
       */
      API::Node redirect() { result = shortcuts().getMember("redirect") }
    }
  }

  // ---------------------------------------------------------------------------
  // Form and form field modeling
  // ---------------------------------------------------------------------------
  /**
   * A class that is a subclass of the `django.forms.Form` class,
   * thereby handling user input.
   */
  class DjangoFormClass extends Class, SelfRefMixin {
    DjangoFormClass() { this.getParent() = Django::Forms::Form::subclassRef().asSource().asExpr() }
  }

  /**
   * A source of cleaned_data (either the return value from `super().clean()`, or a reference to `self.cleaned_data`)
   *
   * See https://docs.djangoproject.com/en/3.1/ref/forms/validation/#form-and-field-validation
   */
  private class DjangoFormCleanedData extends RemoteFlowSource::Range, DataFlow::Node {
    DjangoFormCleanedData() {
      exists(DjangoFormClass cls, Function meth |
        cls.getAMethod() = meth and
        (
          this = API::builtin("super").getReturn().getMember("clean").getACall() and
          this.getScope() = meth
          or
          this.(DataFlow::AttrRead).getAttributeName() = "cleaned_data" and
          this.(DataFlow::AttrRead).getObject() = cls.getASelfRef()
        )
      )
    }

    override string getSourceType() {
      result = "django.forms.Field subclass, value parameter in method"
    }
  }

  /**
   * A class that is a subclass of the `django.forms.Field` class,
   * thereby handling user input.
   */
  class DjangoFormFieldClass extends Class {
    DjangoFormFieldClass() {
      this.getParent() = Django::Forms::Field::subclassRef().asSource().asExpr()
    }
  }

  /**
   * A parameter in a method on a `DjangoFormFieldClass` that receives the user-supplied value for this field.
   *
   * See https://docs.djangoproject.com/en/3.1/ref/forms/validation/#form-and-field-validation
   */
  private class DjangoFormFieldValueParam extends RemoteFlowSource::Range, DataFlow::ParameterNode {
    DjangoFormFieldValueParam() {
      exists(DjangoFormFieldClass cls, Function meth |
        cls.getAMethod() = meth and
        meth.getName() in ["to_python", "validate", "run_validators", "clean"] and
        this.getParameter() = meth.getArg(1)
      )
    }

    override string getSourceType() {
      result = "django.forms.Field subclass, value parameter in method"
    }
  }

  // ---------------------------------------------------------------------------
  // routing modeling
  // ---------------------------------------------------------------------------
  /**
   * A class that may be a django view class. In order to recognize a class as being a django view class,
   * based on the `as_view`
   * call, we need to be able to track such calls on _any_ class. This is provided by
   * the member predicates of this QL class.
   *
   * As such, a Python class being part of `DjangoViewClassHelper` doesn't signify that
   * we model it as a django view class.
   */
  class DjangoViewClassHelper extends Class {
    /** Gets a reference to this class. */
    private DataFlow::TypeTrackingNode getARef(DataFlow::TypeTracker t) {
      t.start() and
      result.asExpr() = this.getParent()
      or
      exists(DataFlow::TypeTracker t2 | result = this.getARef(t2).track(t2, t))
    }

    /** Gets a reference to this class. */
    DataFlow::Node getARef() { this.getARef(DataFlow::TypeTracker::end()).flowsTo(result) }

    /** Gets a reference to the `as_view` classmethod of this class. */
    private DataFlow::TypeTrackingNode asViewRef(DataFlow::TypeTracker t) {
      t.startInAttr("as_view") and
      result = this.getARef()
      or
      exists(DataFlow::TypeTracker t2 | result = this.asViewRef(t2).track(t2, t))
    }

    /** Gets a reference to the `as_view` classmethod of this class. */
    DataFlow::Node asViewRef() { this.asViewRef(DataFlow::TypeTracker::end()).flowsTo(result) }

    /** Gets a reference to the result of calling the `as_view` classmethod of this class. */
    private DataFlow::TypeTrackingNode asViewResult(DataFlow::TypeTracker t) {
      t.start() and
      result.asCfgNode().(CallNode).getFunction() = this.asViewRef().asCfgNode()
      or
      exists(DataFlow::TypeTracker t2 | result = this.asViewResult(t2).track(t2, t))
    }

    /** Gets a reference to the result of calling the `as_view` classmethod of this class. */
    DataFlow::Node asViewResult() {
      this.asViewResult(DataFlow::TypeTracker::end()).flowsTo(result)
    }
  }

  /** A class that we consider a django View class. */
  abstract class DjangoViewClass extends DjangoViewClassHelper, SelfRefMixin {
    /** Gets a function that could handle incoming requests, if any. */
    Function getARequestHandler() {
      // TODO: This doesn't handle attribute assignment. Should be OK, but analysis is not as complete as with
      // points-to and `.lookup`, which would handle `post = my_post_handler` inside class def
      result = this.getAMethod() and
      (
        result.getName() = Http::httpVerbLower()
        or
        result.getName() = "get_redirect_url"
      )
    }
  }

  /**
   * A class that is used in a route-setup, with `<class>.as_view()`, therefore being
   * considered a django View class.
   */
  class DjangoViewClassFromRouteSetup extends DjangoViewClass {
    DjangoViewClassFromRouteSetup() {
      exists(DjangoRouteSetup setup | setup.getViewArg() = this.asViewResult())
    }
  }

  /**
   * A class that has a super-type which is a django View class, therefore also
   * becoming a django View class.
   */
  class DjangoViewClassFromSuperClass extends DjangoViewClass {
    DjangoViewClassFromSuperClass() {
      this.getParent() = Django::Views::View::subclassRef().asSource().asExpr()
    }
  }

  /**
   * A function that is a django route handler, meaning it handles incoming requests
   * with the django framework.
   *
   * Most functions take a django HttpRequest as a parameter (but not all).
   *
   * Extend this class to refine existing API models. If you want to model new APIs,
   * extend `DjangoRouteHandler::Range` instead.
   */
  class DjangoRouteHandler extends Function instanceof DjangoRouteHandler::Range {
    /**
     * Gets the index of the parameter where the first routed parameter can be passed --
     * that is, the one just after any possible `self` or HttpRequest parameters.
     */
    int getFirstPossibleRoutedParamIndex() { result = 1 + this.getRequestParamIndex() }

    /** Gets the index of the request parameter. */
    int getRequestParamIndex() {
      not this.isMethod() and
      result = 0
      or
      this.isMethod() and
      result = 1
    }

    /** Gets the request parameter. */
    Parameter getRequestParam() { result = this.getArg(this.getRequestParamIndex()) }
  }

  /** Provides a class for modeling new django route handlers. */
  module DjangoRouteHandler {
    /**
     * A django route handler. Extend this class to model new APIs. If you want to refine existing API models,
     * extend `DjangoRouteHandler` instead.
     */
    abstract class Range extends Function { }

    /** Route handlers from normal usage of django. */
    private class StandardDjangoRouteHandlers extends Range {
      StandardDjangoRouteHandlers() {
        exists(DjangoRouteSetup route | route.getViewArg() = poorMansFunctionTracker(this))
        or
        any(DjangoViewClass vc).getARequestHandler() = this
      }
    }
  }

  /**
   * A method named `get_redirect_url` on a django view class.
   *
   * See https://docs.djangoproject.com/en/3.1/ref/class-based-views/base/#django.views.generic.base.RedirectView.get_redirect_url
   *
   * Note: this function only does something on a subclass of `RedirectView`, but since
   * classes can be considered django view classes without us knowing their super-classes,
   * we need to consider _any_ django view class. I don't expect any problems to come from this.
   */
  private class GetRedirectUrlFunction extends DjangoRouteHandler {
    GetRedirectUrlFunction() {
      this.getName() = "get_redirect_url" and
      any(DjangoViewClass vc).getARequestHandler() = this
    }

    override int getFirstPossibleRoutedParamIndex() { result = 1 }

    override int getRequestParamIndex() { none() }
  }

  /** A data-flow node that sets up a route on a server, using the django framework. */
  abstract class DjangoRouteSetup extends Http::Server::RouteSetup::Range, DataFlow::CfgNode {
    /** Gets the data-flow node that is used as the argument for the view handler. */
    abstract DataFlow::Node getViewArg();

    final override DjangoRouteHandler getARequestHandler() {
      poorMansFunctionTracker(result) = this.getViewArg()
      or
      exists(DjangoViewClass vc |
        this.getViewArg() = vc.asViewResult() and
        result = vc.getARequestHandler()
      )
    }

    override string getFramework() { result = "Django" }
  }

  /** A request handler defined in a django view class, that has no known route. */
  private class DjangoViewClassHandlerWithoutKnownRoute extends Http::Server::RequestHandler::Range,
    DjangoRouteHandler
  {
    DjangoViewClassHandlerWithoutKnownRoute() {
      exists(DjangoViewClass vc | vc.getARequestHandler() = this) and
      not exists(DjangoRouteSetup setup | setup.getARequestHandler() = this)
    }

    override Parameter getARoutedParameter() {
      // Since we don't know the URL pattern, we simply mark all parameters as a routed
      // parameter. This should give us more RemoteFlowSources but could also lead to
      // more FPs. If this turns out to be the wrong tradeoff, we can always change our mind.
      result in [
          this.getArg(_), this.getArgByName(_), //
          this.getVararg().(Parameter), this.getKwarg().(Parameter), // TODO: These sources should be modeled as storing content!
        ] and
      not result = any(int i | i < this.getFirstPossibleRoutedParamIndex() | this.getArg(i))
    }

    override string getFramework() { result = "Django" }
  }

  /**
   * Gets the regex that is used by django to find routed parameters when using `django.urls.path`.
   *
   * Taken from https://github.com/django/django/blob/7d1bf29977bb368d7c28e7c6eb146db3b3009ae7/django/urls/resolvers.py#L199
   */
  private string pathRoutedParameterRegex() {
    result = "<(?:(?<converter>[^>:]+):)?(?<parameter>\\w+)>"
  }

  /**
   * A call to `django.urls.path`.
   *
   * See https://docs.djangoproject.com/en/3.0/ref/urls/#path
   */
  private class DjangoUrlsPathCall extends DjangoRouteSetup, DataFlow::CallCfgNode {
    DjangoUrlsPathCall() { this = DjangoImpl::Urls::path().getACall() }

    override DataFlow::Node getUrlPatternArg() {
      result in [this.getArg(0), this.getArgByName("route")]
    }

    override DataFlow::Node getViewArg() { result in [this.getArg(1), this.getArgByName("view")] }

    override Parameter getARoutedParameter() {
      // If we don't know the URL pattern, we simply mark all parameters as a routed
      // parameter. This should give us more RemoteFlowSources but could also lead to
      // more FPs. If this turns out to be the wrong tradeoff, we can always change our mind.
      exists(DjangoRouteHandler routeHandler | routeHandler = this.getARequestHandler() |
        not exists(this.getUrlPattern()) and
        result in [
            routeHandler.getArg(_), routeHandler.getArgByName(_), //
            routeHandler.getVararg().(Parameter), routeHandler.getKwarg().(Parameter), // TODO: These sources should be modeled as storing content!
          ] and
        not result =
          any(int i | i < routeHandler.getFirstPossibleRoutedParamIndex() | routeHandler.getArg(i))
      )
      or
      exists(string name |
        (
          result = this.getARequestHandler().getKwarg() // TODO: These sources should be modeled as storing content!
          or
          result = this.getARequestHandler().getArgByName(name)
        ) and
        exists(string match |
          match = this.getUrlPattern().regexpFind(pathRoutedParameterRegex(), _, _) and
          name = match.regexpCapture(pathRoutedParameterRegex(), 2)
        )
      )
    }
  }

  /** A Django route setup that uses a Regex to specify route (and routed parameters). */
  abstract private class DjangoRegexRouteSetup extends DjangoRouteSetup {
    override Parameter getARoutedParameter() {
      // If we don't know the URL pattern, we simply mark all parameters as a routed
      // parameter. This should give us more RemoteFlowSources but could also lead to
      // more FPs. If this turns out to be the wrong tradeoff, we can always change our mind.
      exists(DjangoRouteHandler routeHandler | routeHandler = this.getARequestHandler() |
        not exists(this.getUrlPattern()) and
        result in [
            routeHandler.getArg(_), routeHandler.getArgByName(_), //
            routeHandler.getVararg().(Parameter), routeHandler.getKwarg().(Parameter), // TODO: These sources should be modeled as storing content!
          ] and
        not result =
          any(int i | i < routeHandler.getFirstPossibleRoutedParamIndex() | routeHandler.getArg(i))
      )
      or
      exists(DjangoRouteHandler routeHandler, DjangoRouteRegex regexUse, RegExp regex |
        regex.getAUse() = regexUse and
        routeHandler = this.getARequestHandler() and
        regexUse.getRouteSetup() = this
      |
        // either using named capture groups (passed as keyword arguments) or using
        // unnamed capture groups (passed as positional arguments)
        not exists(regex.getGroupName(_, _)) and
        (
          // first group will have group number 1
          result =
            routeHandler
                .getArg(routeHandler.getFirstPossibleRoutedParamIndex() - 1 +
                    regex.getGroupNumber(_, _))
          or
          result = routeHandler.getVararg()
        )
        or
        exists(regex.getGroupName(_, _)) and
        (
          result = routeHandler.getArgByName(regex.getGroupName(_, _))
          or
          result = routeHandler.getKwarg()
        )
      )
    }
  }

  /**
   * A regex that is used to set up a route.
   *
   * Needs this subclass to be considered a RegExpInterpretation.
   */
  private class DjangoRouteRegex extends RegExpInterpretation::Range {
    DjangoRegexRouteSetup rePathCall;

    DjangoRouteRegex() { this = rePathCall.getUrlPatternArg() }

    DjangoRegexRouteSetup getRouteSetup() { result = rePathCall }
  }

  /**
   * A call to `django.urls.re_path`.
   *
   * See https://docs.djangoproject.com/en/3.0/ref/urls/#re_path
   */
  private class DjangoUrlsRePathCall extends DjangoRegexRouteSetup, DataFlow::CallCfgNode {
    DjangoUrlsRePathCall() {
      this = DjangoImpl::Urls::re_path().getACall() and
      // `django.conf.urls.url` (which we support directly with
      // `DjangoConfUrlsUrlCall`), is implemented in Django 2+ as backward compatibility
      // using `django.urls.re_path`. See
      // https://github.com/django/django/blob/stable/3.2.x/django/conf/urls/__init__.py#L22
      // Since we're still installing dependencies and analyzing their source code,
      // without explicitly filtering out this call, we would be double-counting such
      // route-setups :( One practical negative side effect of double-counting it, is
      // that since we can't figure out the URL in the library code calling `django.urls.re_path`
      // (because we only consider local flow), we will for all those cases mark ANY parameter
      // as being a routed-parameter, which can lead to FPs.
      not exists(Module mod |
        mod.getName() = "django.conf.urls.__init__" and
        node.getEnclosingModule() = mod
      )
    }

    override DataFlow::Node getUrlPatternArg() {
      result in [this.getArg(0), this.getArgByName("route")]
    }

    override DataFlow::Node getViewArg() { result in [this.getArg(1), this.getArgByName("view")] }
  }

  /**
   * A call to `django.conf.urls.url`.
   *
   * See https://docs.djangoproject.com/en/1.11/ref/urls/#django.conf.urls.url
   */
  private class DjangoConfUrlsUrlCall extends DjangoRegexRouteSetup, DataFlow::CallCfgNode {
    DjangoConfUrlsUrlCall() { this = DjangoImpl::Conf::ConfUrls::url().getACall() }

    override DataFlow::Node getUrlPatternArg() {
      result in [this.getArg(0), this.getArgByName("regex")]
    }

    override DataFlow::Node getViewArg() { result in [this.getArg(1), this.getArgByName("view")] }
  }

  // ---------------------------------------------------------------------------
  // HttpRequest taint modeling
  // ---------------------------------------------------------------------------
  /** A parameter that will receive the django `HttpRequest` instance when a request handler is invoked. */
  private class DjangoRequestHandlerRequestParam extends DjangoImpl::DjangoHttp::Request::HttpRequest::InstanceSource,
    RemoteFlowSource::Range, DataFlow::ParameterNode
  {
    DjangoRequestHandlerRequestParam() {
      this.getParameter() = any(DjangoRouteSetup setup).getARequestHandler().getRequestParam()
      or
      this.getParameter() = any(DjangoViewClassHandlerWithoutKnownRoute setup).getRequestParam()
    }

    override string getSourceType() { result = "django.http.request.HttpRequest" }
  }

  /**
   * A read of the `request` attribute on a reference to an instance of a View class,
   * which is the request being processed currently.
   *
   * See https://docs.djangoproject.com/en/3.1/topics/class-based-views/generic-display/#dynamic-filtering
   */
  private class DjangoViewClassRequestAttributeRead extends DjangoImpl::DjangoHttp::Request::HttpRequest::InstanceSource,
    RemoteFlowSource::Range, DataFlow::Node
  {
    DjangoViewClassRequestAttributeRead() {
      exists(DataFlow::AttrRead read | this = read |
        read.getObject() = any(DjangoViewClass vc).getASelfRef() and
        read.getAttributeName() = "request"
      )
    }

    override string getSourceType() {
      result = "django HttpRequest from self.request in View class"
    }
  }

  /**
   * A read of the `args` or `kwargs` attribute on a reference to an instance of a View class,
   * which contains the routed parameters captured from the URL route.
   *
   * See https://docs.djangoproject.com/en/3.1/topics/class-based-views/generic-display/#dynamic-filtering
   */
  private class DjangoViewClassRoutedParamsAttributeRead extends RemoteFlowSource::Range,
    DataFlow::Node
  {
    DjangoViewClassRoutedParamsAttributeRead() {
      exists(DataFlow::AttrRead read | this = read |
        read.getObject() = any(DjangoViewClass vc).getASelfRef() and
        read.getAttributeName() in ["args", "kwargs"]
      )
    }

    override string getSourceType() {
      result = "django routed param from self.args/kwargs in View class"
    }
  }

  /**
   * A parameter that accepts the filename used to upload a file. This is the second
   * parameter in functions used for the `upload_to` argument to a `FileField`.
   *
   * Note that the value this parameter accepts cannot contain a slash. Even when
   * forcing the filename to contain a slash when sending the request, django does
   * something like `input_filename.split("/")[-1]` (so other special characters still
   * allowed). This also means that although the return value from `upload_to` is used
   * to construct a path, path injection is not possible.
   *
   * See
   *  - https://docs.djangoproject.com/en/3.1/ref/models/fields/#django.db.models.FileField.upload_to
   *  - https://docs.djangoproject.com/en/3.1/topics/http/file-uploads/#handling-uploaded-files-with-a-model
   */
  private class DjangoFileFieldUploadToFunctionFilenameParam extends RemoteFlowSource::Range,
    DataFlow::ParameterNode
  {
    DjangoFileFieldUploadToFunctionFilenameParam() {
      exists(DataFlow::CallCfgNode call, DataFlow::Node uploadToArg, Function func |
        this.getParameter() = func.getArg(1) and
        call = DjangoImpl::DB::Models::FileField::subclassRef().getACall() and
        uploadToArg in [call.getArg(2), call.getArgByName("upload_to")] and
        uploadToArg = poorMansFunctionTracker(func)
      )
    }

    override string getSourceType() {
      result = "django filename parameter to function used in FileField.upload_to"
    }
  }

  // ---------------------------------------------------------------------------
  // django.shortcuts.redirect
  // ---------------------------------------------------------------------------
  /**
   * A call to `django.shortcuts.redirect`.
   *
   * Note: This works differently depending on what argument is used.
   * _One_ option is to redirect to a full URL.
   *
   * See https://docs.djangoproject.com/en/3.1/topics/http/shortcuts/#redirect
   */
  private class DjangoShortcutsRedirectCall extends Http::Server::HttpRedirectResponse::Range,
    DataFlow::CallCfgNode
  {
    DjangoShortcutsRedirectCall() { this = DjangoImpl::Shortcuts::redirect().getACall() }

    /**
     * Gets the data-flow node that specifies the location of this HTTP redirect response.
     *
     * Note: For `django.shortcuts.redirect`, the result might not be a full URL
     * (as usually expected by this method), but could be a relative URL,
     * a string identifying a view, or a Django model.
     */
    override DataFlow::Node getRedirectLocation() {
      result in [this.getArg(0), this.getArgByName("to")]
    }

    override DataFlow::Node getBody() { none() }

    override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

    override string getMimetypeDefault() { none() }
  }

  // ---------------------------------------------------------------------------
  // RedirectView handling
  // ---------------------------------------------------------------------------
  /**
   * A return from a method named `get_redirect_url` on a django view class.
   *
   * Note that in reality, this only does something on a subclass of `RedirectView` --
   * but until API graphs makes this easy to model, I took a shortcut in modeling
   * preciseness.
   *
   * See https://docs.djangoproject.com/en/3.1/ref/class-based-views/base/#redirectview
   */
  private class DjangoRedirectViewGetRedirectUrlReturn extends Http::Server::HttpRedirectResponse::Range,
    DataFlow::CfgNode
  {
    DjangoRedirectViewGetRedirectUrlReturn() {
      node = any(GetRedirectUrlFunction f).getAReturnValueFlowNode()
    }

    override DataFlow::Node getRedirectLocation() { result = this }

    override DataFlow::Node getBody() { none() }

    override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

    override string getMimetypeDefault() { none() }
  }

  // ---------------------------------------------------------------------------
  // Logging
  // ---------------------------------------------------------------------------
  /**
   * A standard Python logger instance from Django.
   * see https://github.com/django/django/blob/stable/4.0.x/django/utils/log.py#L11
   */
  private class DjangoLogger extends Stdlib::Logger::InstanceSource {
    DjangoLogger() {
      this =
        API::moduleImport("django")
            .getMember("utils")
            .getMember("log")
            .getMember("request_logger")
            .asSource()
    }
  }

  // ---------------------------------------------------------------------------
  // Settings
  // ---------------------------------------------------------------------------
  /**
   * A custom middleware stack
   */
  private class DjangoSettingsMiddlewareStack extends Http::Server::CsrfProtectionSetting::Range {
    List list;

    DjangoSettingsMiddlewareStack() {
      this.asExpr() = list and
      // we look for an assignment to the `MIDDLEWARE` setting
      exists(DataFlow::Node mw |
        mw.asExpr().(Name).getId() = "MIDDLEWARE" and
        DataFlow::localFlow(this, mw)
      |
        // To only include results where CSRF protection matters, we only care about CSRF
        // protection when the django authentication middleware is enabled.
        // Since an active session cookie is exactly what would allow an attacker to perform
        // a CSRF attack.
        // Notice that this does not ensure that this is not a FP, since the authentication
        // middleware might be unused.
        //
        // This also strongly implies that `mw` is in fact a Django middleware setting and
        // not just a variable named `MIDDLEWARE`.
        list.getAnElt().(StringLiteral).getText() =
          "django.contrib.auth.middleware.AuthenticationMiddleware"
      )
    }

    override boolean getVerificationSetting() {
      if
        list.getAnElt().(StringLiteral).getText() in [
            "django.middleware.csrf.CsrfViewMiddleware",
            // see https://github.com/mozilla/django-session-csrf
            "session_csrf.CsrfMiddleware"
          ]
      then result = true
      else result = false
    }
  }

  private class DjangoCsrfDecorator extends Http::Server::CsrfLocalProtectionSetting::Range {
    string decoratorName;
    Function function;

    DjangoCsrfDecorator() {
      decoratorName in ["csrf_protect", "csrf_exempt", "requires_csrf_token", "ensure_csrf_cookie"] and
      this =
        API::moduleImport("django")
            .getMember("views")
            .getMember("decorators")
            .getMember("csrf")
            .getMember(decoratorName)
            .getAValueReachableFromSource() and
      this.asExpr() = function.getADecorator()
    }

    override Function getRequestHandler() { result = function }

    override predicate csrfEnabled() { decoratorName in ["csrf_protect", "requires_csrf_token"] }
  }

  private predicate djangoUrlHasAllowedHostAndScheme(
    DataFlow::GuardNode g, ControlFlowNode node, boolean branch
  ) {
    exists(API::CallNode call |
      call =
        API::moduleImport("django")
            .getMember("utils")
            .getMember("http")
            .getMember("url_has_allowed_host_and_scheme")
            .getACall() and
      g = call.asCfgNode() and
      node = call.getParameter(0, "url").asSink().asCfgNode() and
      branch = true
    )
  }

  /**
   * A call to `django.utils.http.url_has_allowed_host_and_scheme`, considered as a sanitizer-guard for URL redirection.
   *
   * See https://docs.djangoproject.com/en/4.2/_modules/django/utils/http/
   */
  private class DjangoAllowedUrl extends UrlRedirect::Sanitizer {
    DjangoAllowedUrl() {
      this = DataFlow::BarrierGuard<djangoUrlHasAllowedHostAndScheme/3>::getABarrierNode()
    }

    override predicate sanitizes(UrlRedirect::FlowState state) {
      // sanitize all flow states
      any()
    }
  }

  // ---------------------------------------------------------------------------
  // Templates
  // ---------------------------------------------------------------------------
  /** A call to `django.template.Template` */
  private class DjangoTemplateConstruction extends TemplateConstruction::Range, API::CallNode {
    DjangoTemplateConstruction() {
      this = API::moduleImport("django").getMember("template").getMember("Template").getACall()
    }

    override DataFlow::Node getSourceArg() { result = this.getArg(0) }
  }
  // TODO: Support `from_string` on instances of `django.template.Engine`.
}
