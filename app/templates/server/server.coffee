cookieParser = require 'cookie-parser'
fs           = require 'fs'
log          = console.log
PeerServer   = require('./peerjs-server').PeerServer
coffee       = require 'coffee-script'
ngrok        = require 'ngrok'
restify      = require('./peerjs-server/node_modules/restify')


# fs.writeFileSync "./static/main.js",coffee.compile(fs.readFileSync("./app/client/main.coffee","utf8"))


maps =
    c2p : {}
    p2c : {}


peers = {}


index = fs.readFileSync "./static/index.html"
indexLen = Buffer.byteLength(index+"")

defaultRoute = (req, res, next) ->
    # res.cookie "peerid", peerid


    # res.cookie "peers", peerList(channel)
    # log "sending peers:",peerList(channel)


    console.log req.params

    res.writeHead 200,
        "Content-Length" : indexLen
        'Content-Type'   : 'text/html'
    res.write index
    res.end()
    next()

path = require 'path'
ps = new PeerServer
    port : 3000
    path : '/-/ps'
    static:
        path      : /\/static\/?.*/
        directory : path.join __dirname, "/.."
        default   : 'index.html'
    routes :
      [
        {
            type : "get"
            path : "/peers"
            fn   : (req,res,next)->
                # res.writeHead 200,
                #     'Content-Type'   : 'application/json'
                res.send 200, peers

        },
        {
        type : "get"
        path : "/:all"
        fn   : defaultRoute
        },
        {
        type : "get"
        path : "/"
        fn   : defaultRoute
        }
      ]




ps.on "connection",(peerid)->
    log "connected:",peerid
    peers[peerid] = ""
ps.on "disconnect",(peerid)->
    log "disconnected:",peerid
    delete peers[peerid]

# setTimeout ->
#     [{name:"p2p",  port: 3000}].forEach (kite)->
#         id = process.env.USER
#         subdomain = "#{kite.name}-#{id}"
#         console.log "--------------------> creating public website #{subdomain}"
#         ngrok.connect
#           authtoken : 'CMY-UsZMWdx586A3tA0U'
#           subdomain : subdomain
#           port      : kite.port
#         , (err, url)->

#           if err
#             console.log "Failed to create #{kite.name} tunnel: ", err
#           else
#             console.log "0.0.0.0:#{kite.port} for #{subdomain} is now tunneling with: ", url
# ,10000
