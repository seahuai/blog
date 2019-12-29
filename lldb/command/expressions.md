#### expressions

1. `po`, a shorthand expression of `expression -O --`
2. `p`, a shorhand expression of `expression --`

#### change language context

1. `expression -l objc -O --` change to objc context
2. `expression -l swift -O --` change to swift context

#### option

1. `-i`, LLDB will ignore any breakpoints when executing commands. You can disable this option with the -i option.

   ```shell
   (lldb) expression -l swift -O -i 0 -- $R0.viewDidLoad()
   ```

   

