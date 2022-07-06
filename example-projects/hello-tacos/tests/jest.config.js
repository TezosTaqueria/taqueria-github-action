
const parentConfig = require('/home/gino/Documents/Repositories/taqueria-github-action/example-projects/hello-tacos/.taq/jest.config.js')

module.exports = {
    ...parentConfig,
    roots: [
        "/home/gino/Documents/Repositories/taqueria-github-action/example-projects/hello-tacos/tests"
    ]
}
