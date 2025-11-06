const { merge } = require('webpack-merge');

const baseConfig = require('./webpack.base');

const devServerOpen = process.env.WEBPACK_DEV_DISABLE_OPEN !== 'true';
const devServerPort = 4000;
const devServerAPIProxyPort = 8080;

const config = {
  mode: 'development',
  output: {
    pathinfo: true,
  },
  optimization: {
    runtimeChunk: 'single',
  },
  devtool: 'inline-source-map',
  devServer: {
    historyApiFallback: true,
    hot: true,
    open: devServerOpen,
    host: '0.0.0.0',
    allowedHosts: 'all',
    port: devServerPort,
    proxy: {
      secure: false,
      '/api': `http://localhost:${devServerAPIProxyPort}`,
      '/assets': `http://localhost:${devServerAPIProxyPort}`,
    },
  },
};

module.exports = merge(config, baseConfig);
