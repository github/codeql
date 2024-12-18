// This file contains auto-generated code.
// Generated from `Microsoft.Extensions.Diagnostics.Abstractions, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace Extensions
    {
        namespace Diagnostics
        {
            namespace Metrics
            {
                public interface IMetricsBuilder
                {
                    Microsoft.Extensions.DependencyInjection.IServiceCollection Services { get; }
                }
                public interface IMetricsListener
                {
                    Microsoft.Extensions.Diagnostics.Metrics.MeasurementHandlers GetMeasurementHandlers();
                    void Initialize(Microsoft.Extensions.Diagnostics.Metrics.IObservableInstrumentsSource source);
                    bool InstrumentPublished(System.Diagnostics.Metrics.Instrument instrument, out object userState);
                    void MeasurementsCompleted(System.Diagnostics.Metrics.Instrument instrument, object userState);
                    string Name { get; }
                }
                public class InstrumentRule
                {
                    public InstrumentRule(string meterName, string instrumentName, string listenerName, Microsoft.Extensions.Diagnostics.Metrics.MeterScope scopes, bool enable) => throw null;
                    public bool Enable { get => throw null; }
                    public string InstrumentName { get => throw null; }
                    public string ListenerName { get => throw null; }
                    public string MeterName { get => throw null; }
                    public Microsoft.Extensions.Diagnostics.Metrics.MeterScope Scopes { get => throw null; }
                }
                public interface IObservableInstrumentsSource
                {
                    void RecordObservableInstruments();
                }
                public class MeasurementHandlers
                {
                    public System.Diagnostics.Metrics.MeasurementCallback<byte> ByteHandler { get => throw null; set { } }
                    public MeasurementHandlers() => throw null;
                    public System.Diagnostics.Metrics.MeasurementCallback<decimal> DecimalHandler { get => throw null; set { } }
                    public System.Diagnostics.Metrics.MeasurementCallback<double> DoubleHandler { get => throw null; set { } }
                    public System.Diagnostics.Metrics.MeasurementCallback<float> FloatHandler { get => throw null; set { } }
                    public System.Diagnostics.Metrics.MeasurementCallback<int> IntHandler { get => throw null; set { } }
                    public System.Diagnostics.Metrics.MeasurementCallback<long> LongHandler { get => throw null; set { } }
                    public System.Diagnostics.Metrics.MeasurementCallback<short> ShortHandler { get => throw null; set { } }
                }
                [System.Flags]
                public enum MeterScope
                {
                    None = 0,
                    Global = 1,
                    Local = 2,
                }
                public static partial class MetricsBuilderExtensions
                {
                    public static Microsoft.Extensions.Diagnostics.Metrics.IMetricsBuilder AddListener<T>(this Microsoft.Extensions.Diagnostics.Metrics.IMetricsBuilder builder) where T : class, Microsoft.Extensions.Diagnostics.Metrics.IMetricsListener => throw null;
                    public static Microsoft.Extensions.Diagnostics.Metrics.IMetricsBuilder AddListener(this Microsoft.Extensions.Diagnostics.Metrics.IMetricsBuilder builder, Microsoft.Extensions.Diagnostics.Metrics.IMetricsListener listener) => throw null;
                    public static Microsoft.Extensions.Diagnostics.Metrics.IMetricsBuilder ClearListeners(this Microsoft.Extensions.Diagnostics.Metrics.IMetricsBuilder builder) => throw null;
                    public static Microsoft.Extensions.Diagnostics.Metrics.IMetricsBuilder DisableMetrics(this Microsoft.Extensions.Diagnostics.Metrics.IMetricsBuilder builder, string meterName) => throw null;
                    public static Microsoft.Extensions.Diagnostics.Metrics.IMetricsBuilder DisableMetrics(this Microsoft.Extensions.Diagnostics.Metrics.IMetricsBuilder builder, string meterName, string instrumentName = default(string), string listenerName = default(string), Microsoft.Extensions.Diagnostics.Metrics.MeterScope scopes = default(Microsoft.Extensions.Diagnostics.Metrics.MeterScope)) => throw null;
                    public static Microsoft.Extensions.Diagnostics.Metrics.MetricsOptions DisableMetrics(this Microsoft.Extensions.Diagnostics.Metrics.MetricsOptions options, string meterName) => throw null;
                    public static Microsoft.Extensions.Diagnostics.Metrics.MetricsOptions DisableMetrics(this Microsoft.Extensions.Diagnostics.Metrics.MetricsOptions options, string meterName, string instrumentName = default(string), string listenerName = default(string), Microsoft.Extensions.Diagnostics.Metrics.MeterScope scopes = default(Microsoft.Extensions.Diagnostics.Metrics.MeterScope)) => throw null;
                    public static Microsoft.Extensions.Diagnostics.Metrics.IMetricsBuilder EnableMetrics(this Microsoft.Extensions.Diagnostics.Metrics.IMetricsBuilder builder, string meterName) => throw null;
                    public static Microsoft.Extensions.Diagnostics.Metrics.IMetricsBuilder EnableMetrics(this Microsoft.Extensions.Diagnostics.Metrics.IMetricsBuilder builder, string meterName, string instrumentName = default(string), string listenerName = default(string), Microsoft.Extensions.Diagnostics.Metrics.MeterScope scopes = default(Microsoft.Extensions.Diagnostics.Metrics.MeterScope)) => throw null;
                    public static Microsoft.Extensions.Diagnostics.Metrics.MetricsOptions EnableMetrics(this Microsoft.Extensions.Diagnostics.Metrics.MetricsOptions options, string meterName) => throw null;
                    public static Microsoft.Extensions.Diagnostics.Metrics.MetricsOptions EnableMetrics(this Microsoft.Extensions.Diagnostics.Metrics.MetricsOptions options, string meterName, string instrumentName = default(string), string listenerName = default(string), Microsoft.Extensions.Diagnostics.Metrics.MeterScope scopes = default(Microsoft.Extensions.Diagnostics.Metrics.MeterScope)) => throw null;
                }
                public class MetricsOptions
                {
                    public MetricsOptions() => throw null;
                    public System.Collections.Generic.IList<Microsoft.Extensions.Diagnostics.Metrics.InstrumentRule> Rules { get => throw null; }
                }
            }
        }
    }
}
