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
{"result": 1}
```

### deleteMessage

**DELETE /message/qname/id**

Delete the message with id `id` from queue `qname`.

Example:

```
DELETE /message/myqueue/dhxekddac921a9422ec10e5439b55aa62e4dd49142
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
DELETE /queue/myqueue
```

Response:

```
{"result": 1}
```

### listQueues

**GET /queues**

Delete the queue `qname` and all messages in that queue.

Example:

```
GET /queues
```

Response:

```
{"queues": ["myqueue","someOtherQueue"]}
```


### receiveMessage

**GET /message/qname**

Receive the next message from the queue.

Parameters:

* `vt` (Number): *optional* *(Default: 30)* The length of time, in seconds, that a message received from a queue will be invisible to other receiving components when they ask to receive messages. Allowed values: 0-9999999

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

### sendMessage

**POST /message/qname**

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



## The MIT License (MIT)

Copyright © 2013 Patrick Liess, http://www.tcs.de

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


