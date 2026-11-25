module megabytebeat(
  input wire clk,
  input wire reset,
  input wire [15:0] _params_r,
  input wire _params_r_vld,
  input wire _pcm_s_rdy,
  output wire _params_r_rdy,
  output wire [39:0] _pcm_s,
  output wire _pcm_s_vld
);
  function automatic [31:0] umod_32b (input reg [31:0] lhs, input reg [31:0] rhs);
    begin
      umod_32b = rhs == 32'h0000_0000 ? 32'h0000_0000 : lhs % rhs;
    end
  endfunction
  // lint_off MULTIPLY
  function automatic [7:0] umul8b_8b_x_4b (input reg [7:0] lhs, input reg [3:0] rhs);
    begin
      umul8b_8b_x_4b = lhs * rhs;
    end
  endfunction
  // lint_on MULTIPLY
  // lint_off MULTIPLY
  function automatic [7:0] umul8b_8b_x_8b (input reg [7:0] lhs, input reg [7:0] rhs);
    begin
      umul8b_8b_x_8b = lhs * rhs;
    end
  endfunction
  // lint_on MULTIPLY
  reg [31:0] ____t;
  wire [3:0] b;
  wire [3:0] a;
  wire [7:0] ab__2;
  wire [7:0] lit_1_squeezed;
  wire [7:0] cd__2;
  wire [7:0] cd__4;
  wire [23:0] ab__4_squeezed_const_msb_bits;
  wire [7:0] ab__4_squeezed;
  wire [7:0] add_522;
  wire cd__3;
  wire [31:0] shrl_524;
  wire [31:0] shrl_525;
  wire [3:0] d;
  wire [31:0] shrl_527;
  wire [31:0] ab__4;
  wire [31:0] cd_257__1;
  wire [3:0] c;
  wire [31:0] shrl_536;
  wire [31:0] umod_540;
  wire [31:0] umod_541;
  wire [3:0] cond0__2;
  wire [31:0] p1;
  wire [31:0] p0;
  wire [7:0] umul_546;
  wire [7:0] umul_547;
  wire [7:0] umul_559;
  wire [7:0] umul_566;
  wire [7:0] s__1;
  wire [7:0] s__2;
  wire [7:0] s__3;
  wire [7:0] s__4;
  wire [31:0] add_571;
  wire p0_stage_done;
  wire [7:0] pcm[0:4];
  assign b = _params_r[7:4];
  assign a = _params_r[3:0];
  assign ab__2 = _params_r[7:0];
  assign lit_1_squeezed = 8'h01;
  assign cd__2 = {1'h0, _params_r[15:9]};
  assign cd__4 = _params_r[15:8];
  assign ab__4_squeezed_const_msb_bits = 24'h00_0000;
  assign ab__4_squeezed = b == 4'h0 & a == 4'h0 ? lit_1_squeezed : ab__2;
  assign add_522 = cd__2 + lit_1_squeezed;
  assign cd__3 = _params_r[8];
  assign shrl_524 = ____t >> a;
  assign shrl_525 = ____t >> b;
  assign d = _params_r[15:12];
  assign shrl_527 = cd__4 >= 8'h20 ? 32'h0000_0000 : ____t >> cd__4;
  assign ab__4 = {ab__4_squeezed_const_msb_bits, ab__4_squeezed};
  assign cd_257__1 = {23'h00_0000, add_522, cd__3};
  assign c = _params_r[11:8];
  assign shrl_536 = ____t >> d;
  assign umod_540 = umod_32b(____t, ab__4);
  assign umod_541 = umod_32b(____t, cd_257__1);
  assign cond0__2 = shrl_524[3:0] & b;
  assign p1 = -____t >> d;
  assign p0 = ____t >> c;
  assign umul_546 = umul8b_8b_x_4b(____t[7:0], a);
  assign umul_547 = umul8b_8b_x_4b(____t[7:0], c);
  assign umul_559 = umul8b_8b_x_8b(____t[7:0], shrl_524[7:0] | shrl_525[7:0]);
  assign umul_566 = umul8b_8b_x_8b(____t[7:0], ab__2 & shrl_527[7:0]);
  assign s__1 = ____t[7:0] | umod_540[7:0] | umod_541[7:0];
  assign s__2 = cond0__2 != 4'h0 ? p0[7:0] : p1[7:0];
  assign s__3 = umul_559 & cd__4;
  assign s__4 = umul_546 & shrl_525[7:0] | umul_547 & shrl_536[7:0];
  assign add_571 = ____t + 32'h0000_0001;
  assign p0_stage_done = _params_r_vld & _pcm_s_rdy;
  assign pcm[0] = umul_566;
  assign pcm[1] = s__1;
  assign pcm[2] = s__2;
  assign pcm[3] = s__3;
  assign pcm[4] = s__4;
  always @ (posedge clk) begin
    if (reset) begin
      ____t <= 32'h0000_0000;
    end else begin
      ____t <= p0_stage_done ? add_571 : ____t;
    end
  end
  assign _params_r_rdy = p0_stage_done;
  assign _pcm_s = {pcm[4], pcm[3], pcm[2], pcm[1], pcm[0]};
  assign _pcm_s_vld = _params_r_vld;
endmodule
