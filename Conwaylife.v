/*  Solutions for HDLBits Problem Sets
    Conway's Game of Life
     Allain Rapadas

*/

module top_module
(
  	input   wire 					    clk,
    input 						        load,
    input   wire    [255:0] 			data,
    output  wire    [255:0] 		    q 
); 

    wire [255:0] next; 
    
    generate 
        genvar x, y;
        for(x = 0; x <= 15; x = x + 1) begin: x_dimension
            for(y = 0; y <= 15; y = y + 1) begin: y_dimension
                rule rule_inst
                (
                    .current(q[x + y*16]),
                    .neighbors
                    ({
                        // RIGHT NEIGHBOR
                        q[((x == 15) ? 0 : x+1) + y*16], 		
                        // LEFT NEIGHBOR
                        q[((x == 0) ? 15 : x-1) + y*16], 		
                        // BOTTOM NEIGHBOR
                        q[x + ((y == 15) ? 0 : (y+1)*16)], 		
                        // TOP NEIGHBOR
                        q[x + ((y == 0) ? 15*16 : (y-1)*16)], 	
                        // BOTTOM RIGHT NEIGHBOR
                        q[((x == 15) ? 0 : x+1) + ((y == 15) ? 0 : (y+1)*16)],
                        // BOTTOM LEFT NEIGHBOR
                        q[((x == 0) ? 15 : x-1) + ((y == 15) ? 0 : (y+1)*16)],
                        // TOP RIGHT NEIGHBOR
                        q[((x == 15) ? 0 : x+1) + ((y == 0) ? 15*16 : (y-1)*16)],
                        // TOP LEFT NEIGHBOR
                        q[((x == 0) ? 15 : x-1) + ((y == 0) ? 15*16 : (y-1)*16)],
                    }),
                    .next(next[x + y*16])
                );
            end
        end
    endgenerate
        
    
    always @(posedge clk) begin
        if(load) begin
          	q <= data;  
        end else begin        
      		q <= next;	   
        end
    end
    
endmodule

module rule
(
    input wire					current,
    input wire [7:0]	 		neighbors,
    
    output wire 				next
);
    
    wire [2:0] neighbor_count;
    always @(*) begin
        neighbor_count = 	neighbors[7] + 
        					neighbors[6] + 
        					neighbors[5] + 
                            neighbors[4] + 
                            neighbors[3] + 
                            neighbors[2] + 
                            neighbors[1] + 
                            neighbors[0];   
        
        case(neighbor_count)
        	2: 			next = current;    
        	3: 			next = 1;
            default: 	next = 0;
        endcase
    end
endmodule