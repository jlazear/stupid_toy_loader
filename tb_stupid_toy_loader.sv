`timescale 1ns/1ps

module testbench;

parameter period = 10;
parameter setup = 0.5;

logic clk, reset, load_enable;
logic [7:0] data;

logic nbclk, nbreset, nbload_enable;
logic [7:0] nbdata;

logic rreset, rload_enable;
logic [7:0] rdata;

logic sreset, sload_enable;
logic [7:0] sdata;

logic nbsreset, nbsload_enable;
logic [7:0] nbsdata;


stupid_toy_loader dut (clk, reset, data, load_enable);
stupid_toy_loader dutnb (nbclk, reset, data, load_enable);
stupid_toy_loader dutallnb (nbclk, nbreset, nbdata, nbload_enable);
stupid_toy_loader dutallnbbutclk (nbclk, nbreset, nbdata, nbload_enable);
stupid_toy_loader dutrealistic (clk, rreset, rdata, rload_enable);
stupid_toy_loader dutrealisticnb (nbclk, rreset, rdata, rload_enable);
stupid_toy_loader dutsync (clk, sreset, sdata, sload_enable);
stupid_toy_loader dutsyncnb (nbclk, nbsreset, nbsdata, nbsload_enable);



always #(period/2) clk = ~clk;
always #(period/2) nbclk <= ~nbclk; 

// blocking signals
initial begin
	reset = '0;
	data = '0;
	load_enable = '0;
	clk = '1;
	nbclk = '1;

	#10;
	reset = 1;
	#10;
	reset = 0;
	#5;

	data = 8'h3a;
	#5;
	load_enable = 1;
	#10;
	data = 8'hff;

	#20;
	reset = 1;
	load_enable = 0;
	data = 8'h3a;
	#15
	reset = 0;
	#10
	load_enable = 1;
	
	#10;
	data = 8'hff;
	#20;
	$stop;
end

// nonblocking signals
initial begin
	nbreset <= '0;
	nbdata <= '0;
	nbload_enable <= '0;
	nbclk <= '1;

	#10;
	nbreset <= 1;
	#10;
	nbreset <= 0;
	#5;

	nbdata <= 8'h3a;
	#5;
	nbload_enable <= 1;
	#10;
	nbdata <= 8'hff;

	#20;
	nbreset <= 1;
	nbload_enable <= 0;
	nbdata <= 8'h3a;
	#15
	nbreset <= 0;
	#10
	nbload_enable <= 1;
	
	#10;
	nbdata <= 8'hff;
	#20;
	$stop;
end

// realistic signals
initial begin
	rreset <= '0;
	rdata <= '0;
	rload_enable <= '0;

	#10;
	rreset <= 1;
	#10;
	rreset <= 0;
	#5;

	rdata <= 8'h3a;
	#(5-setup);
	rload_enable <= 1;
	#setup;
	#(10-setup);
	rdata <= 8'hff;
	#setup;

	#(20-setup);
	rreset <= 1;
	rload_enable <= 0;
	rdata <= 8'h3a;
	#setup;
	#(15-setup)
	rreset <= 0;
	#setup;
	#(10-setup);
	rload_enable <= 1;
	#setup;
	
	#(10-setup);
	rdata <= 8'hff;
	#setup;
	#20;
	$stop;
end

// synchronous signals
initial begin
	sreset <= '0;
	sdata <= '0;
	sload_enable <= '0;

	#10;
	@(posedge clk)
	sreset <= 1;
	#10;
	@(posedge clk)
	sreset <= 0;

	#5;
	@(posedge clk)
	sdata <= 8'h3a;
	#5;
	@(posedge clk)
	sload_enable <= 1;
	#10;
	@(posedge clk)
	sdata <= 8'hff;

	#20;
	@(posedge clk)
	sreset <= 1;
	sload_enable <= 0;
	sdata <= 8'h3a;
	#15;
	@(posedge clk)
	sreset <= 0;
	#10;
	@(posedge clk)	
	sload_enable <= 1;
	
	#10;
	@(posedge clk)	
	sdata <= 8'hff;

	#20;
	$stop;
end

// synchronous signals
initial begin
	nbsreset <= '0;
	nbsdata <= '0;
	nbsload_enable <= '0;

	#10;
	@(posedge nbclk)
	nbsreset <= 1;
	#10;
	@(posedge nbclk)
	nbsreset <= 0;

	#5;
	@(posedge nbclk)
	nbsdata <= 8'h3a;
	#5;
	@(posedge nbclk)
	nbsload_enable <= 1;
	#10;
	@(posedge nbclk)
	nbsdata <= 8'hff;

	#20;
	@(posedge nbclk)
	nbsreset <= 1;
	nbsload_enable <= 0;
	nbsdata <= 8'h3a;
	#15;
	@(posedge nbclk)
	nbsreset <= 0;
	#10;
	@(posedge nbclk)	
	nbsload_enable <= 1;
	
	#10;
	@(posedge nbclk)	
	nbsdata <= 8'hff;

	#20;
	$stop;
end

endmodule : testbench