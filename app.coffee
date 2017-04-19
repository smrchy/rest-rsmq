###
Rest rsmq

The MIT License (MIT)

Copyright © 2013 Patrick Liess, http://www.tcs.de

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
###


RSMQ = require "rsmq"
rsmq = new RSMQ()

express = require 'express'
app = express()


app.use (req, res, next) ->
	res.header('Content-Type', "application/json")
	res.removeHeader("X-Powered-By")
	next()
	return

app.configure ->
	app.use( express.logger("dev") )
	app.use(express.bodyParser())
	return



app.get '/queues', (req, res) ->
	rsmq.listQueues (err, resp) ->
		if err
			res.send(err, 500)
			return
		res.send({queues: resp})
		return


app.get '/queues/:qname', (req, res) ->
	rsmq.getQueueAttributes {qname: req.params.qname}, (err, resp) ->
		if err
			res.send(err, 500)
			return
		res.send(resp)
		return


app.post '/queues/:qname', (req, res) ->
	params = req.body
	params.qname = req.params.qname
	rsmq.createQueue params, (err, resp) ->
		if err
			res.send(err, 500)
			return
		res.send({result:resp})
		return
	return
	

app.delete '/queues/:qname', (req, res) ->
	rsmq.deleteQueue {qname: req.params.qname}, (err, resp) ->
		if err
			res.send(err, 500)
			return
		res.send({result:resp})
		return


app.post '/messages/:qname', (req, res) ->
	params = req.body
	params.qname = req.params.qname
	params.message = JSON.stringify req.params.message if req.params.message?
	rsmq.sendMessage params, (err, resp) ->
		if err
			res.send(err, 500)
			return
		res.send({id:resp})
		return
	return


app.get '/messages/:qname', (req, res) ->
	rsmq.receiveMessage {qname: req.params.qname, vt: req.param("vt")}, (err, resp) ->
		if err
			res.send(err, 500)
			return
		res.send(resp)
		return
	return

app.put '/messages/:qname/:id', (req, res) ->
	rsmq.changeMessageVisibility {qname: req.params.qname, id: req.params.id, vt: req.param("vt")}, (err, resp) ->
		if err
			res.send(err, 500)
			return
		res.send({result:resp})
		return
	return


app.delete '/messages/:qname/:id', (req, res) ->
	rsmq.deleteMessage req.params, (err, resp) ->
		if err
			res.send(err, 500)
			return
		res.send({result:resp})
		return
	return






module.exports = app
