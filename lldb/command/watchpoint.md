#### create a watchpoint to a certain address

1. `watchpoint set expressin -s 1 -w write -- Address`
   1. This creates a new watchpoint that monitors address 0x00006000024d0f60, whose size monitors a 1 byte range (thanks to the -s 1 argument) and only stops if the value gets set
