import React from 'react'

class Page extends React.Component {
  static async getInitialProps(ctx) {
    const url = ctx.req.url;
    return { stars: json.stargazers_count, taint: source(1) }
  }

  render() {
    sink(this.props.taint);
    return <div>Next stars: {this.props.stars}</div>
  }
}

export default Page