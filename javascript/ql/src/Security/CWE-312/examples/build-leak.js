const webpack = require("webpack");

module.exports = [{
    plugins: [
        new webpack.DefinePlugin({
            "process.env": JSON.stringify(process.env)
        })
    ]
}];