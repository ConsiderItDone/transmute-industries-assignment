var fs = require('fs');

if (!process.env.OAR_DIR) {
    throw new Error('Please define OAR_DIR env variable')
}

const dir = fs.readdirSync(process.env.OAR_DIR);
if (dir.length === 0) {
    console.log('No files found in ' + process.env.OAR_DIR + ' folder...');
    process.exit(1);
}

for (var h = 0; h < dir.length; h++) {
    var path = process.env.OAR_DIR + '/' + dir[h];
    if (!fs.lstatSync(path).isDirectory()) {
        data = require(path)

        console.log(data.oar)
    }
}