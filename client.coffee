Client = require("request-json").JsonClient
client = new Client "http://localhost:3000/"
 
extradata = tag: "happy"

client.sendFile 'upload/', './test.png', extradata, (err, res, body) ->
    if err then console.log err else console.log 'file uploaded'
