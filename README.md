# REST rsmq

[![Build Status](https://secure.travis-ci.org/smrchy/rest-rsmq.png?branch=master)](http://travis-ci.org/smrchy/rest-rsmq)


A REST interface for [rsmq](https://github.com/smrchy/rsmq) the really simple message queue based on Redis.

This REST interface makes it easy to use [rsmq](https://github.com/smrchy/rsmq) with other application platforms like php, .net etc. Simply call the RESTful methods to send and receive messages.

**Note:** There is no security built in - so use this only in a trusted enviroment, just like memcached.


## Installation

* Make sure Node 0.8.10+ is installed
* Clone this repository
* Run `npm install` to install the dependencies
* For the test make sure Redis runs locally and run `npm test`
* *Optional:* Modify the server port in server.js
* Start the server: `node server.js`


## Methods

### changeMessageVisibility

**PUT /message/qname/id**

Change the visibility of the message with id `id` from queue `qname`.

Example:

```
PUT /message/myqueue/dhxekddac921a9422ec10e5439b55aa62e4dd49142?vt=5
```

Response:

```
{"result": 1}
```


### createQueue

**POST /queues/qname**

Create a new queue `qname`

Parameters:

* `qname` (String): The Queue name. Maximum 80 characters; alphanumeric characters, hyphens (-), and underscores (_) are allowed.
* `vt` (Number): *optional* *(Default: 30)* The length of time, in seconds, that a message received from a queue will be invisible to other receiving components when they ask to receive messages. Allowed values: 0-9999999
* `delay` (Number): *optional* *(Default: 0)* The time in seconds that the delivery of all new messages in the queue will be delayed. Allowed values: 0-9999999
* `maxsize` (Number): *optional* *(Default: 65536)* The maximum message size in bytes. Allowed values: 1024-65536

Example:

```
POST /queues/myqueue
Content-Type: application/json

{
	"vt": 30,
	"delay": 0,
	"maxsize": 2048
}
```

Response:

```
{"result": 1}
```

### deleteMessage

**DELETE /messages/qname/id**

Delete the message with id `id` from queue `qname`.

Example:

```
DELETE /messages/myqueue/dhxekddac921a9422ec10e5439b55aa62e4dd49142
```

Response:

```
{"result": 1}
```


### deleteQueue

**DELETE /queues/qname**

Delete the queue `qname` and all messages in that queue.

Example:

```
DELETE /queues/myqueue
```

Response:

```
{"result": 1}
```


### getQueueAttributes

Get queue attributes, counter and stats

Parameters:

* `qname` (String): The Queue name.

Example:

```
GET /queues/myqueue
```

Response:

```
{
    "vt": 30,
    "delay": 0,
    "maxsize": 65536,
    "totalrecv": 32,
    "totalsent": 13,
    "created": 1371645477,
    "modified": 1371645477,
    "msgs": 4,
    "hiddenmsgs": 2
}
```



### listQueues

**GET /queues**

List all queues.

Example:

```
GET /queues
```

Response:

```
{"queues": ["myqueue","someOtherQueue"]}
```


### receiveMessage

**GET /messages/qname**

Receive the next message from the queue.

Parameters:

* `vt` (Number): *optional* *(Default: 30)* The length of time, in seconds, that a message received from a queue will be invisible to other receiving components when they ask to receive messages. Allowed values: 0-9999999

Example:

```
GET /messages/myqueue?vt=30
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

### sendMessage

**POST /messages/qname**

Sends a new message.

Example:

```
POST /messages/myqueue
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



## The MIT License (MIT)

Please see the LICENSE.md file.
