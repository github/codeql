/**
 * INTERNAL: Do not use.
 *
 * Provides results from semi-automated modeling of PyPI packages.
 */

// Instructions:
// This needs to be automated better, but for this prototype, here are some rough instructions:
// 1) run `FindNewModels.ql` against a new CodeQL DB
// 2) do some magic formatting commands yourself
// 3) paste the data into the `automatedModeledClassData` predicate
private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.ApiGraphs
private import semmle.python.frameworks.Django

bindingset[fullyQaulified]
string fullyQualifiedToAPIGraphPath(string fullyQaulified) {
  result = "moduleImport(\"" + fullyQaulified.replaceAll(".", "\").getMember(\"") + "\")"
}

API::Node automatedModeledClass(string spec, string qualifier) {
  automatedModeledClassData(spec, qualifier) and
  result.getPath() = fullyQualifiedToAPIGraphPath(qualifier)
}

// -- Specs --
bindingset[this]
abstract class FindSubclassesSpec extends string {
  abstract API::Node getAlreadyModeledClass();
}

class DjangoViewSubclass extends FindSubclassesSpec {
  DjangoViewSubclass() { this = "Django::Views::View" }

  override API::Node getAlreadyModeledClass() {
    result = any(Django::Views::View::ModeledSubclass subclass)
  }
}

class DjangoFormSubclass extends FindSubclassesSpec {
  DjangoFormSubclass() { this = "Django::Forms::Form" }

  override API::Node getAlreadyModeledClass() {
    result = any(Django::Forms::Form::ModeledSubclass subclass)
  }
}

class DjangoFieldSubclass extends FindSubclassesSpec {
  DjangoFieldSubclass() { this = "Django::Forms::Field" }

  override API::Node getAlreadyModeledClass() {
    result = any(Django::Forms::Field::ModeledSubclass subclass)
  }
}

// -- actual data -- (this should live in a CSV file in the future) -- probably one _per_ PyPI package / project
predicate automatedModeledClassData(string spec, string qualifier) {
  // from `django` PyPI package analyzed on 2021-03-29
  (
    spec = "Django::Forms::Form" and
    qualifier = "django.contrib.admin.views.main.ChangeListSearchForm"
    or
    spec = "Django::Views::View" and qualifier = "django.contrib.admindocs.views.BaseAdminDocsView"
    or
    spec = "Django::Views::View" and
    qualifier = "django.contrib.admin.views.autocomplete.AutocompleteJsonView"
    or
    spec = "Django::Views::View" and qualifier = "django.views.generic.dates.BaseDateListView"
    or
    spec = "Django::Views::View" and qualifier = "django.views.generic.dates.BaseArchiveIndexView"
    or
    spec = "Django::Views::View" and qualifier = "django.views.generic.dates.BaseYearArchiveView"
    or
    spec = "Django::Views::View" and qualifier = "django.views.generic.dates.BaseMonthArchiveView"
    or
    spec = "Django::Views::View" and qualifier = "django.views.generic.dates.BaseWeekArchiveView"
    or
    spec = "Django::Views::View" and qualifier = "django.views.generic.dates.BaseDayArchiveView"
    or
    spec = "Django::Views::View" and qualifier = "django.views.generic.dates.BaseTodayArchiveView"
    or
    spec = "Django::Views::View" and qualifier = "django.views.generic.dates.BaseDateDetailView"
    or
    spec = "Django::Views::View" and qualifier = "django.views.generic.detail.BaseDetailView"
    or
    spec = "Django::Views::View" and qualifier = "django.views.generic.edit.ProcessFormView"
    or
    spec = "Django::Views::View" and qualifier = "django.views.generic.edit.BaseFormView"
    or
    spec = "Django::Views::View" and qualifier = "django.views.generic.edit.BaseCreateView"
    or
    spec = "Django::Views::View" and qualifier = "django.views.generic.edit.BaseUpdateView"
    or
    spec = "Django::Views::View" and qualifier = "django.views.generic.edit.BaseDeleteView"
    or
    spec = "Django::Views::View" and qualifier = "django.views.i18n.JavaScriptCatalog"
    or
    spec = "Django::Views::View" and qualifier = "django.views.i18n.JSONCatalog"
    or
    spec = "Django::Views::View" and qualifier = "django.views.generic.list.BaseListView"
    or
    spec = "Django::Views::View" and qualifier = "django.contrib.auth.views.LoginView"
    or
    spec = "Django::Views::View" and qualifier = "django.contrib.auth.views.LogoutView"
    or
    spec = "Django::Views::View" and qualifier = "django.contrib.auth.views.PasswordResetView"
    or
    spec = "Django::Views::View" and qualifier = "django.contrib.auth.views.PasswordResetDoneView"
    or
    spec = "Django::Views::View" and
    qualifier = "django.contrib.auth.views.PasswordResetConfirmView"
    or
    spec = "Django::Views::View" and
    qualifier = "django.contrib.auth.views.PasswordResetCompleteView"
    or
    spec = "Django::Views::View" and qualifier = "django.contrib.auth.views.PasswordChangeView"
    or
    spec = "Django::Views::View" and qualifier = "django.contrib.auth.views.PasswordChangeDoneView"
    or
    spec = "Django::Views::View" and qualifier = "django.contrib.admindocs.views.BookmarkletsView"
    or
    spec = "Django::Views::View" and
    qualifier = "django.contrib.admindocs.views.TemplateTagIndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "django.contrib.admindocs.views.TemplateFilterIndexView"
    or
    spec = "Django::Views::View" and qualifier = "django.contrib.admindocs.views.ViewIndexView"
    or
    spec = "Django::Views::View" and qualifier = "django.contrib.admindocs.views.ViewDetailView"
    or
    spec = "Django::Views::View" and qualifier = "django.contrib.admindocs.views.ModelIndexView"
    or
    spec = "Django::Views::View" and qualifier = "django.contrib.admindocs.views.ModelDetailView"
    or
    spec = "Django::Views::View" and qualifier = "django.contrib.admindocs.views.TemplateDetailView"
    or
    spec = "Django::Forms::Field" and
    qualifier = "django.contrib.postgres.forms.array.SimpleArrayField"
    or
    spec = "Django::Forms::Field" and
    qualifier = "django.contrib.postgres.forms.array.SplitArrayField"
    or
    spec = "Django::Forms::Field" and qualifier = "django.contrib.gis.forms.fields.GeometryField"
    or
    spec = "Django::Forms::Field" and
    qualifier = "django.contrib.gis.forms.fields.GeometryCollectionField"
    or
    spec = "Django::Forms::Field" and qualifier = "django.contrib.gis.forms.fields.PointField"
    or
    spec = "Django::Forms::Field" and qualifier = "django.contrib.gis.forms.fields.MultiPointField"
    or
    spec = "Django::Forms::Field" and qualifier = "django.contrib.gis.forms.fields.LineStringField"
    or
    spec = "Django::Forms::Field" and
    qualifier = "django.contrib.gis.forms.fields.MultiLineStringField"
    or
    spec = "Django::Forms::Field" and qualifier = "django.contrib.gis.forms.fields.PolygonField"
    or
    spec = "Django::Forms::Field" and
    qualifier = "django.contrib.gis.forms.fields.MultiPolygonField"
    or
    spec = "Django::Forms::Field" and qualifier = "django.contrib.auth.forms.UsernameField"
    or
    spec = "Django::Forms::Field" and qualifier = "django.contrib.postgres.forms.hstore.HStoreField"
    or
    spec = "Django::Forms::Field" and qualifier = "django.forms.models.InlineForeignKeyField"
    or
    spec = "Django::Forms::Field" and qualifier = "django.forms.models.ModelChoiceField"
    or
    spec = "Django::Forms::Field" and qualifier = "django.forms.models.ModelMultipleChoiceField"
    or
    spec = "Django::Forms::Field" and
    qualifier = "django.contrib.postgres.forms.ranges.BaseRangeField"
    or
    spec = "Django::Forms::Field" and
    qualifier = "django.contrib.postgres.forms.ranges.IntegerRangeField"
    or
    spec = "Django::Forms::Field" and
    qualifier = "django.contrib.postgres.forms.ranges.DecimalRangeField"
    or
    spec = "Django::Forms::Field" and
    qualifier = "django.contrib.postgres.forms.ranges.DateRangeField"
  )
  or
  // from `horizon` PyPI package analyzed on 2021-03-29
  // see https://github.com/openstack/horizon/blob/master/setup.cfg#L32-L34
  (
    spec = "Django::Forms::Form" and qualifier = "horizon.workflows.base.Action"
    or
    spec = "Django::Forms::Form" and qualifier = "horizon.workflows.base.MembershipAction"
    or
    spec = "Django::Forms::Form" and qualifier = "horizon.forms.base.SelfHandlingForm"
    or
    spec = "Django::Forms::Form" and qualifier = "horizon.forms.base.DateForm"
    or
    spec = "Django::Forms::Form" and
    qualifier =
      "openstack_dashboard.dashboards.project.instances.workflows.create_instance.SelectProjectUserAction"
    or
    spec = "Django::Forms::Form" and
    qualifier =
      "openstack_dashboard.dashboards.project.instances.workflows.create_instance.SetInstanceDetailsAction"
    or
    spec = "Django::Forms::Form" and
    qualifier =
      "openstack_dashboard.dashboards.project.instances.workflows.create_instance.SetAccessControlsAction"
    or
    spec = "Django::Forms::Form" and
    qualifier =
      "openstack_dashboard.dashboards.project.instances.workflows.create_instance.CustomizeAction"
    or
    spec = "Django::Forms::Form" and
    qualifier =
      "openstack_dashboard.dashboards.project.instances.workflows.create_instance.SetNetworkAction"
    or
    spec = "Django::Forms::Form" and
    qualifier =
      "openstack_dashboard.dashboards.project.instances.workflows.create_instance.SetNetworkPortsAction"
    or
    spec = "Django::Forms::Form" and
    qualifier =
      "openstack_dashboard.dashboards.project.instances.workflows.create_instance.SetAdvancedAction"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.floating_ips.forms.FloatingIpAllocate"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.api_access.forms.RecreateCredentials"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.images.images.forms.CreateParent"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.images.images.forms.CreateImageForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.identity.groups.forms.CreateGroupForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.identity.groups.forms.UpdateGroupForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.identity.users.forms.PasswordMixin"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.identity.users.forms.BaseUserForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.identity.users.forms.CreateUserForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.images.images.forms.UpdateImageForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.identity.users.forms.UpdateUserForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.identity.users.forms.ChangePasswordForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.security_groups.forms.GroupBase"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.security_groups.forms.CreateGroup"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.security_groups.forms.UpdateGroup"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.security_groups.forms.AddRule"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.volume_groups.forms.RemoveVolsForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.volume_groups.forms.DeleteForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.snapshots.forms.UpdateStatus"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.routers.forms.CreateForm"
    or
    spec = "Django::Forms::Form" and
    qualifier =
      "openstack_dashboard.dashboards.identity.application_credentials.forms.CreateApplicationCredentialForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.routers.forms.UpdateForm"
    or
    spec = "Django::Forms::Form" and
    qualifier =
      "openstack_dashboard.dashboards.identity.application_credentials.forms.CreateSuccessfulForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.volume_types.forms.CreateVolumeType"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.volume_types.forms.CreateQosSpec"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.volume_types.forms.CreateVolumeTypeEncryption"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.volume_types.forms.UpdateVolumeTypeEncryption"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.volume_types.forms.ManageQosSpecAssociation"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.volume_types.forms.EditQosSpecConsumer"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.volume_types.forms.EditVolumeType"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.volume_types.forms.EditTypeAccessForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.identity.roles.forms.CreateRoleForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.aggregates.forms.UpdateAggregateForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.identity.roles.forms.UpdateRoleForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.group_types.specs.forms.CreateSpec"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.group_types.forms.CreateGroupType"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.group_types.specs.forms.EditSpec"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.group_types.forms.EditGroupType"
    or
    spec = "Django::Forms::Form" and
    qualifier =
      "openstack_dashboard.dashboards.admin.networks.ports.extensions.allowed_address_pairs.forms.AddAllowedAddressPairForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.volume_types.extras.forms.CreateExtraSpec"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.metadata_defs.forms.CreateNamespaceForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.volume_types.extras.forms.EditExtraSpec"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.metadata_defs.forms.ManageResourceTypesForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.metadata_defs.forms.UpdateNamespaceForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.instances.forms.RebuildInstanceForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.instances.forms.DecryptPasswordInstanceForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.instances.forms.AttachVolume"
    or
    spec = "Django::Forms::Form" and
    qualifier =
      "openstack_dashboard.dashboards.identity.identity_providers.protocols.forms.AddProtocolForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.instances.forms.DetachVolume"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.instances.forms.AttachInterface"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.instances.forms.DetachInterface"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.hypervisors.compute.forms.EvacuateHostForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.instances.forms.Disassociate"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.hypervisors.compute.forms.DisableServiceForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.hypervisors.compute.forms.MigrateHostForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.instances.forms.RescueInstanceForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.backups.forms.UpdateStatus"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.backups.forms.AdminRestoreBackupForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.networks.agents.forms.AddDHCPAgent"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.backups.forms.CreateBackupForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.backups.forms.RestoreBackupForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.network_topology.forms.NTCreateRouterForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.volumes.forms.CreateForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.routers.forms.CreateForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.routers.forms.UpdateForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.identity.mappings.forms.CreateMappingForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.identity.mappings.forms.UpdateMappingForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.identity.identity_providers.forms.RegisterIdPForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.identity.identity_providers.forms.UpdateIdPForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.volumes.forms.AttachForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.volumes.forms.CreateSnapshotForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.volume_groups.forms.UpdateForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.volume_groups.forms.RemoveVolsForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.volumes.forms.CreateTransferForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.volume_groups.forms.DeleteForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.volumes.forms.AcceptTransferForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.volume_groups.forms.CreateSnapshotForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.volumes.forms.ShowTransferForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.volumes.forms.UpdateForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.volume_groups.forms.CloneGroupForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.volumes.forms.UploadToImageForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.volumes.forms.ExtendForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.volumes.forms.RetypeForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.key_pairs.forms.ImportKeypair"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.settings.user.forms.UserSettingsForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.settings.password.forms.PasswordForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.floating_ips.forms.AdminFloatingIpAllocate"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.instances.forms.LiveMigrateForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.instances.forms.RescueInstanceForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.rbac_policies.forms.CreatePolicyForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.rbac_policies.forms.UpdatePolicyForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.networks.forms.CreateNetwork"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.snapshots.forms.UpdateForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.networks.forms.UpdateNetwork"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.networks.forms.UpdateNetwork"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.vg_snapshots.forms.CreateGroupForm"
    or
    spec = "Django::Forms::Form" and
    qualifier =
      "openstack_dashboard.dashboards.project.networks.ports.extensions.allowed_address_pairs.forms.AddAllowedAddressPairForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.images.forms.AdminCreateImageForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.images.forms.AdminUpdateImageForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.volumes.forms.ManageVolume"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.volumes.forms.UnmanageVolume"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.volumes.forms.MigrateVolume"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.volumes.forms.UpdateStatus"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.images.snapshots.forms.CreateSnapshot"
    or
    spec = "Django::Forms::Form" and qualifier = "openstack_auth.forms.Login"
    or
    spec = "Django::Forms::Form" and qualifier = "openstack_auth.forms.Password"
    or
    spec = "Django::Forms::Form" and
    qualifier =
      "openstack_dashboard.dashboards.project.routers.extensions.extraroutes.forms.AddRouterRoute"
    or
    spec = "Django::Forms::Form" and
    qualifier =
      "openstack_dashboard.dashboards.admin.volume_types.qos_specs.forms.CreateKeyValuePair"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.volume_types.qos_specs.forms.EditKeyValuePair"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.routers.ports.forms.AddInterface"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.routers.ports.forms.SetGatewayForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.api.rest.glance.UploadObjectForm"
    or
    spec = "Django::Forms::Form" and
    qualifier =
      "openstack_dashboard.dashboards.project.instances.workflows.resize_instance.SetFlavorChoiceAction"
    or
    spec = "Django::Forms::Form" and
    qualifier =
      "openstack_dashboard.dashboards.project.networks.ports.sg_base.BaseSecurityGroupsAction"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.api.rest.swift.UploadObjectForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "horizon.test.unit.forms.test_fields.ChoiceFieldForm"
    or
    spec = "Django::Forms::Form" and
    qualifier = "horizon.test.unit.forms.test_fields.ThemableChoiceFieldForm"
    or
    spec = "Django::Forms::Form" and qualifier = "horizon.test.unit.forms.test_forms.FormForTesting"
    or
    spec = "Django::Forms::Form" and
    qualifier = "horizon.test.unit.workflows.test_workflows.ActionOne"
    or
    spec = "Django::Forms::Form" and
    qualifier = "horizon.test.unit.workflows.test_workflows.ActionTwo"
    or
    spec = "Django::Forms::Form" and
    qualifier = "horizon.test.unit.workflows.test_workflows.ActionThree"
    or
    spec = "Django::Forms::Form" and
    qualifier = "horizon.test.unit.workflows.test_workflows.ActionFour"
    or
    spec = "Django::Forms::Form" and
    qualifier = "horizon.test.unit.workflows.test_workflows.AdminAction"
    or
    spec = "Django::Forms::Form" and
    qualifier = "horizon.test.unit.workflows.test_workflows.DisabledAction"
    or
    spec = "Django::Forms::Form" and
    qualifier = "horizon.test.unit.workflows.test_workflows.AdminForbiddenAction"
    or
    spec = "Django::Forms::Form" and
    qualifier =
      "openstack_dashboard.dashboards.project.instances.workflows.update_instance.UpdateInstanceSecurityGroupsAction"
    or
    spec = "Django::Forms::Form" and
    qualifier =
      "openstack_dashboard.dashboards.project.instances.workflows.update_instance.UpdateInstanceInfoAction"
    or
    spec = "Django::Forms::Form" and
    qualifier =
      "openstack_dashboard.dashboards.admin.defaults.workflows.UpdateDefaultComputeQuotasAction"
    or
    spec = "Django::Forms::Form" and
    qualifier =
      "openstack_dashboard.dashboards.admin.defaults.workflows.UpdateDefaultVolumeQuotasAction"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.networks.ports.workflows.CreatePortInfoAction"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.networks.ports.workflows.UpdatePortInfoAction"
    or
    spec = "Django::Forms::Form" and
    qualifier =
      "openstack_dashboard.dashboards.project.networks.ports.workflows.CreatePortSecurityGroupAction"
    or
    spec = "Django::Forms::Form" and
    qualifier =
      "openstack_dashboard.dashboards.project.networks.ports.workflows.CreatePortInfoAction"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.identity.domains.workflows.CreateDomainInfoAction"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.identity.domains.workflows.UpdateDomainUsersAction"
    or
    spec = "Django::Forms::Form" and
    qualifier =
      "openstack_dashboard.dashboards.project.networks.ports.workflows.UpdatePortInfoAction"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.identity.domains.workflows.UpdateDomainGroupsAction"
    or
    spec = "Django::Forms::Form" and
    qualifier =
      "openstack_dashboard.dashboards.project.networks.ports.workflows.UpdatePortSecurityGroupAction"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.identity.domains.workflows.UpdateDomainInfoAction"
    or
    spec = "Django::Forms::Form" and
    qualifier =
      "openstack_dashboard.dashboards.project.networks.subnets.workflows.CreateSubnetInfoAction"
    or
    spec = "Django::Forms::Form" and
    qualifier =
      "openstack_dashboard.dashboards.project.networks.subnets.workflows.UpdateSubnetInfoAction"
    or
    spec = "Django::Forms::Form" and
    qualifier =
      "openstack_dashboard.dashboards.project.networks.subnets.workflows.UpdateSubnetDetailAction"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.networks.workflows.CreateNetworkInfoAction"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.networks.workflows.CreateSubnetInfoAction"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.networks.workflows.CreateSubnetDetailAction"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.volume_groups.workflows.AddGroupInfoAction"
    or
    spec = "Django::Forms::Form" and
    qualifier =
      "openstack_dashboard.dashboards.project.volume_groups.workflows.AddVolumeTypesToGroupAction"
    or
    spec = "Django::Forms::Form" and
    qualifier =
      "openstack_dashboard.dashboards.project.volume_groups.workflows.AddVolumesToGroupAction"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.project.floating_ips.workflows.AssociateIPAction"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.identity.projects.workflows.CommonQuotaAction"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.aggregates.workflows.SetAggregateInfoAction"
    or
    spec = "Django::Forms::Form" and
    qualifier =
      "openstack_dashboard.dashboards.admin.aggregates.workflows.AddHostsToAggregateAction"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.identity.projects.workflows.ComputeQuotaAction"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.identity.projects.workflows.VolumeQuotaAction"
    or
    spec = "Django::Forms::Form" and
    qualifier =
      "openstack_dashboard.dashboards.admin.aggregates.workflows.ManageAggregateHostsAction"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.identity.projects.workflows.NetworkQuotaAction"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.identity.projects.workflows.CreateProjectInfoAction"
    or
    spec = "Django::Forms::Form" and
    qualifier =
      "openstack_dashboard.dashboards.identity.projects.workflows.UpdateProjectMembersAction"
    or
    spec = "Django::Forms::Form" and
    qualifier =
      "openstack_dashboard.dashboards.identity.projects.workflows.UpdateProjectGroupsAction"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.identity.projects.workflows.UpdateProjectInfoAction"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.networks.workflows.CreateNetworkInfoAction"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.flavors.workflows.CreateFlavorInfoAction"
    or
    spec = "Django::Forms::Form" and
    qualifier = "openstack_dashboard.dashboards.admin.flavors.workflows.FlavorAccessAction"
    or
    spec = "Django::Forms::Form" and
    qualifier =
      "openstack_dashboard.dashboards.admin.networks.subnets.workflows.CreateSubnetInfoAction"
    or
    spec = "Django::Forms::Form" and
    qualifier =
      "openstack_dashboard.dashboards.admin.networks.subnets.workflows.UpdateSubnetInfoAction"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.test.test_panels.plugin_panel.views.TestBannerView"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.cinder.Volumes"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.cinder.Volume"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.cinder.VolumeTypes"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.api.rest.cinder.VolumeMetadata"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.cinder.VolumeType"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.api.rest.cinder.VolumeSnapshots"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.api.rest.cinder.VolumeSnapshotMetadata"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.api.rest.cinder.VolumeTypeMetadata"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.cinder.Extensions"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.cinder.QoSSpecs"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.api.rest.cinder.TenantAbsoluteLimits"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.cinder.Services"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.api.rest.cinder.DefaultQuotaSets"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.cinder.QuotaSets"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.api.rest.cinder.AvailabilityZones"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.config.Settings"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.config.Timezones"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.glance.Version"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.glance.Image"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.api.rest.glance.ImageProperties"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.glance.Images"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.api.rest.glance.MetadefsNamespaces"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.api.rest.glance.MetadefsResourceTypesList"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.keystone.Version"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.keystone.Users"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.keystone.User"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.keystone.Roles"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.keystone.Role"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.api.rest.keystone.DefaultDomain"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.keystone.Domains"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.keystone.Domain"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.keystone.Projects"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.keystone.Project"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.keystone.ProjectRole"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.api.rest.keystone.ServiceCatalog"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.keystone.UserSession"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.keystone.Services"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.keystone.Groups"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.keystone.Group"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.api.rest.network.SecurityGroups"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.network.FloatingIP"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.network.FloatingIPs"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.api.rest.network.FloatingIPPools"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.neutron.Networks"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.neutron.Subnets"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.neutron.Ports"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.neutron.Trunk"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.neutron.Trunks"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.neutron.Services"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.neutron.Extensions"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.api.rest.neutron.DefaultQuotaSets"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.neutron.QuotasSets"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.neutron.QoSPolicies"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.neutron.QoSPolicy"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.nova.Snapshots"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.nova.Features"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.nova.Keypairs"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.nova.Keypair"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.nova.Services"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.api.rest.nova.AvailabilityZones"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.nova.Limits"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.nova.ServerActions"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.nova.SecurityGroups"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.nova.Volumes"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.api.rest.nova.RemoteConsoleInfo"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.nova.ConsoleOutput"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.nova.Servers"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.nova.Server"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.nova.ServerGroups"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.nova.ServerGroup"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.nova.ServerMetadata"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.nova.Flavors"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.nova.Flavor"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.api.rest.nova.FlavorExtraSpecs"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.api.rest.nova.AggregateExtraSpecs"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.api.rest.nova.DefaultQuotaSets"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.api.rest.nova.EditableQuotaSets"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.nova.QuotaSets"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.policy.Policy"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.swift.Info"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.swift.Policies"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.swift.Containers"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.swift.Container"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.swift.Objects"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.swift.Object"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.swift.ObjectMetadata"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.api.rest.swift.ObjectCopy"
    or
    spec = "Django::Views::View" and qualifier = "horizon.test.unit.tabs.test_tabs.TabWithTableView"
    or
    spec = "Django::Views::View" and
    qualifier = "horizon.test.unit.tables.test_tables.SingleTableView"
    or
    spec = "Django::Views::View" and
    qualifier = "horizon.test.unit.tables.test_tables.APIFilterTableView"
    or
    spec = "Django::Views::View" and
    qualifier = "horizon.test.unit.tables.test_tables.SingleTableViewWithPermissions"
    or
    spec = "Django::Views::View" and
    qualifier = "horizon.test.unit.tables.test_tables.MultiTableView"
    or
    spec = "Django::Views::View" and qualifier = "horizon.test.unit.test_views.PageWithNoTitle"
    or
    spec = "Django::Views::View" and qualifier = "horizon.test.unit.test_views.PageWithTitle"
    or
    spec = "Django::Views::View" and qualifier = "horizon.test.unit.test_views.PageWithTitleData"
    or
    spec = "Django::Views::View" and qualifier = "horizon.test.unit.test_views.FormWithTitle"
    or
    spec = "Django::Views::View" and qualifier = "horizon.test.unit.test_views.ViewWithTitle"
    or
    spec = "Django::Views::View" and qualifier = "horizon.test.unit.test_views.ViewWithTransTitle"
    or
    spec = "Django::Views::View" and
    qualifier = "horizon.test.unit.workflows.test_workflows.WorkflowViewForTesting"
    or
    spec = "Django::Views::View" and
    qualifier = "horizon.test.unit.workflows.test_workflows.FullscreenWorkflowView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.images.images.views.CreateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.images.images.views.UpdateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.images.images.views.DetailView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.network_topology.views.NTAddInterfaceView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.network_topology.views.NTCreateRouterView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.network_topology.views.NTCreateNetworkView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.network_topology.views.NTLaunchInstanceView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.network_topology.views.NTCreateSubnetView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.network_topology.views.InstanceView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.network_topology.views.RouterView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.network_topology.views.NetworkView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.network_topology.views.RouterDetailView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.network_topology.views.NetworkDetailView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.network_topology.views.NetworkTopologyView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.network_topology.views.JSONView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.containers.views.NgIndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.volumes.views.VolumesView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.volumes.views.DetailView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.volumes.views.ManageVolumeView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.volumes.views.UnmanageVolumeView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.volumes.views.MigrateVolumeView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.volumes.views.UpdateStatusView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.rbac_policies.views.IndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.rbac_policies.views.CreateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.rbac_policies.views.UpdateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.rbac_policies.views.DetailView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.identity.identity_providers.views.IndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.identity.identity_providers.views.DetailView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.identity.identity_providers.views.UpdateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.identity.identity_providers.views.RegisterView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.snapshots.views.SnapshotsView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.snapshots.views.UpdateStatusView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.snapshots.views.DetailView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.routers.ports.views.DetailView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.backups.views.BackupsView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.backups.views.CreateBackupView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.backups.views.BackupDetailView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.backups.views.RestoreBackupView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.identity.projects.views.IndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.identity.projects.views.ProjectUsageView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.identity.projects.views.CreateProjectView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.identity.projects.views.UpdateProjectView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.identity.projects.views.UpdateQuotasView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.identity.projects.views.DetailProjectView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.contrib.developer.theme_preview.views.IndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.volumes.views.VolumesView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.volumes.views.DetailView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.volumes.views.CreateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.volumes.views.ExtendView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.volumes.views.CreateSnapshotView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.volumes.views.UploadToImageView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.volumes.views.CreateTransferView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.volumes.views.AcceptTransferView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.volumes.views.ShowTransferView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.volumes.views.UpdateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.volumes.views.EditAttachmentsView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.volumes.views.RetypeView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.volumes.views.EncryptionDetailView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.volumes.views.DownloadTransferCreds"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.test.test_panels.another_panel.views.IndexView"
    or
    spec = "Django::Views::View" and qualifier = "horizon.tables.views.MultiTableView"
    or
    spec = "Django::Views::View" and qualifier = "horizon.tables.views.DataTableView"
    or
    spec = "Django::Views::View" and qualifier = "horizon.tables.views.MixedDataTableView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.volume_groups.views.IndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.volume_groups.views.RemoveVolumesView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.volume_groups.views.DeleteView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.volume_groups.views.ManageView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.volume_groups.views.DetailView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.flavors.views.IndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.flavors.views.CreateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.flavors.views.UpdateView"
    or
    spec = "Django::Views::View" and qualifier = "horizon.conf.panel_template.views.IndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.test.test_panels.second_panel.views.IndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.identity.roles.views.IndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.identity.roles.views.UpdateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.identity.roles.views.CreateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.networks.views.IndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.networks.views.CreateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.networks.views.UpdateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.networks.views.DetailView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.floating_ips.views.IndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.floating_ips.views.DetailView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.floating_ips.views.AllocateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.routers.views.IndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.routers.views.DetailView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.routers.views.CreateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.routers.views.UpdateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.volume_types.qos_specs.views.IndexView"
    or
    spec = "Django::Views::View" and
    qualifier =
      "openstack_dashboard.dashboards.admin.volume_types.qos_specs.views.CreateKeyValuePairView"
    or
    spec = "Django::Views::View" and
    qualifier =
      "openstack_dashboard.dashboards.admin.volume_types.qos_specs.views.EditKeyValuePairView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.routers.views.IndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.routers.views.DetailView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.routers.views.CreateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.routers.views.UpdateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.routers.views.L3AgentView"
    or
    spec = "Django::Views::View" and
    qualifier = "horizon.test.test_dashboards.cats.tigers.views.IndexView"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.views.ExtensibleHeaderView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.security_groups.views.DetailView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.security_groups.views.UpdateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.security_groups.views.AddRuleView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.security_groups.views.CreateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.security_groups.views.IndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.overview.views.GlobalOverview"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.api_access.views.CredentialsView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.api_access.views.RecreateCredentialsView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.api_access.views.IndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.hypervisors.compute.views.EvacuateHostView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.hypervisors.compute.views.DisableServiceView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.hypervisors.compute.views.MigrateHostView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.aggregates.views.IndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.aggregates.views.CreateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.aggregates.views.UpdateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.aggregates.views.ManageHostsView"
    or
    spec = "Django::Views::View" and
    qualifier =
      "openstack_dashboard.dashboards.identity.identity_providers.protocols.views.AddProtocolView"
    or
    spec = "Django::Views::View" and
    qualifier =
      "openstack_dashboard.dashboards.project.networks.ports.extensions.allowed_address_pairs.views.AddAllowedAddressPair"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.identity.mappings.views.IndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.identity.mappings.views.UpdateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.identity.mappings.views.CreateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.key_pairs.views.IndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.key_pairs.views.ImportView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.key_pairs.views.DetailView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.images.snapshots.views.CreateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.group_types.views.GroupTypesView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.group_types.views.CreateGroupTypeView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.group_types.views.EditGroupTypeView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.test.test_panels.plugin_panel.views.IndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.settings.user.views.UserSettingsView"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.usage.views.UsageView"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.usage.views.ProjectUsageView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.volume_types.views.VolumeTypesView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.volume_types.views.CreateVolumeTypeView"
    or
    spec = "Django::Views::View" and
    qualifier =
      "openstack_dashboard.dashboards.admin.volume_types.views.VolumeTypeEncryptionDetailView"
    or
    spec = "Django::Views::View" and
    qualifier =
      "openstack_dashboard.dashboards.admin.volume_types.views.CreateVolumeTypeEncryptionView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.volume_types.views.EditVolumeTypeView"
    or
    spec = "Django::Views::View" and
    qualifier =
      "openstack_dashboard.dashboards.admin.volume_types.views.UpdateVolumeTypeEncryptionView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.volume_types.views.CreateQosSpecView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.volume_types.views.EditQosSpecConsumerView"
    or
    spec = "Django::Views::View" and
    qualifier =
      "openstack_dashboard.dashboards.admin.volume_types.views.ManageQosSpecAssociationView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.volume_types.views.EditAccessView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.identity.application_credentials.views.IndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.identity.application_credentials.views.CreateView"
    or
    spec = "Django::Views::View" and
    qualifier =
      "openstack_dashboard.dashboards.identity.application_credentials.views.CreateSuccessfulView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.identity.application_credentials.views.DetailView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.contrib.developer.profiler.views.IndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.contrib.developer.profiler.views.Traces"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.contrib.developer.profiler.views.Trace"
    or
    spec = "Django::Views::View" and
    qualifier = "horizon.test.test_dashboards.cats.kittens.views.IndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.volume_groups.views.IndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.volume_groups.views.CreateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.volume_groups.views.UpdateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.volume_groups.views.RemoveVolumesView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.volume_groups.views.DeleteView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.volume_groups.views.ManageView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.volume_groups.views.CreateSnapshotView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.volume_groups.views.CloneGroupView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.volume_groups.views.DetailView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.backups.views.AdminBackupsView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.backups.views.UpdateStatusView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.backups.views.AdminBackupDetailView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.backups.views.AdminRestoreBackupView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.images.views.IndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.test.test_panels.nonloading_panel.views.IndexView"
    or
    spec = "Django::Views::View" and qualifier = "horizon.views.HorizonTemplateView"
    or
    spec = "Django::Views::View" and qualifier = "horizon.views.HorizonFormView"
    or
    spec = "Django::Views::View" and qualifier = "horizon.views.APIView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.images.views.CreateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.images.views.UpdateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.images.views.DetailView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.group_types.specs.views.IndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.group_types.specs.views.CreateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.group_types.specs.views.EditView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.identity.domains.views.IndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.hypervisors.views.AdminIndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.hypervisors.views.AdminDetailView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.identity.domains.views.CreateDomainView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.identity.domains.views.UpdateDomainView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.contrib.developer.form_builder.views.IndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "horizon.test.test_dashboards.dogs.puppies.views.IndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "horizon.test.test_dashboards.dogs.puppies.views.TwoTabsView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.networks.agents.views.AddView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.identity.users.views.IndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.identity.users.views.UpdateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.identity.users.views.CreateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.identity.users.views.DetailView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.identity.users.views.ChangePasswordView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.snapshots.views.SnapshotsView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.snapshots.views.UpdateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.snapshots.views.DetailView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.overview.views.ProjectOverview"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.overview.views.WarningView"
    or
    spec = "Django::Views::View" and
    qualifier =
      "openstack_dashboard.dashboards.project.routers.extensions.extraroutes.views.AddRouterRouteView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.vg_snapshots.views.IndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.vg_snapshots.views.DetailView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.vg_snapshots.views.CreateGroupView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.floating_ips.views.AssociateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.floating_ips.views.AllocateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.floating_ips.views.IndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.ngflavors.views.IndexView"
    or
    spec = "Django::Views::View" and
    qualifier =
      "openstack_dashboard.dashboards.admin.networks.ports.extensions.allowed_address_pairs.views.AddAllowedAddressPair"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.identity.groups.views.IndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.identity.groups.views.CreateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.identity.groups.views.UpdateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.identity.groups.views.ManageMembersView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.identity.groups.views.NonMembersView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.instances.views.IndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.volume_types.extras.views.IndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.volume_types.extras.views.CreateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.instances.views.LaunchInstanceView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.volume_types.extras.views.EditView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.instances.views.SerialConsoleView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.instances.views.UpdateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.networks.ports.views.CreateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.networks.ports.views.DetailView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.instances.views.RebuildView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.instances.views.DecryptPasswordView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.networks.ports.views.UpdateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.instances.views.DisassociateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.instances.views.DetailView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.instances.views.ResizeView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.instances.views.AttachInterfaceView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.info.views.IndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.instances.views.AttachVolumeView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.settings.password.views.PasswordView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.instances.views.DetachVolumeView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.defaults.views.IndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.defaults.views.UpdateDefaultQuotasView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.instances.views.DetachInterfaceView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.instances.views.UpdatePortView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.vg_snapshots.views.IndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.instances.views.RescueView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.vg_snapshots.views.DetailView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.networks.ports.views.CreateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.networks.ports.views.DetailView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.networks.ports.views.UpdateView"
    or
    spec = "Django::Views::View" and qualifier = "horizon.tabs.views.TabView"
    or
    spec = "Django::Views::View" and qualifier = "horizon.tabs.views.TabbedTableView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.routers.ports.views.AddInterfaceView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.routers.ports.views.SetGatewayView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.routers.ports.views.DetailView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.networks.subnets.views.CreateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.networks.subnets.views.UpdateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.networks.subnets.views.DetailView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.networks.subnets.views.CreateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.networks.subnets.views.UpdateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.networks.subnets.views.DetailView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.instances.views.AdminUpdateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.instances.views.AdminIndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.instances.views.LiveMigrateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.instances.views.DetailView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.instances.views.RescueView"
    or
    spec = "Django::Views::View" and qualifier = "horizon.workflows.views.WorkflowView"
    or
    spec = "Django::Views::View" and qualifier = "openstack_auth.views.PasswordView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.images.views.IndexView"
    or
    spec = "Django::Views::View" and qualifier = "horizon.browsers.views.ResourceBrowserView"
    or
    spec = "Django::Views::View" and qualifier = "horizon.browsers.views.AngularIndexView"
    or
    spec = "Django::Views::View" and qualifier = "horizon.browsers.views.AngularDetailsView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.metadata_defs.views.AdminIndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.metadata_defs.views.CreateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.metadata_defs.views.UpdateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.metadata_defs.views.DetailView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.metadata_defs.views.ManageResourceTypes"
    or
    spec = "Django::Views::View" and qualifier = "horizon.forms.views.ModalFormView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.networks.views.IndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.networks.views.CreateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.networks.views.UpdateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.networks.views.DetailView"
    or
    spec = "Django::Forms::Field" and qualifier = "horizon.forms.fields.IPField"
    or
    spec = "Django::Forms::Field" and qualifier = "horizon.forms.fields.MultiIPField"
    or
    spec = "Django::Forms::Field" and qualifier = "horizon.forms.fields.MACAddressField"
    or
    spec = "Django::Forms::Field" and qualifier = "horizon.forms.fields.ThemableChoiceField"
    or
    spec = "Django::Forms::Field" and qualifier = "horizon.forms.fields.DynamicChoiceField"
    or
    spec = "Django::Forms::Field" and qualifier = "horizon.forms.fields.ThemableDynamicChoiceField"
    or
    spec = "Django::Forms::Field" and qualifier = "horizon.forms.fields.DynamicTypedChoiceField"
    or
    spec = "Django::Forms::Field" and
    qualifier = "horizon.forms.fields.ThemableDynamicTypedChoiceField"
    or
    spec = "Django::Forms::Field" and qualifier = "horizon.forms.fields.ExternalFileField"
    or
    spec = "Django::Forms::Field" and qualifier = "horizon.forms.DynamicChoiceField"
    or
    spec = "Django::Forms::Field" and qualifier = "horizon.forms.DynamicTypedChoiceField"
    or
    spec = "Django::Forms::Field" and qualifier = "horizon.forms.ExternalFileField"
    or
    spec = "Django::Forms::Field" and qualifier = "horizon.forms.IPField"
    or
    spec = "Django::Forms::Field" and qualifier = "horizon.forms.MACAddressField"
    or
    spec = "Django::Forms::Field" and qualifier = "horizon.forms.MultiIPField"
    or
    spec = "Django::Forms::Field" and qualifier = "horizon.forms.ThemableChoiceField"
    or
    spec = "Django::Forms::Field" and qualifier = "horizon.forms.ThemableDynamicChoiceField"
    or
    spec = "Django::Forms::Field" and qualifier = "horizon.forms.ThemableDynamicTypedChoiceField"
    or
    spec = "Django::Forms::Field" and qualifier = "horizon.forms.Field"
    or
    spec = "Django::Forms::Field" and qualifier = "horizon.forms.FileField"
    or
    spec = "Django::Forms::Field" and qualifier = "horizon.forms.BooleanField"
    or
    spec = "Django::Forms::Field" and qualifier = "horizon.forms.IntegerField"
    or
    spec = "Django::Forms::Field" and qualifier = "horizon.forms.ChoiceField"
    or
    spec = "Django::Forms::Field" and qualifier = "horizon.forms.CharField"
    or
    spec = "Django::Forms::Form" and qualifier = "horizon.workflows.Action"
    or
    spec = "Django::Forms::Form" and qualifier = "horizon.workflows.MembershipAction"
    or
    spec = "Django::Forms::Form" and qualifier = "horizon.forms.DateForm"
    or
    spec = "Django::Forms::Form" and qualifier = "horizon.forms.SelfHandlingForm"
    or
    spec = "Django::Forms::Form" and qualifier = "openstack_auth.views.Login"
    or
    spec = "Django::Forms::Form" and qualifier = "horizon.forms.BaseForm"
    or
    spec = "Django::Views::View" and qualifier = "horizon.workflows.WorkflowView"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.usage.ProjectUsageView"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.usage.UsageView"
    or
    spec = "Django::Views::View" and qualifier = "horizon.tabs.TabbedTableView"
    or
    spec = "Django::Views::View" and qualifier = "horizon.tabs.TabView"
    or
    spec = "Django::Views::View" and qualifier = "horizon.forms.ModalFormView"
    or
    spec = "Django::Views::View" and qualifier = "horizon.browsers.ResourceBrowserView"
    or
    spec = "Django::Views::View" and qualifier = "horizon.tables.DataTableView"
    or
    spec = "Django::Views::View" and qualifier = "horizon.tables.MixedDataTableView"
    or
    spec = "Django::Views::View" and qualifier = "horizon.tables.MultiTableView"
    or
    spec = "Django::Views::View" and qualifier = "horizon.site_urls.TemplateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.contrib.developer.resource_browser.urls.AngularIndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.images.images.urls.AngularIndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.identity.users.urls.AngularIndexView"
    or
    spec = "Django::Views::View" and qualifier = "horizon.test.urls.TemplateView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.images.urls.AngularIndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "horizon.test.test_dashboards.dogs.puppies.urls.IndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "horizon.test.test_dashboards.dogs.puppies.urls.TwoTabsView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.trunks.urls.AngularIndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "horizon.test.test_dashboards.cats.tigers.urls.IndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.identity.groups.urls.AngularIndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.images.urls.AngularIndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.trunks.urls.AngularIndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "horizon.test.test_dashboards.cats.kittens.urls.IndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.admin.flavors.urls.AngularIndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.identity.roles.urls.AngularIndexView"
    or
    spec = "Django::Views::View" and
    qualifier = "openstack_dashboard.dashboards.project.network_topology.views.View"
    or
    spec = "Django::Views::View" and qualifier = "openstack_dashboard.views.TemplateView"
    or
    spec = "Django::Views::View" and qualifier = "horizon.browsers.views.MultiTableView"
  )
}
