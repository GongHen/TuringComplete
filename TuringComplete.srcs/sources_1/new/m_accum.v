`timescale 1ns/1ns

//������ŵ�ǰ�Ľ�����ۼ���
//˫Ŀ����ʱ����data��������
module accum (
    input   clk     ,
    input   ena     ,//load_acc
    input   rst     ,
    input        [7:0]   data    ,//����Ϊalu_out������������������
    output  reg  [7:0]   accum
);
    
    always @(posedge clk ) begin
        if (rst) begin
            accum <= 8'h00      ;
        end else if (ena) begin
            accum <= data   ;//cpu�����źţ���߻�ȡ��������
        end 
    end 
endmodule