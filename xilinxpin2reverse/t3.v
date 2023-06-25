`timescale 1ns / 1ps
`include "define.vh"

module t3

(
    `ifdef CLK_IS_DIFF
    input  clk_p,
    input  clk_n,
`else
    input clk,
    `endif     
    output reg [`N_PINS-1:0] data
);
`ifdef CLK_IS_DIFF
   wire clk;
   IBUFDS #(
      .DIFF_TERM("TRUE"),       // Differential Termination
      .IBUF_LOW_PWR("TRUE"),     // Low power="TRUE", Highest performance="FALSE" 
      .IOSTANDARD("DEFAULT")     // Specify the input I/O standard
   ) IBUFDS_inst (
      .O(clk),  // Buffer output
      .I(clk_p),  // Diff_p buffer input (connect directly to top-level port)
      .IB(clk_n) // Diff_n buffer input (connect directly to top-level port)
   );
 `endif
    reg [45:0] mem [0:`N_PINS-1];
    initial begin
      `include "mem_init.vh"
    end
    reg [11:0] c_div=12'h0;
    reg baud_en;
    always @(posedge clk)begin
        c_div<=c_div-1'b1;
        if(c_div==12'h0) 
            c_div <= 12'd `BAUD_DIV;
        baud_en <= (c_div==12'h0);
    end

   
    reg [`N_PINS_WIDTH-1:0]  c_addr=9'h0;
    reg [`N_PINS_WIDTH-1:0]  c_addr_r;
    reg [5:0]  c_bit_shift=6'h0;
    reg [45:0] reg_out;
    reg [45:0] rom_out;
     always @(posedge clk)begin
        rom_out<=mem[c_addr];
        if(baud_en)begin
            c_bit_shift<=c_bit_shift-1'b1;
            if(c_bit_shift==6'h0)begin
                c_addr  <= c_addr+1'b1;
                reg_out <= rom_out;
                c_addr_r <= c_addr;
            end else begin
                reg_out <= {1'b1,reg_out[45:1]};
            end
        end
     end

     reg [`N_PINS-1:0] output_sel;
     genvar g;
     generate
        for (g=0;g<`N_PINS;g=g+1)begin:g0
     always@(posedge clk)begin
        output_sel[g] <= (c_addr_r==g[`N_PINS_WIDTH-1:0]);
        data[g] <= (~output_sel[g])|reg_out[0];
     end
    end
    endgenerate
    
endmodule

