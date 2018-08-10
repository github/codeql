import { Component } from 'react';
import { WebView } from 'react-native';

class LgtmView extends Component {
  render() {
    return <WebView source={{uri: 'https://lgtm.com'}}/>;
  }
}
