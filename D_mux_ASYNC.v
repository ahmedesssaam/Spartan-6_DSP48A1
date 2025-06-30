module D_mux_ASYNC (D, clk, clk_en, rst, out);

parameter PARAM_REG = 0;
parameter WIDTH  = 18;
input [WIDTH-1:0] D;
input clk, clk_en, rst;
output reg [WIDTH-1:0] out;
reg [WIDTH-1:0] D_reg;


always @ (posedge clk or posedge rst) begin
    if (rst) begin
        D_reg <= 0;
    end
    else begin
        if (clk_en)
        D_reg <= D;
    end
end
always @(*) begin
    
    if (PARAM_REG) begin
        out = D_reg;
    end
    else begin
        out = D;
    end
end
endmodule



