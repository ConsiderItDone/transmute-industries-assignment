'use strict'

if (!process.env.VIDEO) {
    throw new Error('Please define VIDEO env variable')
}
if (!process.env.OAR) {
    throw new Error('Please define OAR env variable')
}

module.exports = {
    youtubeVideo: process.env.VIDEO,
    addressResolver: process.env.OAR,
}