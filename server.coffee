PORT = 8101

app = require "./app"

server = app.listen(PORT)
console.log "Listening on port #{PORT}"