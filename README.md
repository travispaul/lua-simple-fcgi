# lua-simple-fcgi

A simple FastCGI interface for writing stateful web applications in Lua.


## Usage

You should create a lua script that returns a table with the following 4 functions.
The only required function is ```accept```.

* accept
* start
* restart
* stop

### accept

The ```accept``` function is called each time a request is made. It's single argument
is a table with the environment variables from the web server.

You must return an array with headers and optionally a response body. An
incorrectly formatted return value will result in a 500 error.

The ```Status``` header is particularly important, it is needed by the web server
to return the correct response code and header.

```lua
    function accept(env)
        local headers = {
            "Content-type" = "text/html",
            "Status" =  [200, "OK"]}

        local body = "<h1>Hello, I'm a malformed HTML document!</h1>"

        return headers, body
    end
```

### start

This function is optional.

The ```start``` function is called before the process starts accepting requests. This is
a good place to open database connections, parse config files or 
perform any other initialization tasks needed by your application.

Any non-zero return value will be considered a failure and the process will exit
with the return code.

```lua
    function run()
        -- do initialization stuff here...
        return 0
    end
```

### restart

The ```restart``` function is called any time a SIGHUP signal is sent to the spawned 
FastCGI process. You can use this function to reload configuration files, reconnect to 
databases or simply clear the state of the application.

This function is optional.

```lua
    function restart()
        -- Do stuff on restart here
    end
```

### stop

The ```stop``` function is called any time a SIGTERM signal is sent to the spawned 
FastCGI process. It's a good time to flush any cached data or cleanly tear down connections
or open files.

If a non-zero return value is returned the process will not terminate.


```lua
    function stop()
        -- goodbye ...
        return 0
    end
```

## Starting your app

```shell
  spawn-fcgi <options> -- lua-simple-fcgi app.lua
```

## Building

```shell
  mkdir build
  cd build
  cmake ..
  make
```