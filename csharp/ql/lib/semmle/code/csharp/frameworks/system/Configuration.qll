/** Provides definitions related to the namespace `System.Configuration`. */

import csharp
private import semmle.code.csharp.dataflow.ExternalFlow

/** Data flow for some collection classes in `System.Configuration.*`. */
private class SystemClearFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Configuration;CommaDelimitedStringCollection;false;Clear;();;Argument[this].WithoutElement;Argument[this];value;manual",
        "System.Configuration;ConfigurationLockCollection;false;Clear;();;Argument[this].WithoutElement;Argument[this];value;manual",
        "System.Configuration;ConfigurationPropertyCollection;false;Clear;();;Argument[this].WithoutElement;Argument[this];value;manual",
        "System.Configuration;ConfigurationSectionCollection;false;Clear;();;Argument[this].WithoutElement;Argument[this];value;manual",
        "System.Configuration;ConfigurationSectionGroupCollection;false;Clear;();;Argument[this].WithoutElement;Argument[this];value;manual",
        "System.Configuration;ConnectionStringSettingsCollection;false;Clear;();;Argument[this].WithoutElement;Argument[this];value;manual",
        "System.Configuration;KeyValueConfigurationCollection;false;Clear;();;Argument[this].WithoutElement;Argument[this];value;manual",
        "System.Configuration;NameValueConfigurationCollection;false;Clear;();;Argument[this].WithoutElement;Argument[this];value;manual",
        "System.Configuration;ProviderSettingsCollection;false;Clear;();;Argument[this].WithoutElement;Argument[this];value;manual",
        "System.Configuration;SettingElementCollection;false;Clear;();;Argument[this].WithoutElement;Argument[this];value;manual",
        "System.Configuration;SettingsPropertyCollection;false;Clear;();;Argument[this].WithoutElement;Argument[this];value;manual",
        "System.Configuration;SettingsPropertyValueCollection;false;Clear;();;Argument[this].WithoutElement;Argument[this];value;manual",
        "System.Configuration.Provider;ProviderCollection;false;Clear;();;Argument[this].WithoutElement;Argument[this];value;manual",
      ]
  }
}
