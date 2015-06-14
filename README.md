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

The `accept` function is called each time a request is made.

You must return a string with the correctly formatted headers and response body.

The `Status` header is particularly important, it is needed by the web server
to return the correct response code and header.

You can access the REQUEST_URI, REQUEST_METHOD and other environment variables
using the `os.getenv` function.

You can never call `print` in the accept function, the FastCGI library owns standard input, output and error at this point. Calling `print` will cause stdout to close and your application will be unable to repspond to requests.

```lua
    function accept()
        return "Status: 200 Ok\r\n" ..
            "Content-Type: text/html\r\n\r\n" ..
            "<h1>Hello!</h1>"
    end
```

### start

The `start` function is called before the process starts accepting requests. This is
a good place to open database connections, parse config files or 
perform any other initialization tasks needed by your application.

Any non-zero return value will be considered a failure and the process will exit
with the return code. <sup>Feature not yet implemented</sup>

```lua
    function run()
        -- do initialization stuff here...
        return 0
    end
```

### restart

The `restart` function is called any time a SIGHUP signal is sent to the spawned 
FastCGI process. You can use this function to reload configuration files, reconnect to 
databases or simply clear the state of the application.

```lua
    function restart()
        -- Do stuff on restart here
    end
```

### stop

The `stop` function is called any time a SIGTERM signal is sent to the spawned 
FastCGI process. It's a good time to flush any cached data or cleanly tear down connections
or open files.

If a non-zero return value is returned the process will not terminate. <sup>Feature not yet implemented</sup>


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

## Examples:

* [Lua Scripts](examples/scripts)
* [Web Server Configuration](examples/config)

## Building

```shell
  mkdir build
  cd build
  cmake ..
  make
```
