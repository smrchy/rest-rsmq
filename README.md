# REST rsmq

[![Build Status](https://secure.travis-ci.org/smrchy/rest-rsmq.png?branch=master)](http://travis-ci.org/smrchy/rest-rsmq)


A REST interface for [redis-rsmq](https://github.com/smrchy/rsmq).

This REST interface makes it easy to use [redis-rsmq](https://github.com/smrchy/rsmq) with other application platforms like php, .net etc. Simply call the RESTful methods to send and receive messages.

**Note:** There is no security built in - so use this only in a trusted enviroment, just like memcached.


## Installation

* Clone this repository
* Run `npm install` to install the dependencies.
* For the test make sure Redis runs locally and run `npm test`
* *Optional:* Modify the server port in server.js
* Start the server: `node server.js`


## Methods


### POST /queue/:qname

Create a new queue `qname`

Parameters:

* `qname` (String): The Queue name. Maximum 80 characters; alphanumeric characters, hyphens (-), and underscores (_) are allowed.
* `vt` (Number): *optional* *(Default: 30)* The length of time, in seconds, that a message received from a queue will be invisible to other receiving components when they ask to receive messages. Allowed values: 0-86400
* `delay` (Number): *optional* *(Default: 0)* The time in seconds that the delivery of all new messages in the queue will be delayed. Allowed values: 0-86400
* `maxsize` (Number): *optional* *(Default: 65536)* The maximum message size in bytes. Allowed values: 1024-65536

Example:

```
POST /queue/myqueue
Content-Type: application/json

{
	"vt": 30,
	"delay": 0,
	"maxsize": 2048
}
```

Response:

```
{"result": "1"}

```


### DELETE /queue/:qname

Delete the queue `qname` and all messages in that queue.

Example:

```
DELETE /queue/myqueue
```

Response:

```
{"result": "1"}
```

### POST /message/:qname

Sends a new message.

Example:

```
POST /message/myqueue
Content-Type: application/json

{
	"message": "Hello World!",
	"delay": 0
}
```

Response: 

```
{
    "id": "dhxekddac921a9422ec10e5439b55aa62e4dd49142"
}
```

### GET /message/:qname

Receive the next message from the queue.

Parameters:

* `vt` (Number): *optional* *(Default: 30)* The length of time, in seconds, that a message received from a queue will be invisible to other receiving components when they ask to receive messages. Allowed values: 0-86400

Example:

```
GET /message/myqueue?vt=30
```

Response:

```
{
    "id": "dhxeguaqv8cb2c78e9b5c97121d60f4caf54925c03",
    "message": "Hello World!",
    "rc": 1,
    "fr": 1370856862274,
    "sent": 1370855815832
}
```
