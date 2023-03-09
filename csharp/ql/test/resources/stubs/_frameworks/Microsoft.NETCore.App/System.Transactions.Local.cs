// This file contains auto-generated code.
// Generated from `System.Transactions.Local, Version=7.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`.

namespace System
{
    namespace Transactions
    {
        public class CommittableTransaction : System.Transactions.Transaction, System.IAsyncResult
        {
            object System.IAsyncResult.AsyncState { get => throw null; }
            System.Threading.WaitHandle System.IAsyncResult.AsyncWaitHandle { get => throw null; }
            public System.IAsyncResult BeginCommit(System.AsyncCallback asyncCallback, object asyncState) => throw null;
            public void Commit() => throw null;
            public CommittableTransaction() => throw null;
            public CommittableTransaction(System.TimeSpan timeout) => throw null;
            public CommittableTransaction(System.Transactions.TransactionOptions options) => throw null;
            bool System.IAsyncResult.CompletedSynchronously { get => throw null; }
            public void EndCommit(System.IAsyncResult asyncResult) => throw null;
            bool System.IAsyncResult.IsCompleted { get => throw null; }
        }

        public enum DependentCloneOption : int
        {
            BlockCommitUntilComplete = 0,
            RollbackIfNotComplete = 1,
        }

        public class DependentTransaction : System.Transactions.Transaction
        {
            public void Complete() => throw null;
        }

        public class Enlistment
        {
            public void Done() => throw null;
            internal Enlistment() => throw null;
        }

        [System.Flags]
        public enum EnlistmentOptions : int
        {
            EnlistDuringPrepareRequired = 1,
            None = 0,
        }

        public enum EnterpriseServicesInteropOption : int
        {
            Automatic = 1,
            Full = 2,
            None = 0,
        }

        public delegate System.Transactions.Transaction HostCurrentTransactionCallback();

        public interface IDtcTransaction
        {
            void Abort(System.IntPtr reason, int retaining, int async);
            void Commit(int retaining, int commitType, int reserved);
            void GetTransactionInfo(System.IntPtr transactionInformation);
        }

        public interface IEnlistmentNotification
        {
            void Commit(System.Transactions.Enlistment enlistment);
            void InDoubt(System.Transactions.Enlistment enlistment);
            void Prepare(System.Transactions.PreparingEnlistment preparingEnlistment);
            void Rollback(System.Transactions.Enlistment enlistment);
        }

        public interface IPromotableSinglePhaseNotification : System.Transactions.ITransactionPromoter
        {
            void Initialize();
            void Rollback(System.Transactions.SinglePhaseEnlistment singlePhaseEnlistment);
            void SinglePhaseCommit(System.Transactions.SinglePhaseEnlistment singlePhaseEnlistment);
        }

        public interface ISimpleTransactionSuperior : System.Transactions.ITransactionPromoter
        {
            void Rollback();
        }

        public interface ISinglePhaseNotification : System.Transactions.IEnlistmentNotification
        {
            void SinglePhaseCommit(System.Transactions.SinglePhaseEnlistment singlePhaseEnlistment);
        }

        public interface ITransactionPromoter
        {
            System.Byte[] Promote();
        }

        public enum IsolationLevel : int
        {
            Chaos = 5,
            ReadCommitted = 2,
            ReadUncommitted = 3,
            RepeatableRead = 1,
            Serializable = 0,
            Snapshot = 4,
            Unspecified = 6,
        }

        public class PreparingEnlistment : System.Transactions.Enlistment
        {
            public void ForceRollback() => throw null;
            public void ForceRollback(System.Exception e) => throw null;
            public void Prepared() => throw null;
            public System.Byte[] RecoveryInformation() => throw null;
        }

        public class SinglePhaseEnlistment : System.Transactions.Enlistment
        {
            public void Aborted() => throw null;
            public void Aborted(System.Exception e) => throw null;
            public void Committed() => throw null;
            public void InDoubt() => throw null;
            public void InDoubt(System.Exception e) => throw null;
        }

        public class SubordinateTransaction : System.Transactions.Transaction
        {
            public SubordinateTransaction(System.Transactions.IsolationLevel isoLevel, System.Transactions.ISimpleTransactionSuperior superior) => throw null;
        }

        public class Transaction : System.IDisposable, System.Runtime.Serialization.ISerializable
        {
            public static bool operator !=(System.Transactions.Transaction x, System.Transactions.Transaction y) => throw null;
            public static bool operator ==(System.Transactions.Transaction x, System.Transactions.Transaction y) => throw null;
            public System.Transactions.Transaction Clone() => throw null;
            public static System.Transactions.Transaction Current { get => throw null; set => throw null; }
            public System.Transactions.DependentTransaction DependentClone(System.Transactions.DependentCloneOption cloneOption) => throw null;
            public void Dispose() => throw null;
            public System.Transactions.Enlistment EnlistDurable(System.Guid resourceManagerIdentifier, System.Transactions.IEnlistmentNotification enlistmentNotification, System.Transactions.EnlistmentOptions enlistmentOptions) => throw null;
            public System.Transactions.Enlistment EnlistDurable(System.Guid resourceManagerIdentifier, System.Transactions.ISinglePhaseNotification singlePhaseNotification, System.Transactions.EnlistmentOptions enlistmentOptions) => throw null;
            public bool EnlistPromotableSinglePhase(System.Transactions.IPromotableSinglePhaseNotification promotableSinglePhaseNotification) => throw null;
            public bool EnlistPromotableSinglePhase(System.Transactions.IPromotableSinglePhaseNotification promotableSinglePhaseNotification, System.Guid promoterType) => throw null;
            public System.Transactions.Enlistment EnlistVolatile(System.Transactions.IEnlistmentNotification enlistmentNotification, System.Transactions.EnlistmentOptions enlistmentOptions) => throw null;
            public System.Transactions.Enlistment EnlistVolatile(System.Transactions.ISinglePhaseNotification singlePhaseNotification, System.Transactions.EnlistmentOptions enlistmentOptions) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext context) => throw null;
            public System.Byte[] GetPromotedToken() => throw null;
            public System.Transactions.IsolationLevel IsolationLevel { get => throw null; }
            public System.Transactions.Enlistment PromoteAndEnlistDurable(System.Guid resourceManagerIdentifier, System.Transactions.IPromotableSinglePhaseNotification promotableNotification, System.Transactions.ISinglePhaseNotification enlistmentNotification, System.Transactions.EnlistmentOptions enlistmentOptions) => throw null;
            public System.Guid PromoterType { get => throw null; }
            public void Rollback() => throw null;
            public void Rollback(System.Exception e) => throw null;
            public void SetDistributedTransactionIdentifier(System.Transactions.IPromotableSinglePhaseNotification promotableNotification, System.Guid distributedTransactionIdentifier) => throw null;
            internal Transaction() => throw null;
            public event System.Transactions.TransactionCompletedEventHandler TransactionCompleted;
            public System.Transactions.TransactionInformation TransactionInformation { get => throw null; }
        }

        public class TransactionAbortedException : System.Transactions.TransactionException
        {
            public TransactionAbortedException() => throw null;
            protected TransactionAbortedException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public TransactionAbortedException(string message) => throw null;
            public TransactionAbortedException(string message, System.Exception innerException) => throw null;
        }

        public delegate void TransactionCompletedEventHandler(object sender, System.Transactions.TransactionEventArgs e);

        public class TransactionEventArgs : System.EventArgs
        {
            public System.Transactions.Transaction Transaction { get => throw null; }
            public TransactionEventArgs() => throw null;
        }

        public class TransactionException : System.SystemException
        {
            public TransactionException() => throw null;
            protected TransactionException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public TransactionException(string message) => throw null;
            public TransactionException(string message, System.Exception innerException) => throw null;
        }

        public class TransactionInDoubtException : System.Transactions.TransactionException
        {
            public TransactionInDoubtException() => throw null;
            protected TransactionInDoubtException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public TransactionInDoubtException(string message) => throw null;
            public TransactionInDoubtException(string message, System.Exception innerException) => throw null;
        }

        public class TransactionInformation
        {
            public System.DateTime CreationTime { get => throw null; }
            public System.Guid DistributedIdentifier { get => throw null; }
            public string LocalIdentifier { get => throw null; }
            public System.Transactions.TransactionStatus Status { get => throw null; }
        }

        public static class TransactionInterop
        {
            public static System.Transactions.IDtcTransaction GetDtcTransaction(System.Transactions.Transaction transaction) => throw null;
            public static System.Byte[] GetExportCookie(System.Transactions.Transaction transaction, System.Byte[] whereabouts) => throw null;
            public static System.Transactions.Transaction GetTransactionFromDtcTransaction(System.Transactions.IDtcTransaction transactionNative) => throw null;
            public static System.Transactions.Transaction GetTransactionFromExportCookie(System.Byte[] cookie) => throw null;
            public static System.Transactions.Transaction GetTransactionFromTransmitterPropagationToken(System.Byte[] propagationToken) => throw null;
            public static System.Byte[] GetTransmitterPropagationToken(System.Transactions.Transaction transaction) => throw null;
            public static System.Byte[] GetWhereabouts() => throw null;
            public static System.Guid PromoterTypeDtc;
        }

        public static class TransactionManager
        {
            public static System.TimeSpan DefaultTimeout { get => throw null; set => throw null; }
            public static event System.Transactions.TransactionStartedEventHandler DistributedTransactionStarted;
            public static System.Transactions.HostCurrentTransactionCallback HostCurrentCallback { get => throw null; set => throw null; }
            public static bool ImplicitDistributedTransactions { get => throw null; set => throw null; }
            public static System.TimeSpan MaximumTimeout { get => throw null; set => throw null; }
            public static void RecoveryComplete(System.Guid resourceManagerIdentifier) => throw null;
            public static System.Transactions.Enlistment Reenlist(System.Guid resourceManagerIdentifier, System.Byte[] recoveryInformation, System.Transactions.IEnlistmentNotification enlistmentNotification) => throw null;
        }

        public class TransactionManagerCommunicationException : System.Transactions.TransactionException
        {
            public TransactionManagerCommunicationException() => throw null;
            protected TransactionManagerCommunicationException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public TransactionManagerCommunicationException(string message) => throw null;
            public TransactionManagerCommunicationException(string message, System.Exception innerException) => throw null;
        }

        public struct TransactionOptions : System.IEquatable<System.Transactions.TransactionOptions>
        {
            public static bool operator !=(System.Transactions.TransactionOptions x, System.Transactions.TransactionOptions y) => throw null;
            public static bool operator ==(System.Transactions.TransactionOptions x, System.Transactions.TransactionOptions y) => throw null;
            public bool Equals(System.Transactions.TransactionOptions other) => throw null;
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public System.Transactions.IsolationLevel IsolationLevel { get => throw null; set => throw null; }
            public System.TimeSpan Timeout { get => throw null; set => throw null; }
            // Stub generator skipped constructor 
        }

        public class TransactionPromotionException : System.Transactions.TransactionException
        {
            public TransactionPromotionException() => throw null;
            protected TransactionPromotionException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public TransactionPromotionException(string message) => throw null;
            public TransactionPromotionException(string message, System.Exception innerException) => throw null;
        }

        public class TransactionScope : System.IDisposable
        {
            public void Complete() => throw null;
            public void Dispose() => throw null;
            public TransactionScope() => throw null;
            public TransactionScope(System.Transactions.Transaction transactionToUse) => throw null;
            public TransactionScope(System.Transactions.Transaction transactionToUse, System.TimeSpan scopeTimeout) => throw null;
            public TransactionScope(System.Transactions.Transaction transactionToUse, System.TimeSpan scopeTimeout, System.Transactions.EnterpriseServicesInteropOption interopOption) => throw null;
            public TransactionScope(System.Transactions.Transaction transactionToUse, System.TimeSpan scopeTimeout, System.Transactions.TransactionScopeAsyncFlowOption asyncFlowOption) => throw null;
            public TransactionScope(System.Transactions.Transaction transactionToUse, System.Transactions.TransactionScopeAsyncFlowOption asyncFlowOption) => throw null;
            public TransactionScope(System.Transactions.TransactionScopeAsyncFlowOption asyncFlowOption) => throw null;
            public TransactionScope(System.Transactions.TransactionScopeOption scopeOption) => throw null;
            public TransactionScope(System.Transactions.TransactionScopeOption scopeOption, System.TimeSpan scopeTimeout) => throw null;
            public TransactionScope(System.Transactions.TransactionScopeOption scopeOption, System.TimeSpan scopeTimeout, System.Transactions.TransactionScopeAsyncFlowOption asyncFlowOption) => throw null;
            public TransactionScope(System.Transactions.TransactionScopeOption scopeOption, System.Transactions.TransactionOptions transactionOptions) => throw null;
            public TransactionScope(System.Transactions.TransactionScopeOption scopeOption, System.Transactions.TransactionOptions transactionOptions, System.Transactions.EnterpriseServicesInteropOption interopOption) => throw null;
            public TransactionScope(System.Transactions.TransactionScopeOption scopeOption, System.Transactions.TransactionOptions transactionOptions, System.Transactions.TransactionScopeAsyncFlowOption asyncFlowOption) => throw null;
            public TransactionScope(System.Transactions.TransactionScopeOption scopeOption, System.Transactions.TransactionScopeAsyncFlowOption asyncFlowOption) => throw null;
        }

        public enum TransactionScopeAsyncFlowOption : int
        {
            Enabled = 1,
            Suppress = 0,
        }

        public enum TransactionScopeOption : int
        {
            Required = 0,
            RequiresNew = 1,
            Suppress = 2,
        }

        public delegate void TransactionStartedEventHandler(object sender, System.Transactions.TransactionEventArgs e);

        public enum TransactionStatus : int
        {
            Aborted = 2,
            Active = 0,
            Committed = 1,
            InDoubt = 3,
        }

    }
}
