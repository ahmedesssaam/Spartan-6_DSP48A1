module DSP48A1 (A, B, C, D, CLK, CARRYIN, OPMODE, BCIN, RSTA, RSTB, RSTM, RSTP, RSTC, RSTD, RSTCARRYIN, RSTOPMODE, CEA, CEB, CEM, CEP, CEC, CED, CECARRYIN, COPMODE, PCIN, BCOUT, PCOUT, P, M, CARRYOUT, CARRYOUTF);

parameter WIDTH_A = 18;
parameter WIDTH_C = 48;
parameter WIDTH_OP = 8;
parameter WIDTH_M = 36;
parameter WIDTH_CARRY =  1;
parameter A0REG = 0;
parameter B0REG = 0;
parameter A1REG = 1;
parameter B1REG = 1;
parameter CREG = 1;
parameter DREG = 1;
parameter MREG = 1;
parameter PREG = 1; 
parameter CARRYINREG = 1;
parameter CARRYOUTREG = 1;
parameter OPMODEREG = 1;
parameter CARRYINSEL = "OPMODE5";
parameter B_INPUT = "DIRECT";
parameter RSTTYPE = "SYNC";

input [WIDTH_A-1:0] A, B, D, BCIN;
input [WIDTH_C-1:0] C, PCIN;
input [WIDTH_OP-1:0] OPMODE;
input CLK, CARRYIN, RSTA, RSTB, RSTM, RSTP, RSTC, RSTD, RSTCARRYIN, RSTOPMODE, CEA, CEB, CEM, CEP, CEC, CED, CECARRYIN, COPMODE;
output [17:0] BCOUT;
output [47:0] P;
output [47:0] PCOUT;
output [35:0] M;
output CARRYOUT; 
output CARRYOUTF;



wire [17:0] OUT_D, OUT_A0, OUT_A1, OUT_B0, OUT_B1;
wire [47:0] OUT_C;
wire [7:0] OUT_OPMODE;
wire [35:0] OUT_M;
wire OUT_CARRYIN;
reg [17:0] out_adder1, input_B1;
reg [35:0] multiplier_out;
reg [47:0] out_mux_x, out_mux_z;
reg [48:0] out_adder2;

generate
    if (RSTTYPE == "SYNC") begin
        D_mux_SYNC #(DREG, WIDTH_A) D (D, CLK, CED, RSTD, OUT_D);
        D_mux_SYNC #(A0REG, WIDTH_A) A0 (A, CLK, CEA, RSTA, OUT_A0);
        D_mux_SYNC #(CREG, WIDTH_C) C (C, CLK, CEC, RSTC, OUT_C);
        D_mux_SYNC #(OPMODEREG, WIDTH_OP) OP (OPMODE, CLK, COPMODE, RSTOPMODE, OUT_OPMODE);

        if (B_INPUT == "DIRECT") begin
            D_mux_SYNC #(B0REG, WIDTH_A) B0 (B, CLK, CEB, RSTB, OUT_B0);
        end
        else begin
            D_mux_SYNC #(B0REG, WIDTH_A) B0 (BCIN, CLK, CEB, RSTB, OUT_B0);
        end
    end
    else begin
        D_mux_ASYNC #(DREG, WIDTH_A) D (D, CLK, CED, RSTD, OUT_D);
        D_mux_ASYNC #(A0REG, WIDTH_A) A0 (A, CLK, CEA, RSTA, OUT_A0);
        D_mux_ASYNC #(CREG, WIDTH_C) C (C, CLK, CEC, RSTC, OUT_C);
        D_mux_ASYNC #(OPMODEREG, WIDTH_OP) OP (OPMODE, CLK, COPMODE, RSTOPMODE, OUT_OPMODE);


        if (B_INPUT == "DIRECT") begin
            D_mux_ASYNC #(B0REG, WIDTH_A) B0 (B, CLK, CEB, RSTB, OUT_B0);
        end
        else begin
            D_mux_ASYNC #(B0REG, WIDTH_A) B0 (BCIN, CLK, CEB, RSTB, OUT_B0);
        end
    end
endgenerate

always @(*) begin
    if (OUT_OPMODE[6]) begin
        out_adder1 = OUT_D - OUT_B0;
    end
    else begin
        out_adder1 = OUT_D + OUT_B0;
    end

    if (OUT_OPMODE[4]) begin
        input_B1 = out_adder1;
    end
    else begin
        input_B1 = OUT_B0;
    end
end

generate
    
    if (RSTTYPE == "SYNC") begin
        D_mux_SYNC #(B1REG, WIDTH_A) B1 (input_B1, CLK, CEB, RSTB, OUT_B1);
    end
    else begin
        D_mux_ASYNC #(B1REG, WIDTH_A) B1 (input_B1, CLK, CEB, RSTB, OUT_B1);
    end
   
      
    if (RSTTYPE == "SYNC") begin
        D_mux_SYNC #(A1REG, WIDTH_A) A1 (OUT_A0, CLK, CEA, RSTA, OUT_A1);
    end
    else begin
        D_mux_ASYNC #(A1REG, WIDTH_A) A1 (OUT_A0, CLK, CEA, RSTA, OUT_A1);
    end
endgenerate

assign BCOUT = OUT_B1;

always @(*) begin
    multiplier_out = OUT_B1 * OUT_A1;
end

generate
    if (RSTTYPE == "SYNC") begin
        D_mux_SYNC #(MREG, WIDTH_M) M (multiplier_out, CLK, CEM, RSTM, OUT_M);
    end
    else begin
        D_mux_ASYNC #(MREG, WIDTH_M) M (multiplier_out, CLK, CEM, RSTM, OUT_M);
    end
endgenerate

assign M = OUT_M;

generate
    if ( CARRYINSEL == "OPMODE5") begin
        if (RSTTYPE == "SYNC") begin
             D_mux_SYNC #(CARRYINREG, WIDTH_CARRY) CARRYIN (OPMODE[5], CLK, CECARRYIN, RSTCARRYIN, OUT_CARRYIN);
        end
        else begin
            D_mux_ASYNC #(CARRYINREG, WIDTH_CARRY) CARRYIN (OPMODE[5], CLK, CECARRYIN, RSTCARRYIN, OUT_CARRYIN);
        end
    end
    else begin
         if (RSTTYPE == "SYNC") begin
             D_mux_SYNC #(CARRYINREG, WIDTH_CARRY) CARRYIN (CARRYIN, CLK, CECARRYIN, RSTCARRYIN, OUT_CARRYIN);
        end
        else begin
            D_mux_ASYNC #(CARRYINREG, WIDTH_CARRY) CARRYIN (CARRYIN, CLK, CECARRYIN, RSTCARRYIN, OUT_CARRYIN);
        end
    end
endgenerate

always @(*) begin
    if (OUT_OPMODE[1:0] == 0) begin
        out_mux_x = 0;
    end
    else if (OUT_OPMODE[1:0] == 1) begin
        out_mux_x = OUT_M;
    end
    else if (OUT_OPMODE[1:0] == 2) begin
        out_mux_x = P;
    end
    else begin
         out_mux_x = {OUT_D[11:0], OUT_A0, OUT_B0};
    end

    if (OUT_OPMODE[3:2] == 0) begin
        out_mux_z = 0;
    end
    else if (OUT_OPMODE[3:2] == 1) begin
        out_mux_z = PCIN;
    end
    else if (OUT_OPMODE[3:2] == 2) begin
        out_mux_z = P;
    end
    else begin
        out_mux_z = OUT_C;
    end
end

always @(*) begin
    if (OUT_OPMODE[7]) begin
        out_adder2 = out_mux_z - (out_mux_x + OUT_CARRYIN);
    end
    else begin
        out_adder2 = out_mux_z + out_mux_x;
    end
end

generate
    if (RSTTYPE == "SYNC") begin
             D_mux_SYNC #(CARRYOUTREG, WIDTH_CARRY) CARRYOUT (out_adder2[48], CLK, CECARRYIN, RSTCARRYIN, CARRYOUT);
        end
        else begin
            D_mux_ASYNC #(CARRYOUTREG, WIDTH_CARRY) CARRYOUT (out_adder2[48], CLK, CECARRYIN, RSTCARRYIN, CARRYOUT);
        end

    if (RSTTYPE == "SYNC") begin
         D_mux_SYNC #(PREG, WIDTH_C) P (out_adder2[47:0], CLK, CEP, RSTP, P);
    end
    else begin
        D_mux_ASYNC #(PREG, WIDTH_C) P (out_adder2[47:0], CLK, CEP, RSTP, P);
    end
endgenerate

assign CARRYOUTF = CARRYOUT;
assign PCOUT = P;
endmodule

































       






