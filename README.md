# Coroutines

Custom stackful coroutines implemented in flat assembly

# what is it & How it works

coroutines are execution states that can be suspended or paused mid-execution and
then can be resumed from the exact instruction where execution was paused
for this specific implementation it relies on stacks, so each coroutine requires
its own stack to store the current execution environment and later can be restored
whenever needed to continue the execution where that coroutine left off
this specific implementation of coroutines works on a single thread

coroutines do not run in parallel instead, they actually cooperatively switch between each other
based on where you want to switch or yield control.

coroutines are useful when your program is waiting on IO operations like reading a huge file or network request
so user can switch to different context while it's waiting and go do something else.

Build this custom example:

```console
$ make
$ ./main
```

## Supported on
- Linux x86_64

## Special Thanks (Credits)
This project was heavily inspired by the recreational programming streamer [Tsoding](https://www.youtube.com/@TsodingDaily).
The original implementation was done on live stream:

[![thumbnail](./thumbnail.png)](https://www.youtube.com/watch?v=sYSP_elDdZw)


