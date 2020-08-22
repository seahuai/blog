#### thread

1. `thread backtrace` or `bt` - Show thread call stacks. Defaults to the current  thread

#### Frame

1. `frame info` - List information about the current stack frame in the current thread
2. `frame selecte 1` or `f 1s` - Select the current stack frame by index from within the current thread
3. `frame variable` - output the scope of all the variables in your function as well as any global variables within your program. use `-F` option to flat output

#### Step

* step over: lldb will run until function has completed and returnd
  * command: `next`
* step into:lldb will stepping into a function if there are debug symbols for this function
  * command: `step`
  * option: `a0`: `step -a0`, step in regardless of whether you have the required debug symbols or not
* step out:means a function will continue for its duration then stop when it has returned
  * command:`finish`