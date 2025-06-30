module test_D_mux();
parameter PARAM_REG = 0;
parameter WIDTH  = 18;
reg [WIDTH-1:0] D;
reg clk, clk_en, rst;
wire [WIDTH-1:0] out;

D_mux_SYNC #(PARAM_REG, WIDTH) DUT1 (D, clk, clk_en, rst, out);

initial begin
    clk=0;
    forever begin
        #1 clk=~clk;
    end
end


initial begin
    rst = 1;
    clk_en = 1;
    D = 30;

    repeat(10) begin
        @(negedge clk);
    end

    rst = 0;

    repeat(10) begin
        @(negedge clk);
    end
    $stop;
end
endmodule
