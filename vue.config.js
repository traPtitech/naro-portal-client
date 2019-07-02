module.exports = {
  lintOnSave: process.env.NODE_ENV !== 'production',
  devServer: {
    proxy: {
      '^/api': {
        target: 'http://twitter_clone_server.mazrean.trap.show/',
        pathRewrite: {
          '^/api/': '/',
        },
      },
    },
    overlay: {
      warnings: true,
      errors: true,
    },
  },
}
