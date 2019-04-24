# Servant

Servant is a module that allows you to consume messages from redis stream.

## Basic Usage

### Defined Event Class

First you nend to deflinea a class and method that is going to handle the event

```
	class OrderEvent < BaseEvent
		# message will return hash value of message key from redis stream record

		# the name of a method must correspond to the value of event key from redis stream record, which in this case, is "order.created"
		def created
			#  define your business logic here
			CreateNotificationService(user_id: message["user_id"], order_id: message["order_id"])
		end
	end
```

### Start Servant

As of now, you have all it needs to handle "order.created" event. You can start servant by tying this command in your console

```
	bundle exec servant start -g "notification_service" -e "order.created"
```

`-g` is being used to define a group of that servant. In case that you start multiple servants which belong to the same group, redis stream records of the event will be shared among them.
`-e` is the event or events which a servant subscribes to. You could subscribe to events by defining it like this `-e order.created,order.updated,order.destroyed`


### Publish Event

To test that the servant is running fine. Let's start sending event. You can use servant gem to send an event like this

```
	Servant::Publisher.client.publish(event: "order.created", message: {order_id: 1, user_id: 1})
```
or you can use plain redis client too, if you don't want install servant gem on that particular app
```
	require 'redis'
	require 'json'

	redis = Redis.new(url: "redis://localhost:6379")
	
	message = {order_id: 1, user_id: 1}
	redis.xadd("order.created", message: JSON.dump(message))
```