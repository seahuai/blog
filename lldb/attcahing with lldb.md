

#### attch with runninng process

1. get PID of the running process,`pgrep -x Process`
2. run lldb commend,`lldb -p PID`
3. easy way, `lldb -n Xcode`

#### attach a future process

1. user `-w` argument
2. example:`lldb -n Finder -w`

#### attach with process path

1. set a process path with`lldb -f ../../`
2. run, `process launch`
3. launch process with argument, `process launch -w argument`,or user `run argument`
4. remove attaching target from lldb `target delete`
5. set new target `target create ../../`

#### environment variables

1. after attaching a process with lldb,use `env` to display all the enviroment variables
2. launch with `-v` option to set the enviroment variables
3. example:`process launch -v LSCOLORS=Ab -v CLICOLOR=1  -- /Applications/`