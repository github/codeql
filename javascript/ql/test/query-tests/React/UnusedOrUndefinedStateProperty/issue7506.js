class C1 extends React.Component {

  state = {
    p1: ''
  }

  static getDerivedStateFromProps(props, state) {
    const { p1: p2 } = state
  }
}

class C2 extends React.Component {

  state = {
    p1: ''
  }

  static getDerivedStateFromProps_unmodeled(props, state) {
    const { p1: p2 } = state
  }
}
