`timescale 1ns/1ns

//����ѡ�������ַ��PC�������������ַ��������/�˿ڵ�ַ��
//ÿ��ָ�����ڵ�ǰ4��ʱ���������ڴ�ROM�ֶ�ȡָ��������PC��ַ��
//���ĸ�ʱ���������ڶ�RAM��˿ڶ�д��

module adr (
    input           fetch   ,//���ĸ�����Ϊ�ߵ�ƽ
    input [12:0]    ir_addr ,//ram���߶˿ڵ�ַ
    input [12:0]    pc_addr ,//ָ���ַrom��ַ
    output  [12:0]  addr    
);
    assign addr = fetch?pc_addr:ir_addr ;
endmodule