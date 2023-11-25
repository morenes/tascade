input [15:0] dest_x;
input [15:0] dest_y;
input [1:0] input_port;
reg [15:0] id_x;
reg [15:0] id_y;

// === ADDED LOGIC ===
reg proxy_enabled_r;
reg [3:0] proxy_mask_x_r = 8'b0111;
reg [3:0] proxy_mask_y_r = 8'b0111;
reg [3:0] id_x_within_proxy_r = id_x & proxy_mask_x_r;
reg [3:0] id_y_within_proxy_r = id_y & proxy_mask_y_r;

// Whether N,S,E,W buffers were full last cycle and proxy_enabled_r
reg [1:0] port_buffer_full_r;
// Whether the input queue of the PU was less than half full last cycle
reg PU_IQ_lt_half_full_r; 

// Two AND and two OR gates
wire opposite_port_full = port_buffer_full_r[input_port];
// + OR gate
wire select = PU_IQ_lt_half_full_r || opposite_port_full;

wire is_proxy_x = (dest_x[3:0] & proxy_mask_x_r) == id_x_within_proxy_r;
wire is_proxy_y = (dest_y[3:0] & proxy_mask_y_r) == id_y_within_proxy_r;
// AND + 4-bit comparison + AND
wire is_proxy = is_proxy_x && is_proxy_y;
// + AND (given the select has better or equal timing than is_proxy)
wire go_to_proxy = is_proxy && select;
// === END ADDED LOGIC ===

// 16-bit comparison (~4-bit comp + AND + AND)
wire is_dest_x = (dest_x == id_x)
wire is_dest_y = (dest_y == id_y);
// + AND
wire is_dest = is_dest_x && is_dest_y;

// Adding an OR gate to the critical path of is_dest
wire route_to_core = go_to_proxy || is_dest;



/// CLEANED UP PSEUDOCODE v1

input [15:0] dest_x, dest_y;
input [1:0] input_port;
reg [15:0] id_x, id_y; // Existing TILE ID

// Proxy Configuration Registers
reg proxy_enabled_r; // To enable/disable usage of proxy regions
reg [3:0] proxy_mask_x_r, proxy_mask_y_r; // e.g., 8'b0111 for 16x16 region

// Whether the opposite-facing port from the inputs N,S,E,W has its
// buffer full last cycle, and proxy_enabled_r is true
reg [1:0] port_buffer_full_r;
// Whether the input queue of the PU was less than half full last cycle
reg PU_IQ_lt_half_full_r; // It also includes proxy_enabled_r
wire select = PU_IQ_lt_half_full_r || opposite_port_buffer_full_r[input_port];

reg [3:0] id_x_within_proxy_r = id_x & proxy_mask_x_r; // Using a flipflip
reg [3:0] id_y_within_proxy_r = id_y & proxy_mask_y_r; // to improve timing
wire is_proxy_x = (dest_x[3:0] & proxy_mask_x_r) == id_x_within_proxy_r;
wire is_proxy_y = (dest_y[3:0] & proxy_mask_y_r) == id_y_within_proxy_r;
wire is_proxy = is_proxy_x && is_proxy_y;
wire go_to_proxy = is_proxy && select; // is a proxy and it is selected

wire is_dest_x = (dest_x == id_x); // Existing logic in the router
wire is_dest_y = (dest_y == id_y);
wire is_dest = is_dest_x && is_dest_y;
// Adding an OR gate to the critical path of is_dest
wire route_to_core = go_to_proxy || is_dest;




/// CLEANED UP PSEUDOCODE v2

input [15:0] dest_x, dest_y;
input [1:0] input_port; // N,S,E,W
reg [15:0] id_x, id_y; // Existing TILE ID

// Proxy Configuration Registers
reg proxy_enabled_r; // To enable/disable usage of proxy regions
reg [3:0] proxy_mask_x_r, proxy_mask_y_r; // e.g., 8'b0111 for 16x16 region

// Whether the opposite-facing port from the inputs N,S,E,W has its
// buffer full last cycle, and proxy_enabled_r is true
reg [1:0] port_buffer_full_r;
// Whether the input queue of the PU was less than half full last cycle
reg PU_IQ_lt_half_full_r; // It also includes proxy_enabled_r
wire select = PU_IQ_lt_half_full_r || opposite_port_buffer_full_r[input_port];

reg [3:0] id_x_within_proxy_r = id_x & proxy_mask_x_r; // Using a flipflip
reg [3:0] id_y_within_proxy_r = id_y & proxy_mask_y_r; // to improve timing
wire is_proxy_x = (dest_x[3:0] & proxy_mask_x_r) == id_x_within_proxy_r;
wire is_proxy_y = (dest_y[3:0] & proxy_mask_y_r) == id_y_within_proxy_r;
wire go_to_proxy = is_proxy_x && is_proxy_y && select;

wire is_dest_x = (dest_x == id_x); // Existing logic in the router
wire is_dest_y = (dest_y == id_y);
wire is_dest = is_dest_x && is_dest_y;
// Adding an OR gate to the critical path of is_dest
wire route_to_core = go_to_proxy || is_dest;