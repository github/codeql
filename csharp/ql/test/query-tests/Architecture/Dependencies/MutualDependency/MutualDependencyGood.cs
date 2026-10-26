public class Good
{
    private interface IModelListener
    {
        void ModelChanged();
    }

    private class BetterModel
    {
        private int i;
        private IModelListener listener;

        public int GetI()
        {
            return i;
        }

        public void SetI(int i)
        {
            this.i = i;
            if (listener != null) listener.ModelChanged();
        }

        public void SetListener(IModelListener listener)
        {
            this.listener = listener;
        }
    }

    private class BetterView : IModelListener
    {
        private BetterModel model;

        public BetterView(BetterModel model)
        {
            this.model = model;
        }

        public void ModelChanged()
        {
            System.Console.WriteLine("Model Changed: " + model.GetI());
        }
    }
}
