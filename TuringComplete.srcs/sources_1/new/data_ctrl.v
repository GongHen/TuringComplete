`timescale 1ns/1ns

//���ݿ������������ۼ���accum���������
module data_ctrl (
    input   [7:0]   data_in     ,//����Ϊalu_out������������������
    input           data_ena    ,
    output  [7:0]   data_out    
);
    assign  data_out = (data_ena)?data_in:8'bzzzz_zzzz  ;
endmodule