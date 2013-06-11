_ = require "underscore"
should = require "should"
async = require "async"
app = require "../app"
http = require "../test/support/http"

#
describe 'REST-rsmq Test', ->

	before (done) ->
		http.createServer(app,done)
		return

	after (done) ->
		done()		
		return

	q1 = "mytestQueue"
	m1 = null
	m2 = null

	it 'POST /queues/mytestQueue should return 200 and create the queue', (done) ->
		http.request().post('/queues/' + q1)
			.set('Content-Type','application/json')
			.write(JSON.stringify({ vt: 20, maxsize: 2048 }))
			.end (resp) ->
				resp.statusCode.should.equal(200)
				body = JSON.parse(resp.body)
				body.result.should.equal(1)
				done()
			return
		return


	it 'POST /messages/mytestQueue should return 200 and send message 1', (done) ->
		http.request().post('/messages/' + q1)
			.set('Content-Type','application/json')
			.write(JSON.stringify({ message: "Hello World!"}))
			.end (resp) ->
				resp.statusCode.should.equal(200)
				body = JSON.parse(resp.body)
				body.id.length.should.equal(42)
				m1 = body.id
				done()
			return
		return

	it 'POST /messages/mytestQueue should return 200 and send message 2', (done) ->
		http.request().post('/messages/' + q1)
			.set('Content-Type','application/json')
			.write(JSON.stringify({ message: "Foo", delay: 20}))
			.end (resp) ->
				resp.statusCode.should.equal(200)
				body = JSON.parse(resp.body)
				body.id.length.should.equal(42)
				m2 = body.id
				done()
			return
		return


	it 'GET /messages/mytestQueue should return message 1', (done) ->
		http.request().get('/messages/' + q1).end (resp) ->
			resp.statusCode.should.equal(200)
			body = JSON.parse(resp.body)
			body.id.should.equal(m1)
			done()
			return
		return

	it 'GET /messages/mytestQueue should not return a message', (done) ->
		http.request().get('/messages/' + q1).end (resp) ->
			resp.statusCode.should.equal(200)
			body = JSON.parse(resp.body)
			should.not.exist(body.id)
			done()
			return
		return

	it 'PUT /messages/mytestQueue/message2 to set vt to 0', (done) ->
		http.request().put('/messages/' + q1 + '/' + m2 + '?vt=0').end (resp) ->
			resp.statusCode.should.equal(200)
			body = JSON.parse(resp.body)
			body.result.should.equal	(1)
			done()
			return
		return


	it 'GET /messages/mytestQueue should return message 2', (done) ->
		http.request().get('/messages/' + q1).end (resp) ->
			resp.statusCode.should.equal(200)
			body = JSON.parse(resp.body)
			body.id.should.equal(m2)
			done()
			return
		return

	it 'GET /messages/mytestQueue should not return a message', (done) ->
		http.request().get('/messages/' + q1).end (resp) ->
			resp.statusCode.should.equal(200)
			body = JSON.parse(resp.body)
			should.not.exist(body.id)
			done()
			return
		return

	it 'DELETE /messages/mytestQueue/:message1 should delete message 1', (done) ->
		http.request().delete('/messages/' + q1 + '/' + m1).end (resp) ->
			resp.statusCode.should.equal(200)
			body = JSON.parse(resp.body)
			body.result.should.equal(1)
			done()
			return
		return

	it 'DELETE /messages/mytestQueue/:message1 should fail', (done) ->
		http.request().delete('/messages/' + q1 + '/' + m1).end (resp) ->
			resp.statusCode.should.equal(200)
			body = JSON.parse(resp.body)
			body.result.should.equal(0)
			done()
			return
		return

	it 'DELETE /messages/mytestQueue/:message2 should delete message 2', (done) ->
		http.request().delete('/messages/' + q1 + '/' + m2).end (resp) ->
			resp.statusCode.should.equal(200)
			body = JSON.parse(resp.body)
			body.result.should.equal(1)
			done()
			return
		return

	it 'GET /queues/mytestQueue should return our queue attributes', (done) ->
		http.request().get('/queues/' + q1).end (resp) ->
			resp.statusCode.should.equal(200)
			body = JSON.parse(resp.body)
			body.maxsize.should.equal(2048)
			body.totalsent.should.equal(2)
			done()
			return
		return

	it 'GET /queues should return our queue name', (done) ->
		http.request().get('/queues').end (resp) ->
			resp.statusCode.should.equal(200)
			body = JSON.parse(resp.body)
			body.queues.should.include(q1)
			done()
			return
		return


	it 'DELETE /queues/mytestQueue should return 200 ', (done) ->
		http.request().delete('/queues/' + q1).expect(200,done)
		return




	return