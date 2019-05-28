module.exports = {
    devServer: {
        proxy:{
            '^/api':{
                target : 'http://150.95.157.67:11240',
                changeOrigin: true
            }
        }
    }
}