import React from "react"

class C extends React.Component {
	static getDerivedStateFromError(error) {
		return { error }
	}

	render() {
		this.state.error;
	}
}

