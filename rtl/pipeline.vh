// pipeline control
task pipeline;

    // state machine
    input               state;
    output              state_nxt;

    // input
    input               ready_in;
    output              valid_in;

    // output
    output              ready_out;
    input               valid_out;
    output              stall;

begin
    case (state)
        1'b0: begin // IDLE
            ready_out   = 1'b0;
            valid_in    = 1'b1;
            stall       = ~ready_in;
            state_nxt   = ready_in ? 1'b1 : 1'b0;
        end

        default: begin // READY
            ready_out   = 1'b1;
            valid_in    = valid_out;
            statll      = !(ready_in && valid_out);
            state_nxt   = (!ready_in && valid_out) ? 1'b0 : 1'b1;
        end
    endcase
end
endtask;

// pipeline bypass
task bypass;
    // state machine
    input               state;
    output              state_nxt;

    // input
    input               ready_in;
    output              valid_in;

    // output
    output              ready_out;
    input               valid_out;
    output              stall;
    output              selection;  // 0: data bypass, 1: pipelined

begin
    case (state)
        1'b0: begin // IDLE
            ready_out   = ready_in;
            valid_in    = 1'b1;
            stall       = !ready_in;
            selection   = 1'b0;
            state_nxt   = (ready_in && !valid_out) ? 1'b1 : 1'b0;
        end

        default: begin // READY
            ready_out   = 1'b1;
            valid_in    = 1'b0;
            stall       = 1'b1;
            selection   = 1'b1;
            state_nxt   = valid_out ? 1'b0 : 1'b1;
        end
    endcase
end
endtask

