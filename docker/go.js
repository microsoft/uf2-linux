var fs = require("fs")
var child_process = require("child_process")

process.stdin.setEncoding("utf8")
process.stdout.setEncoding("utf8")

var buf = ""
process.stdin.on("data", function(d) { buf += d })
process.stdin.on("end", function() {
    handle(JSON.parse(buf))
})

function handle(req) {
    fs.writeFileSync("builder.js", req.builderJs);
    global.buildReq = req;
    require("./builder")
}
