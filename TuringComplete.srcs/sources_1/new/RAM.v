`timescale 1ns/1ns

module ram (
    input                       ena         ,
    input                       read        ,
    input                       write       ,
    inout   wire    [7:0]       data        ,
    input           [9:0]       addr        
);
    reg [7:0] ram[10'h3ff : 0];

    assign data = (read && ena )? ram[addr]:8'hzz;//���ź�+ʹ���ź�
		
	always@(posedge write) begin
		ram[addr] <= data;//write�ź�ֱ��д
	end
	
endmodule
