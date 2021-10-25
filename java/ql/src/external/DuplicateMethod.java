class RowWidget extends Widget {
	// ...
	public void collectChildren(Set<Widget> result) {
		for (Widget child : this.children) {
			if (child.isVisible()) {
				result.add(children);
				child.collectChildren(result);
			}
		}
	}
}

class ColumnWidget extends Widget {
	// ...
	public void collectChildren(Set<Widget> result) {
		for (Widget child : this.children) {
			if (child.isVisible()) {
				result.add(children);
				child.collectChildren(result);
			}
		}
	}
}