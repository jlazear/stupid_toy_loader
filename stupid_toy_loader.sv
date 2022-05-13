module stupid_toy_loader (
	input clk, 
	input reset,
	input [7:0] data,
	input load_enable
);

	enum {IDLE, WRITE} state, next_state;

	reg [7:0] _data;

	always_comb
		unique case (state)
			IDLE: next_state <= load_enable ? WRITE : IDLE;
			WRITE: next_state <= WRITE;
		endcase	

	always @(posedge clk)
		if (reset) 
			state <= IDLE;
		else 
			state <= next_state;

	always @(posedge clk) begin
		if (reset) begin
			_data <= '0;
		end else begin
			if ((state == IDLE) & load_enable)
				_data <= data;
		end

	end

endmodule