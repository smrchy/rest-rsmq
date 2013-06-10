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

	it 'POST /queue/mytestQueue should return 200 and create the queue', (done) ->
		http.request().post('/queue/' + q1)
			.set('Content-Type','application/json')
			.write(JSON.stringify({ vt: 20, maxsize: 2048 }))
			.end (resp) ->
				resp.statusCode.should.equal(200)
				body = JSON.parse(resp.body)
				body.result.should.equal(1)
				done()
			return
		return


	it 'POST /message/mytestQueue should return 200 and send message 1', (done) ->
		http.request().post('/message/' + q1)
			.set('Content-Type','application/json')
			.write(JSON.stringify({ message: "Hello World!"  }))
			.end (resp) ->
				resp.statusCode.should.equal(200)
				body = JSON.parse(resp.body)
				body.id.length.should.equal(42)
				m1 = body.id
				done()
			return
		return

	it 'POST /message/mytestQueue should return 200 and send message 2', (done) ->
		http.request().post('/message/' + q1)
			.set('Content-Type','application/json')
			.write(JSON.stringify({ message: "Foo"  }))
			.end (resp) ->
				resp.statusCode.should.equal(200)
				body = JSON.parse(resp.body)
				body.id.length.should.equal(42)
				m2 = body.id
				done()
			return
		return


	it 'GET /message/mytestQueue should return message 1', (done) ->
		http.request().get('/message/' + q1).end (resp) ->
			resp.statusCode.should.equal(200)
			body = JSON.parse(resp.body)
			body.id.should.equal(m1)
			done()
			return
		return


	it 'GET /message/mytestQueue should return message 2', (done) ->
		http.request().get('/message/' + q1).end (resp) ->
			resp.statusCode.should.equal(200)
			body = JSON.parse(resp.body)
			body.id.should.equal(m2)
			done()
			return
		return

	it 'GET /message/mytestQueue should not return a message', (done) ->
		http.request().get('/message/' + q1).end (resp) ->
			resp.statusCode.should.equal(200)
			body = JSON.parse(resp.body)
			should.not.exist(body.id)
			done()
			return
		return

	it 'DELETE /message/mytestQueue/:message1 should delete message 1', (done) ->
		http.request().delete('/message/' + q1 + '/' + m1).end (resp) ->
			resp.statusCode.should.equal(200)
			body = JSON.parse(resp.body)
			body.result.should.equal(1)
			done()
			return
		return

	it 'DELETE /message/mytestQueue/:message1 should fail', (done) ->
		http.request().delete('/message/' + q1 + '/' + m1).end (resp) ->
			resp.statusCode.should.equal(200)
			body = JSON.parse(resp.body)
			body.result.should.equal(0)
			done()
			return
		return

	it 'DELETE /message/mytestQueue/:message2 should delete message 2', (done) ->
		http.request().delete('/message/' + q1 + '/' + m2).end (resp) ->
			resp.statusCode.should.equal(200)
			body = JSON.parse(resp.body)
			body.result.should.equal(1)
			done()
			return
		return

	it 'DELETE /queue/mytestQueue should return 200 ', (done) ->
		http.request().delete('/queue/' + q1).expect(200,done)
		return




	return