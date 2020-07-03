# PipeUtils
Basic component for pipeline design

# Pipeline control
## Pipeline

Source code of pipeline control logic is at <A Href="https://github.com/kuopinghsu/pipeutils/blob/master/rtl/pipeline.vh">pipeline.vh</A>

Include the pipeline task.

```verilog
`include "pipeline.vh"
```

Assign the state machine for ready/valid control.

```verilog
always @(posedge clk or negedge resetb)
begin
    if (!resetb)
        state	<= 1'b0;
    else
        state	<= state_nxt;
end
```

Use the pipeline task to perform ready/valid control.

```verilog
always @*
begin
    pipeline (
        .state 		(state),
        .state_nxt 	(state_nxt),
        
        .ready_in	(ready_in),
        .valid_in	(valid_in),
        
        .ready_out	(ready_out),
        .valid_out	(valid_out),
        .stall		(stall)
    );
end
```

Data path.

```verilog
always @(posedge clk)
begin
    if (!stall)
        dout <= din
end
```

<img src="https://github.com/kuopinghsu/pipeutils/blob/master/images/pipeline.svg" alt="pipeline" width=480>

### Timing issue on valid signal
<img src="https://github.com/kuopinghsu/pipeutils/blob/master/images/pipe_back2back.svg" alt="back2back" width=800>

## bypass

The source code of bypass logic is at <A Href="https://github.com/kuopinghsu/pipeutils/blob/master/rtl/bypass.vh">bypass.vh</A>

Include the bypass task.

```verilog
`include "bypass.vh"
```

Assigned the ready/valid state machine.

```verilog
always @(posedge clk or negedge resetb)
begin
    if (!resetb)
        state		<= 1'b0;
    else
        state		<= state_nxt;
end
```

Use the bypass to perform ready/valid handshaking.

```verilog
always @*
begin
    bypass (
        .state		(state),
        .state_nxt	(state_nxt),
        
        .ready_in	(ready_in),
        .valid_in	(valid_in),
        
        .ready_out	(ready_out),
        .valid_out	(valid_out),
        .stall		(stall),
        .selection	(selection)
    );
end
```

Data path

```verilog
always @(posedge clk)
begin
    if (!stall)
        dout_r		<= din;
end

assign dout = selection ? din : dout_r;
```



<img src="https://github.com/kuopinghsu/pipeutils/blob/master/images/bypass.svg" alt="bypass" width=480>

### Add bypass between two pipelined controls

<img src="https://github.com/kuopinghsu/pipeutils/blob/master/images/pipe_bypass.svg" alt="pipe_bypass" width=800>

### Extra timing path on ready_out and data path

<img src="https://github.com/kuopinghsu/pipeutils/blob/master/images/pipe_bypass_out.svg" alt="pipe_bypass_out" width=800>

## Pipeline multiplexer and demultiplex


pipeMux41:
```verilog
ready_out = ready_in1 & ready_in2 & ready_in3 & ready_in4;
valid_in1 = valid_out & ready_in2 & ready_in3 & ready_in4;
valid_in2 = valid_out & ready_in1 & ready_in3 & ready_in4;
valid_in3 = valid_out & ready_in1 & ready_in2 & ready_in4;
valid_in4 = valid_out & ready_in1 & ready_in2 & ready_in3;
```

pipeDeMux14:
```verilog
valid_in   = valid_out1 & valid_out2 & valid_out3 & valid_out4;
ready_out1 = ready_in & valid_out2 & valid_out3 & valid_out4;
ready_out2 = ready_in & valid_out1 & valid_out3 & valid_out4;
ready_out3 = ready_in & valid_out1 & valid_out2 & valid_out4;
ready_out4 = ready_in & valid_out1 & valid_out2 & valid_out3;
```

# Examples

## Multiplier-Adder



<img src="https://github.com/kuopinghsu/pipeutils/blob/master/images/mul_add.svg" alt="mul_add" width=640>



<img src="https://github.com/kuopinghsu/pipeutils/blob/master/images/mul_add2.svg" alt="mul_add2" width=640>

## Asynchronous FIFO

This is an example to make the registered input and output of asynchronous FIFO using pipeline control logic.



# License

LGPL license

