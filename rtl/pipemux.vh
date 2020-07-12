// Written by Kuoping Hsu, kuoping.hsu@gmail.com
// LGPL license

// pipeline demux 1 to 2
task pipeDeMux12;
    input           ready_in;
    output          valid_in;

    output          ready_out1;
    input           valid_out1;

    output          ready_out2;
    input           valid_out2;

begin
    valid_in        = valid_out1 && valid_out2;
    ready_out1      = ready_in && valid_out2;
    ready_out2      = ready_in && valid_out1;
end
endtask

// pipeline demux 1 to 3
task pipeDeMux12;
    input           ready_in;
    output          valid_in;

    output          ready_out1;
    input           valid_out1;

    output          ready_out2;
    input           valid_out2;

    output          ready_out3;
    input           valid_out3;
begin
    valid_in        = valid_out1 && valid_out2 && valid_out3;
    ready_out1      = ready_in && valid_out2 && valid_out3;
    ready_out2      = ready_in && valid_out1 && valid_out3;
    ready_out3      = ready_in && valid_out1 && valid_out2;
end
endtask

// pipeline demux 1 to 4
task pipeDeMux12;
    input           ready_in;
    output          valid_in;

    output          ready_out1;
    input           valid_out1;

    output          ready_out2;
    input           valid_out2;

    output          ready_out3;
    input           valid_out3;

    output          ready_out4;
    input           valid_out4;
begin
    valid_in        = valid_out1 && valid_out2 && valid_out3 && valid_out4;
    ready_out1      = ready_in && valid_out2 && valid_out3 && valid_out4;
    ready_out2      = ready_in && valid_out1 && valid_out3 && valid_out4;
    ready_out3      = ready_in && valid_out1 && valid_out2 && valid_out4;
    ready_out4      = ready_in && valid_out1 && valid_out2 && valid_out3;
end
endtask

// pipeline mux 2 to 1
task pipeMux21;
    input           ready_in1;
    output          valid_in1;

    input           ready_in2;
    output          valid_in2;

    output          ready_out;
    input           valid_out;
begin
    ready_out       = ready_in1 && ready_in2;
    valid_in1       = valid_out && ready_in2;
    valid_in2       = valid_out && ready_in1;
end
endtask

// pipeline mux 3 to 1
task pipeMux31;
    input           ready_in1;
    output          valid_in1;

    input           ready_in2;
    output          valid_in2;

    input           ready_in3;
    output          valid_in3;

    output          ready_out;
    input           valid_out;
begin
    ready_out       = ready_in1 && ready_in2 && ready_in3;
    valid_in1       = valid_out && ready_in2 && ready_in3;
    valid_in2       = valid_out && ready_in1 && ready_in3;
    valid_in3       = valid_out && ready_in1 && ready_in2;
end
endtask

// pipeline mux 4 to 1
task pipeMux41;
    input           ready_in1;
    output          valid_in1;

    input           ready_in2;
    output          valid_in2;

    input           ready_in3;
    output          valid_in3;

    input           ready_in4;
    output          valid_in4;

    output          ready_out;
    input           valid_out;
begin
    ready_out       = ready_in1 && ready_in2 && ready_in3 && ready_in4;
    valid_in1       = valid_out && ready_in2 && ready_in3 && ready_in4;
    valid_in2       = valid_out && ready_in1 && ready_in3 && ready_in4;
    valid_in3       = valid_out && ready_in1 && ready_in2 && ready_in4;
    valid_in4       = valid_out && ready_in1 && ready_in2 && ready_in3;
end
endtask

