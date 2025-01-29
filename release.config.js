var config = require('semantic-release-preconfigured-conventional-commits');
config.plugins.push(
    [
        "@semantic-release/exec",
        {
            "prepareCmd": "./update-helm-version.sh ${nextRelease.version}"
        }
    ],
    "@semantic-release/github",
    "@semantic-release/git",
)

module.exports = config