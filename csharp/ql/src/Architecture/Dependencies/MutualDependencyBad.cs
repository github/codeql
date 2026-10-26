public class Bad
{
    private class BadModel
    {
        private int i;
        private BadView view;

        public int GetI()
        {
            return i;
        }

        public void SetI(int i)
        {
            this.i = i;
            if (view != null) view.ModelChanged();
        }

        public void SetView(BadView view)
        {
            this.view = view;
        }
    }

    private class BadView
    {
        private BadModel model;

        public BadView(BadModel model)
        {
            this.model = model;
        }

        public void ModelChanged()
        {
            System.Console.WriteLine("Model Changed: " + model.GetI());
        }
    }
}
