public class MutualDependency {
	// Violation: BadModel and BadView are mutually dependent
	private static class BadModel {
		private int i;
		private BadView view;

		public int getI() {
			return i;
		}

		public void setI(int i) {
			this.i = i;
			if(view != null) view.modelChanged();
		}

		public void setView(BadView view) {
			this.view = view;
		}
	}

	private static class BadView {
		private BadModel model;

		public BadView(BadModel model) {
			this.model = model;
		}

		public void modelChanged() {
			System.out.println("Model Changed: " + model.getI());
		}
	}
}