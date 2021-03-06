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
        state		<= 1'b0;
    else
        state		<= state_nxt;
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
        dout		<= din
end
```

<img src="https://github.com/kuopinghsu/pipeutils/blob/master/images/pipeline.svg" alt="pipeline" width=320>

Verilog 
```verilog
assign valid_in     = valid_out || !ready_out;
assign stall        = !(ready_in && valid_in);

always @(posedge clk or negedge resetn)
begin
    if (!resetn)
        ready_out   <= 1'b0;
    else
        ready_out   <= ready_in && !valid_in;
end
```

### Timing issue on valid signal
<img src="https://github.com/kuopinghsu/pipeutils/blob/master/images/pipe_back2back.svg" alt="back2back" width=640>

## bypass

Include the pipeline task.

```verilog
`include "pipeline.vh"
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

<img src="https://github.com/kuopinghsu/pipeutils/blob/master/images/bypass.svg" alt="bypass" width=320>

Verilog expression
```verilog
assign valid_in     = !select;
assign stall        = !(ready_in && valid_in);
assign ready_out    = select || ready_in;

always @(posedge clk or negedge resetn)
begin
    if (!resetn)
        select      <= 1'b0;
    else
        select      <= !(valid_out || !(select || ready_in));
end
```

### Add bypass between two pipelined controls

<img src="https://github.com/kuopinghsu/pipeutils/blob/master/images/pipe_bypass.svg" alt="pipe_bypass" width=320>

### Extra timing path on ready_out and data path

<img src="https://github.com/kuopinghsu/pipeutils/blob/master/images/pipe_bypass_out.svg" alt="pipe_bypass_out" width=480>

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

### Using pipeline

<img src="https://github.com/kuopinghsu/pipeutils/blob/master/images/mul_add.svg" alt="mul_add" width=480>

### Using bypass

<img src="https://github.com/kuopinghsu/pipeutils/blob/master/images/mul_add2.svg" alt="mul_add2" width=480>

## Data read

This is an example to show the data request.

<img src="https://github.com/kuopinghsu/pipeutils/blob/master/images/datareq.svg" alt="datareq" width=800>

### Address path

1. address generator
2. address arbitor 
3. pipeline demutiplexor
4. address request

### Data path

1. data respond
2. pipeline multiplexor
3. data dispatcher

## Asynchronous FIFO

This is an example to make the registered input and output of asynchronous FIFO using pipeline control logic.



# License

LGPL license
