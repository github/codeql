// This file contains auto-generated code.
// Generated from `System.Diagnostics.Contracts, Version=7.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.

namespace System
{
    namespace Diagnostics
    {
        namespace Contracts
        {
            public static class Contract
            {
                public static void Assert(bool condition) => throw null;
                public static void Assert(bool condition, string userMessage) => throw null;
                public static void Assume(bool condition) => throw null;
                public static void Assume(bool condition, string userMessage) => throw null;
                public static event System.EventHandler<System.Diagnostics.Contracts.ContractFailedEventArgs> ContractFailed;
                public static void EndContractBlock() => throw null;
                public static void Ensures(bool condition) => throw null;
                public static void Ensures(bool condition, string userMessage) => throw null;
                public static void EnsuresOnThrow<TException>(bool condition) where TException : System.Exception => throw null;
                public static void EnsuresOnThrow<TException>(bool condition, string userMessage) where TException : System.Exception => throw null;
                public static bool Exists(int fromInclusive, int toExclusive, System.Predicate<int> predicate) => throw null;
                public static bool Exists<T>(System.Collections.Generic.IEnumerable<T> collection, System.Predicate<T> predicate) => throw null;
                public static bool ForAll(int fromInclusive, int toExclusive, System.Predicate<int> predicate) => throw null;
                public static bool ForAll<T>(System.Collections.Generic.IEnumerable<T> collection, System.Predicate<T> predicate) => throw null;
                public static void Invariant(bool condition) => throw null;
                public static void Invariant(bool condition, string userMessage) => throw null;
                public static T OldValue<T>(T value) => throw null;
                public static void Requires(bool condition) => throw null;
                public static void Requires(bool condition, string userMessage) => throw null;
                public static void Requires<TException>(bool condition) where TException : System.Exception => throw null;
                public static void Requires<TException>(bool condition, string userMessage) where TException : System.Exception => throw null;
                public static T Result<T>() => throw null;
                public static T ValueAtReturn<T>(out T value) => throw null;
            }

            public class ContractAbbreviatorAttribute : System.Attribute
            {
                public ContractAbbreviatorAttribute() => throw null;
            }

            public class ContractArgumentValidatorAttribute : System.Attribute
            {
                public ContractArgumentValidatorAttribute() => throw null;
            }

            public class ContractClassAttribute : System.Attribute
            {
                public ContractClassAttribute(System.Type typeContainingContracts) => throw null;
                public System.Type TypeContainingContracts { get => throw null; }
            }

            public class ContractClassForAttribute : System.Attribute
            {
                public ContractClassForAttribute(System.Type typeContractsAreFor) => throw null;
                public System.Type TypeContractsAreFor { get => throw null; }
            }

            public class ContractFailedEventArgs : System.EventArgs
            {
                public string Condition { get => throw null; }
                public ContractFailedEventArgs(System.Diagnostics.Contracts.ContractFailureKind failureKind, string message, string condition, System.Exception originalException) => throw null;
                public System.Diagnostics.Contracts.ContractFailureKind FailureKind { get => throw null; }
                public bool Handled { get => throw null; }
                public string Message { get => throw null; }
                public System.Exception OriginalException { get => throw null; }
                public void SetHandled() => throw null;
                public void SetUnwind() => throw null;
                public bool Unwind { get => throw null; }
            }

            public enum ContractFailureKind : int
            {
                Assert = 4,
                Assume = 5,
                Invariant = 3,
                Postcondition = 1,
                PostconditionOnException = 2,
                Precondition = 0,
            }

            public class ContractInvariantMethodAttribute : System.Attribute
            {
                public ContractInvariantMethodAttribute() => throw null;
            }

            public class ContractOptionAttribute : System.Attribute
            {
                public string Category { get => throw null; }
                public ContractOptionAttribute(string category, string setting, bool enabled) => throw null;
                public ContractOptionAttribute(string category, string setting, string value) => throw null;
                public bool Enabled { get => throw null; }
                public string Setting { get => throw null; }
                public string Value { get => throw null; }
            }

            public class ContractPublicPropertyNameAttribute : System.Attribute
            {
                public ContractPublicPropertyNameAttribute(string name) => throw null;
                public string Name { get => throw null; }
            }

            public class ContractReferenceAssemblyAttribute : System.Attribute
            {
                public ContractReferenceAssemblyAttribute() => throw null;
            }

            public class ContractRuntimeIgnoredAttribute : System.Attribute
            {
                public ContractRuntimeIgnoredAttribute() => throw null;
            }

            public class ContractVerificationAttribute : System.Attribute
            {
                public ContractVerificationAttribute(bool value) => throw null;
                public bool Value { get => throw null; }
            }

            public class PureAttribute : System.Attribute
            {
                public PureAttribute() => throw null;
            }

        }
    }
    namespace Runtime
    {
        namespace CompilerServices
        {
            public static class ContractHelper
            {
                public static string RaiseContractFailedEvent(System.Diagnostics.Contracts.ContractFailureKind failureKind, string userMessage, string conditionText, System.Exception innerException) => throw null;
                public static void TriggerFailure(System.Diagnostics.Contracts.ContractFailureKind kind, string displayMessage, string userMessage, string conditionText, System.Exception innerException) => throw null;
            }

        }
    }
}
