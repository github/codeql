// This file contains auto-generated code.
// Generated from `System.Diagnostics.PerformanceCounter, Version=8.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`.
namespace System
{
    namespace Diagnostics
    {
        public class CounterCreationData
        {
            public string CounterHelp { get => throw null; set { } }
            public string CounterName { get => throw null; set { } }
            public System.Diagnostics.PerformanceCounterType CounterType { get => throw null; set { } }
            public CounterCreationData() => throw null;
            public CounterCreationData(string counterName, string counterHelp, System.Diagnostics.PerformanceCounterType counterType) => throw null;
        }
        public class CounterCreationDataCollection : System.Collections.CollectionBase
        {
            public int Add(System.Diagnostics.CounterCreationData value) => throw null;
            public void AddRange(System.Diagnostics.CounterCreationDataCollection value) => throw null;
            public void AddRange(System.Diagnostics.CounterCreationData[] value) => throw null;
            public bool Contains(System.Diagnostics.CounterCreationData value) => throw null;
            public void CopyTo(System.Diagnostics.CounterCreationData[] array, int index) => throw null;
            public CounterCreationDataCollection() => throw null;
            public CounterCreationDataCollection(System.Diagnostics.CounterCreationDataCollection value) => throw null;
            public CounterCreationDataCollection(System.Diagnostics.CounterCreationData[] value) => throw null;
            public int IndexOf(System.Diagnostics.CounterCreationData value) => throw null;
            public void Insert(int index, System.Diagnostics.CounterCreationData value) => throw null;
            protected override void OnValidate(object value) => throw null;
            public virtual void Remove(System.Diagnostics.CounterCreationData value) => throw null;
            public System.Diagnostics.CounterCreationData this[int index] { get => throw null; set { } }
        }
        public struct CounterSample : System.IEquatable<System.Diagnostics.CounterSample>
        {
            public long BaseValue { get => throw null; }
            public static float Calculate(System.Diagnostics.CounterSample counterSample) => throw null;
            public static float Calculate(System.Diagnostics.CounterSample counterSample, System.Diagnostics.CounterSample nextCounterSample) => throw null;
            public long CounterFrequency { get => throw null; }
            public long CounterTimeStamp { get => throw null; }
            public System.Diagnostics.PerformanceCounterType CounterType { get => throw null; }
            public CounterSample(long rawValue, long baseValue, long counterFrequency, long systemFrequency, long timeStamp, long timeStamp100nSec, System.Diagnostics.PerformanceCounterType counterType) => throw null;
            public CounterSample(long rawValue, long baseValue, long counterFrequency, long systemFrequency, long timeStamp, long timeStamp100nSec, System.Diagnostics.PerformanceCounterType counterType, long counterTimeStamp) => throw null;
            public static System.Diagnostics.CounterSample Empty;
            public bool Equals(System.Diagnostics.CounterSample sample) => throw null;
            public override bool Equals(object o) => throw null;
            public override int GetHashCode() => throw null;
            public static bool operator ==(System.Diagnostics.CounterSample a, System.Diagnostics.CounterSample b) => throw null;
            public static bool operator !=(System.Diagnostics.CounterSample a, System.Diagnostics.CounterSample b) => throw null;
            public long RawValue { get => throw null; }
            public long SystemFrequency { get => throw null; }
            public long TimeStamp { get => throw null; }
            public long TimeStamp100nSec { get => throw null; }
        }
        public static class CounterSampleCalculator
        {
            public static float ComputeCounterValue(System.Diagnostics.CounterSample newSample) => throw null;
            public static float ComputeCounterValue(System.Diagnostics.CounterSample oldSample, System.Diagnostics.CounterSample newSample) => throw null;
        }
        public interface ICollectData
        {
            void CloseData();
            void CollectData(int id, nint valueName, nint data, int totalBytes, out nint res);
        }
        public class InstanceData
        {
            public InstanceData(string instanceName, System.Diagnostics.CounterSample sample) => throw null;
            public string InstanceName { get => throw null; }
            public long RawValue { get => throw null; }
            public System.Diagnostics.CounterSample Sample { get => throw null; }
        }
        public class InstanceDataCollection : System.Collections.DictionaryBase
        {
            public bool Contains(string instanceName) => throw null;
            public void CopyTo(System.Diagnostics.InstanceData[] instances, int index) => throw null;
            public string CounterName { get => throw null; }
            public InstanceDataCollection(string counterName) => throw null;
            public System.Collections.ICollection Keys { get => throw null; }
            public System.Diagnostics.InstanceData this[string instanceName] { get => throw null; }
            public System.Collections.ICollection Values { get => throw null; }
        }
        public class InstanceDataCollectionCollection : System.Collections.DictionaryBase
        {
            public bool Contains(string counterName) => throw null;
            public void CopyTo(System.Diagnostics.InstanceDataCollection[] counters, int index) => throw null;
            public InstanceDataCollectionCollection() => throw null;
            public System.Collections.ICollection Keys { get => throw null; }
            public System.Diagnostics.InstanceDataCollection this[string counterName] { get => throw null; }
            public System.Collections.ICollection Values { get => throw null; }
        }
        public sealed class PerformanceCounter : System.ComponentModel.Component, System.ComponentModel.ISupportInitialize
        {
            public void BeginInit() => throw null;
            public string CategoryName { get => throw null; set { } }
            public void Close() => throw null;
            public static void CloseSharedResources() => throw null;
            public string CounterHelp { get => throw null; }
            public string CounterName { get => throw null; set { } }
            public System.Diagnostics.PerformanceCounterType CounterType { get => throw null; }
            public PerformanceCounter() => throw null;
            public PerformanceCounter(string categoryName, string counterName) => throw null;
            public PerformanceCounter(string categoryName, string counterName, bool readOnly) => throw null;
            public PerformanceCounter(string categoryName, string counterName, string instanceName) => throw null;
            public PerformanceCounter(string categoryName, string counterName, string instanceName, bool readOnly) => throw null;
            public PerformanceCounter(string categoryName, string counterName, string instanceName, string machineName) => throw null;
            public long Decrement() => throw null;
            public static int DefaultFileMappingSize;
            protected override void Dispose(bool disposing) => throw null;
            public void EndInit() => throw null;
            public long Increment() => throw null;
            public long IncrementBy(long value) => throw null;
            public System.Diagnostics.PerformanceCounterInstanceLifetime InstanceLifetime { get => throw null; set { } }
            public string InstanceName { get => throw null; set { } }
            public string MachineName { get => throw null; set { } }
            public System.Diagnostics.CounterSample NextSample() => throw null;
            public float NextValue() => throw null;
            public long RawValue { get => throw null; set { } }
            public bool ReadOnly { get => throw null; set { } }
            public void RemoveInstance() => throw null;
        }
        public sealed class PerformanceCounterCategory
        {
            public string CategoryHelp { get => throw null; }
            public string CategoryName { get => throw null; set { } }
            public System.Diagnostics.PerformanceCounterCategoryType CategoryType { get => throw null; }
            public bool CounterExists(string counterName) => throw null;
            public static bool CounterExists(string counterName, string categoryName) => throw null;
            public static bool CounterExists(string counterName, string categoryName, string machineName) => throw null;
            public static System.Diagnostics.PerformanceCounterCategory Create(string categoryName, string categoryHelp, System.Diagnostics.CounterCreationDataCollection counterData) => throw null;
            public static System.Diagnostics.PerformanceCounterCategory Create(string categoryName, string categoryHelp, System.Diagnostics.PerformanceCounterCategoryType categoryType, System.Diagnostics.CounterCreationDataCollection counterData) => throw null;
            public static System.Diagnostics.PerformanceCounterCategory Create(string categoryName, string categoryHelp, System.Diagnostics.PerformanceCounterCategoryType categoryType, string counterName, string counterHelp) => throw null;
            public static System.Diagnostics.PerformanceCounterCategory Create(string categoryName, string categoryHelp, string counterName, string counterHelp) => throw null;
            public PerformanceCounterCategory() => throw null;
            public PerformanceCounterCategory(string categoryName) => throw null;
            public PerformanceCounterCategory(string categoryName, string machineName) => throw null;
            public static void Delete(string categoryName) => throw null;
            public static bool Exists(string categoryName) => throw null;
            public static bool Exists(string categoryName, string machineName) => throw null;
            public static System.Diagnostics.PerformanceCounterCategory[] GetCategories() => throw null;
            public static System.Diagnostics.PerformanceCounterCategory[] GetCategories(string machineName) => throw null;
            public System.Diagnostics.PerformanceCounter[] GetCounters() => throw null;
            public System.Diagnostics.PerformanceCounter[] GetCounters(string instanceName) => throw null;
            public string[] GetInstanceNames() => throw null;
            public bool InstanceExists(string instanceName) => throw null;
            public static bool InstanceExists(string instanceName, string categoryName) => throw null;
            public static bool InstanceExists(string instanceName, string categoryName, string machineName) => throw null;
            public string MachineName { get => throw null; set { } }
            public System.Diagnostics.InstanceDataCollectionCollection ReadCategory() => throw null;
        }
        public enum PerformanceCounterCategoryType
        {
            Unknown = -1,
            SingleInstance = 0,
            MultiInstance = 1,
        }
        public enum PerformanceCounterInstanceLifetime
        {
            Global = 0,
            Process = 1,
        }
        public sealed class PerformanceCounterManager : System.Diagnostics.ICollectData
        {
            void System.Diagnostics.ICollectData.CloseData() => throw null;
            void System.Diagnostics.ICollectData.CollectData(int callIdx, nint valueNamePtr, nint dataPtr, int totalBytes, out nint res) => throw null;
            public PerformanceCounterManager() => throw null;
        }
        public enum PerformanceCounterType
        {
            NumberOfItemsHEX32 = 0,
            NumberOfItemsHEX64 = 256,
            NumberOfItems32 = 65536,
            NumberOfItems64 = 65792,
            CounterDelta32 = 4195328,
            CounterDelta64 = 4195584,
            SampleCounter = 4260864,
            CountPerTimeInterval32 = 4523008,
            CountPerTimeInterval64 = 4523264,
            RateOfCountsPerSecond32 = 272696320,
            RateOfCountsPerSecond64 = 272696576,
            RawFraction = 537003008,
            CounterTimer = 541132032,
            Timer100Ns = 542180608,
            SampleFraction = 549585920,
            CounterTimerInverse = 557909248,
            Timer100NsInverse = 558957824,
            CounterMultiTimer = 574686464,
            CounterMultiTimer100Ns = 575735040,
            CounterMultiTimerInverse = 591463680,
            CounterMultiTimer100NsInverse = 592512256,
            AverageTimer32 = 805438464,
            ElapsedTime = 807666944,
            AverageCount64 = 1073874176,
            SampleBase = 1073939457,
            AverageBase = 1073939458,
            RawBase = 1073939459,
            CounterMultiBase = 1107494144,
        }
        namespace PerformanceData
        {
            public sealed class CounterData
            {
                public void Decrement() => throw null;
                public void Increment() => throw null;
                public void IncrementBy(long value) => throw null;
                public long RawValue { get => throw null; set { } }
                public long Value { get => throw null; set { } }
            }
            public class CounterSet : System.IDisposable
            {
                public void AddCounter(int counterId, System.Diagnostics.PerformanceData.CounterType counterType) => throw null;
                public void AddCounter(int counterId, System.Diagnostics.PerformanceData.CounterType counterType, string counterName) => throw null;
                public System.Diagnostics.PerformanceData.CounterSetInstance CreateCounterSetInstance(string instanceName) => throw null;
                public CounterSet(System.Guid providerGuid, System.Guid counterSetGuid, System.Diagnostics.PerformanceData.CounterSetInstanceType instanceType) => throw null;
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
            }
            public sealed class CounterSetInstance : System.IDisposable
            {
                public System.Diagnostics.PerformanceData.CounterSetInstanceCounterDataSet Counters { get => throw null; }
                public void Dispose() => throw null;
            }
            public sealed class CounterSetInstanceCounterDataSet : System.IDisposable
            {
                public void Dispose() => throw null;
                public System.Diagnostics.PerformanceData.CounterData this[int counterId] { get => throw null; }
                public System.Diagnostics.PerformanceData.CounterData this[string counterName] { get => throw null; }
            }
            public enum CounterSetInstanceType
            {
                Single = 0,
                Multiple = 2,
                GlobalAggregate = 4,
                MultipleAggregate = 6,
                GlobalAggregateWithHistory = 11,
                InstanceAggregate = 22,
            }
            public enum CounterType
            {
                RawDataHex32 = 0,
                RawDataHex64 = 256,
                RawData32 = 65536,
                RawData64 = 65792,
                Delta32 = 4195328,
                Delta64 = 4195584,
                SampleCounter = 4260864,
                QueueLength = 4523008,
                LargeQueueLength = 4523264,
                QueueLength100Ns = 5571840,
                QueueLengthObjectTime = 6620416,
                RateOfCountPerSecond32 = 272696320,
                RateOfCountPerSecond64 = 272696576,
                RawFraction32 = 537003008,
                RawFraction64 = 537003264,
                PercentageActive = 541132032,
                PrecisionSystemTimer = 541525248,
                PercentageActive100Ns = 542180608,
                PrecisionTimer100Ns = 542573824,
                ObjectSpecificTimer = 543229184,
                PrecisionObjectSpecificTimer = 543622400,
                SampleFraction = 549585920,
                PercentageNotActive = 557909248,
                PercentageNotActive100Ns = 558957824,
                MultiTimerPercentageActive = 574686464,
                MultiTimerPercentageActive100Ns = 575735040,
                MultiTimerPercentageNotActive = 591463680,
                MultiTimerPercentageNotActive100Ns = 592512256,
                AverageTimer32 = 805438464,
                ElapsedTime = 807666944,
                AverageCount64 = 1073874176,
                SampleBase = 1073939457,
                AverageBase = 1073939458,
                RawBase32 = 1073939459,
                RawBase64 = 1073939712,
                MultiTimerBase = 1107494144,
            }
        }
    }
}
