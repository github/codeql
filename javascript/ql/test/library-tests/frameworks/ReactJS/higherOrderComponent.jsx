import { memo, forwardRef } from 'react';
import { connect } from 'react-redux';
import { compose } from 'redux';
import styled from 'styled-components';
import unknownFunction from 'somewhere';
import { hot } from 'react-hot-loader';
import { withState } from 'recompose';
import { observer as observer1 } from 'mobx-react';
import { observer as observer2 } from 'mobx-react-lite';

import { MyComponent } from './exportedComponent';

const StyledComponent = styled(MyComponent)`
    color: red;
`;

function mapStateToProps(x) {
    return x;
}
function mapDispatchToProps(x) {
    return x;
}

const withConnect = connect(mapStateToProps, mapDispatchToProps);

const ConnectedComponent = compose(withConnect, unknownFunction)(StyledComponent);

const ConnectedComponent2 = withState('counter', 'setCounter', 0)(ConnectedComponent);

const ConnectedComponent3 = observer1(observer2(ConnectedComponent2));

export default hot(module)(memo(forwardRef(ConnectedComponent3)));
