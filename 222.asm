DSEG SEGMENT;数据段
	STRING1 DB 1,2,3,4,5
	INPUTBUFF DB 0F0H ;预留字节数
			  DB ? ;实际字节数(不包含0x0D)
			  DB 0F0H DUP(?) ;实际输入内容(包含0x0D)
	OUTPUTBUFF DB 'Hello World!$'
DSEG  ENDS
ESEG  SEGMENT;附加段
   STRING2 DB 5 DUP(?)
ESEG  ENDS
SSEG SEGMENT;堆栈段
   DW 10 DUP(?)
SSEG  ENDS
CSEG  SEGMENT;代码段
		ASSUME  CS:CSEG,DS:DSEG;声明各段于段寄存器的关系
		ASSUME  ES:ESEG,SS:SSEG
DECADD	MACRO	OPR1,OPR2 ;定义实现BCD加法的宏
		MOV  AL,OPR1
		ADD  AL,OPR2
		DAA
		MOV OPR1,AL
ENDM
START:	MOV  AX,DSEG;设定数据段
		MOV  DS,AX
		MOV  AX,ESEG;设定附加段
		MOV  ES,AX
		MOV  AX,SSEG;设定堆栈段
		MOV  SS,AX
		
		MOV  AL,25 ;宏调用
		DECADD AL,38
		
		MOV AH,01H ;从键盘获得一个ASCII字符的输入，存储于AL中
		INT 21H
		
		MOV DL,AL ;向屏幕输出一个ASCII字符，位于DL中
		MOV AH,02H
		INT 21H
		
		LEA DX,INPUTBUFF ;从键盘获得一个ASCII字符串，存储于INPUTBUFF中
		MOV AH,0AH
		INT 21H

		LEA DX,OUTPUTBUFF ;向屏幕输出一个ASCII字符串，buffer位于DX中
		MOV AH,9H
		INT 21H

		MOV  AH,4CH;程序结束
		INT  21H
CSEG ENDS
END START