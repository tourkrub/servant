# Servant

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/servant`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Docker

build

```
docker build -t servant .
```

run
```
docker run -e "REDIS_HOST=192.168.1.141" -e -it servant bundle exec servant start -g GROUP_ID -e EVENT_1,EVENT_2
```

test
```
docker run servant rspec
```