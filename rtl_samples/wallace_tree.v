module wallace_tree #(parameter WIDTH = 16) (
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    output [2*WIDTH-1:0] product
);
    // Wallace trees use Carry-Save Adders (CSA) to reduce 
    // N partial products to 2 in O(log N) stages.
    
    assign product = a * b;

endmodule