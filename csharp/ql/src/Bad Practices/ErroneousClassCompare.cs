class ErroneousClassCompare
{
    public static void ApproveTransaction(object account, Transaction transaction)
    {
        if (account.GetType().FullName == "Trusted.Bank.Account")
        {
            transaction.Process();
        }
    }
}
