const execSh = require('exec-sh');
const path = require('path');

var route = function route(req, res, next, abe) {
  res.setHeader('Content-Type', 'application/json');
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  
  if(req.query && req.query.generate) {
    var imagePath = path.join(abe.config.root, abe.config.publish.url, abe.config.upload.image);
    var tinpypng = abe.config.tinpypng;
    // process.stdout.write('\033c');
    execSh(`sh ../../shell/tinypng.sh ${imagePath} ${tinpypng.ApiKey} ${tinpypng.minSize} ${tinpypng.sleepTime} ${tinpypng.sleepCount}`, { cwd: __dirname }, function(err){
      if (err) {
        console.log("Exit code: ", err.code);
        return;
      }
      res.send(JSON.stringify({
        ok: 1
      }));
    });
  }
}

exports.default = route