module TLS(clk, reset, Set, Stop, Jump, Gin, Yin, Rin, Gout, Yout, Rout);
input           clk;
input           reset;
input           Set;
input           Stop;
input           Jump;
input     [3:0] Gin;
input     [3:0] Yin;
input     [3:0] Rin;
output reg         Gout;
output reg         Yout;
output reg         Rout;

reg [1:0] state, next_state;
reg [1:0] state_g = 2'd0;
reg [1:0] state_y = 2'd1;
reg [1:0] state_r = 2'd2;
reg [3:0] g_duration, y_duration, r_duration, count, next_count;

//state register
always@(posedge clk) begin
  if (Set) begin
    next_count = 0;
    next_state = state_g;
    g_duration = Gin;
    y_duration  =Yin;
    r_duration = Rin;  
    count = next_count;
    state = next_state;
  end
  
  else if (Stop) begin
    //count = couint;
    //state = state;
  end
  
  else if (Jump) begin
    next_count = 0;
    next_state = state_r; 
    count = next_count;
    state = next_state;
  end
  
  else begin 
    count = next_count;
    state = next_state;
  end

end

/* cannot write at here since it will not wait for the clock, it should change in state register
//count
always@(*)begin
  count = next_count;
  state = next_state;
end
*/

//next state logic
always@(*) begin
  case(state)
    state_g: begin //green
      if (count == g_duration-1) begin
        next_state = state_y;
        next_count = 4'd0;
      end
      else begin
        next_state = state;
        next_count = count+4'd1;
      end
    end
    
    state_y: begin //yellow
      if (count == y_duration-1) begin
        next_state = state_r;
        next_count = 4'd0;
      end
      else begin
        next_state = state;
        next_count = count+4'd1;
      end
    end
    
    state_r: begin //red
      if (count == r_duration-1) begin
        next_state = state_g;
        next_count = 4'd0;
      end
      else begin
        next_state = state;
        next_count = count+4'd1;
      end
    end
  endcase 
end


//output logic
always@(state) begin
  case(state) 
    state_g: begin
      Gout = 1'b1; Yout = 1'b0; Rout = 1'b0;
    end
    
    state_y:begin
      Gout = 1'b0; Yout = 1'b1; Rout = 1'b0;
    end
    
    state_r:begin
      Gout = 1'b0; Yout =1'b0; Rout = 1'b1;
    end
  endcase
end      
  
  
endmodule