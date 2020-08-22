#### x86_64

RAX, RBX, RCX, RDX, RDI, RSI, RSP, RBP and R8 through R15

* Parameters: 
  * First Argument: RDI
  * Second Argument: RSI
  * Third Argument: RDX
  * Fourth Argument: RCX
  * Fifth Argument: R8
  * Sixth Argument: R9
  * If there are more than six parameters, then the program’s stack is used to pass in additional parameters to the function.
* RAX
  * Return value
* RIP
  * The location of which code to execute next in the program is determined by `instruction pointer` or `RIP`
* RSP
  * `The stack pointer register` or `RSP`, points to the head of the stack for a particular thread.
* RBP
  * `the base pointer register (RBP)`
  * Programs use offsets from the RBP to access local variables or function parameters while execution is inside the method/function.  
  * the RBP is set to the value of the RSP register at the beginning of a function


#### ARM

#### Command

* register read
  * -f : output format
* register write
