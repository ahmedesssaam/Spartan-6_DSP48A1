module test_DSP48A1 ();
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
reg [WIDTH_A - 1:0] A, B, D, BCIN;
reg [WIDTH_C - 1:0] C, PCIN;
reg [WIDTH_OP - 1:0] OPMODE;
reg CLK, CARRYIN, RSTA, RSTB, RSTM, RSTP, RSTC, RSTD, RSTCARRYIN, RSTOPMODE, CEA, CEB, CEM, CEP, CEC, CED, CECARRYIN, COPMODE;
wire [17:0] BCOUT;
wire [47:0] PCOUT, P;
wire [35:0] M;
wire CARRYOUT, CARRYOUTF;

DSP48A1 #(WIDTH_A, WIDTH_C, WIDTH_OP, WIDTH_M, WIDTH_CARRY, A0REG, B0REG, A1REG, B1REG, CREG, DREG, MREG, PREG, CARRYINREG, CARRYOUTREG, OPMODEREG, CARRYINSEL, B_INPUT, RSTTYPE) DUT1 (A, B, C, D, CLK, CARRYIN, OPMODE, BCIN, RSTA, RSTB, RSTM, RSTP, RSTC, RSTD, RSTCARRYIN, RSTOPMODE, CEA, CEB, CEM, CEP, CEC, CED, CECARRYIN, COPMODE, PCIN, BCOUT, PCOUT, P, M, CARRYOUT, CARRYOUTF);

initial begin
    CLK=0;
    forever begin
        #1 CLK=~CLK;
    end
end

initial begin
    RSTA=1; 
    RSTB=1;
    RSTM=1; 
    RSTP=1;
    RSTC=1; 
    RSTD=1; 
    RSTCARRYIN=1; 
    RSTOPMODE=1;
    A=10;
    B=15;
    C=12;
    D=3;
    CARRYIN=0;
    OPMODE=8'b00110101;
    BCIN=100;
    CEA=1; 
    CEB=1; 
    CEM=1; 
    CEP=1; 
    CEC=1;
    CED=1; 
    CECARRYIN=1; 
    COPMODE=0;
    PCIN=40;

    repeat(10) begin
        @(negedge CLK);
    end

    RSTA=0; 
    RSTB=0;
    RSTM=0; 
    RSTP=0;
    RSTC=0; 
    RSTD=0; 
    RSTCARRYIN=0; 
    RSTOPMODE=0;
    COPMODE=1;
    
    

    repeat(10) begin
        @(negedge CLK);
    end

    OPMODE=8'b00111110;

    repeat(10) begin
        @(negedge CLK);
    end








    $stop;
end

endmodule