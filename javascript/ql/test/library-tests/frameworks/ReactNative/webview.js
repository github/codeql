import { Component } from 'react';
import { WebView } from 'react-native';

class CodeQLView extends Component {
  render() {
    return <WebView source={{uri: 'https://github.com'}}/>;
  }
}
