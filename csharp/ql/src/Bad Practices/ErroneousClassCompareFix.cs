class ErroneousClassCompareFix
{
    public static void ApproveTransaction(object account, Transaction transaction)
    {
        if (account.GetType() == typeof(Trusted.Bank.Account))
        {
            transaction.Process();
        }
    }
}
