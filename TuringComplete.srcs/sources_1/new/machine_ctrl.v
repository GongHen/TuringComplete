`timescale 1ns/1ns

//״̬���������ո�λ�ź�rst��rst��Ч���������enaΪ0��fetch��Ч����enaΪ1��
module machine_ctrl (
    input           clk     ,
    input           rst     ,
    input           fetch   ,//fetch��Ч����ȡrom�е�ָ��pc--addr
    output  reg     ena
);
    
    always @(posedge clk) begin
        if (rst) begin
            ena <= 1'b0 ; 
        end else if (fetch) begin
            ena <= 1'b1 ;//contr_ena,����ʹ��machineģ��
        end
    end

endmodule