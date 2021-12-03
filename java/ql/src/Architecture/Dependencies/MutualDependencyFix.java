public class NoMutualDependency {
	// Better: A new interface breaks the dependency
	// from the model to the view
	private interface ModelListener {
		void modelChanged();
	}

	private static class BetterModel {
		private int i;
		private ModelListener listener;

		public int getI() {
			return i;
		}

		public void setI(int i) {
			this.i = i;
			if (listener != null) listener.modelChanged();
		}

		public void setListener(ModelListener listener) {
			this.listener = listener;
		}
	}

	private static class BetterView implements ModelListener {
		private BetterModel model;

		public BetterView(BetterModel model) {
			this.model = model;
		}

		public void modelChanged() {
			System.out.println("Model Changed: " + model.getI());
		}
	}

	public static void main(String[] args) {
		BadModel badModel = new BadModel();
		BadView badView = new BadView(badModel);
		badModel.setView(badView);
		badModel.setI(23);
		badModel.setI(9);

		BetterModel betterModel = new BetterModel();
		BetterView betterView = new BetterView(betterModel);
		betterModel.setListener(betterView);
		betterModel.setI(24);
		betterModel.setI(12);
	}
}