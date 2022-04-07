module TLS(clk, reset, Set, Stop, Jump, Gin, Yin, Rin, Gout, Yout, Rout);
input           clk;
input           reset;
input           Set;
input           Stop;
input           Jump;
input     [3:0] Gin;
input     [3:0] Yin;
input     [3:0] Rin;
output reg      Gout;
output reg      Yout;
output reg      Rout;

reg [3:0] count,next_count;
reg change;
reg [1:0] state,next_state;
reg [3:0] G_duration,Y_duration,R_duration;

//next state logic
always @(*) begin
  case (state)
    2'd0: begin
      
    end
    
    2'd1:begin //G
      if (count == G_duration-4'd1) begin
        next_state = state + 2'd1;// G to Y
        next_count = 4'd0;
      end
    
      else begin
        next_state = state;
        next_count = count + 4'd1;
      end
    end
    
    2'd2:begin //Y
      if (count == Y_duration-4'd1) begin
        next_state = state + 2'd1;//Y to R
        next_count = 4'd0;
      end
      else begin
        next_state = state;
        next_count = count + 4'd1;
      end
    end
    
    2'd3:begin //R
      if (count == R_duration-4'd1) begin
        next_state = 2'd1;
        next_count = 4'd0;
      end
      else begin
        next_state = state;
        next_count = count + 4'd1;
      end
    end
  endcase
end
  
//output logic
always@(state) begin
  Gout = 1'b0; 
  Yout = 1'b0; 
  Rout = 1'b0;
  case(state)
    2'd1: begin //G
      Gout = 1'b1; 
    end
    
    2'd2:begin //Y
      Yout = 1'b1; 
    end
    
    2'd3:begin //R
      Rout = 1'b1;
    end
  endcase
end 

//state register
always@(posedge clk) begin
  if (Set) begin
    next_state = 2'd1; //Green
    next_count = 4'd0; //zero
    state = next_state;
    count = next_count;
    G_duration = Gin; //get value
    Y_duration = Yin;
    R_duration = Rin;
  end
  
  else if (reset) begin
    next_state = 2'd1; //green
    next_count = 4'd0; //zero
    state = next_state;
    count = next_count;
  end
  
  else if (Jump) begin
    next_state = 2'd3; //red
    next_count = 4'd0; 
    state = next_state;
    count = next_count;
  end
  
  else if (Stop) begin
    //state, count stays the same(stop)
  end
    
  else begin
    state = next_state;
    count = next_count;
  end

end
  

endmodule