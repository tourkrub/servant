# Servant

Servant is a module that allows you to subscribe to redis stream and handle the event.

## Install

```
gem 'servant', git: 'git@bitbucket.org:tourkrub/servant.git', branch: 'master'
```

## Basic Usage

Create `config/servant.rb`.

```
	# For rails, you need to add these two lines below
	require_relative 'application'
	require_relative 'environment'

	Servant::Application.configure do |config|
		config.redis = Redis.new(url: YOUR_REDIS_URL)
	end
```

### Define Event Class

First you need to define a class and method that is going to handle the event

```
	#notification-service

	class OrderEventHandler < Servant::EventHandler
		# message will return hash value of message key from redis stream record

		# the name of a method must correspond to the value of event key from redis stream record, which in this case, is "order.created"
		def created
			# :event and :message are available methods
			# define your business logic here

			SendSlackMessageService.process(user_id: message["user_id"], order_id: message["order_id"])
			SendConfirmationEmailService.process(user_id: message["user_id"], order_id: message["order_id"])
		end
	end
```

You can optionally wrap everything inside a worker. Remeber it's going to require sidekiq.

```
	class OrderEventHandler < Servant::EventHandler
		set_async_methods :created
		
		...
	end
```

### Define routes



```
	Servant::Router.draw do
      on "order.created", path: "OrderEventHandler#created"
    end
```


### Start Servant

As of now, you have all it needs to handle "order.created" event. You can start servant by tying this command on your console

```
	bundle exec servant start -g "notification-service"
```

Options

`-g` is being used to define a group of that servant. In case that you start multiple servants which belong to the same group, redis stream records of the event will be shared among them.

`-e` is the event or events which a servant subscribes to. You could subscribe to events by defining it like this `-e order.created,order.updated,order.destroyed`


### Publish Event

To test that the servant is running fine. Let's start sending an event. You can use servant gem to send an event like this

```
	Servant::Publisher.client.publish(event: "order.created", message: {order_id: 1, user_id: 1}, meta: {something: "important"}, correlation_id: "foo")
```

or you can use a plain redis client too if you don't want install servant gem on that particular app

```
	require 'redis'
	require 'json'

	redis = Redis.new(url: "redis://localhost:6379")
	
	message = {order_id: 1, user_id: 1}
	redis.xadd("event:order.created", message: JSON.dump(message))
```