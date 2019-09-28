	PRESERVE8							; 8-битное выравнивание стека
	THUMB								; Режим Thumb (AUL) инструкций

	GET	config.s						; include-файлы
	GET	stm32f10x.s	

	AREA RESET, CODE, READONLY

	; Таблица векторов прерываний
	DCD STACK_TOP						; Указатель на вершину стека
	DCD Reset_Handler					; Вектор сброса	

	ENTRY								; Точка входа в программу

Reset_Handler	PROC					; Вектор сброса
	EXPORT  Reset_Handler				; Делаем Reset_Handler видимым вне этого файла

main									; Основная подпрограмма
	MOV32	R0, PERIPH_BB_BASE + \
			RCC_APB2ENR * 32 + \
			4 * 4						; вычисляем адрес для BitBanding 4-го бита регистра RCC_APB2ENR
										; BitAddress = BitBandBase + (RegAddr * 32) + BitNumber * 4
	MOV		R1, #1						; включаем тактирование порта D (в 5-й бит RCC_APB2ENR пишем '1`)
	STR 	R1, [R0]					; загружаем это значение
	
	MOV32	R0, GPIOC_CRH				; адрес порта
	MOV		R1, #0x03					; 4-битная маска настроек для Output mode 50mHz, Push-Pull ("0011")
	LDR		R2, [R0]					; считать порт
    BFI		R2, R1, #0, #4    			; скопировать биты маски в позицию PIN8
    STR		R2, [R0]					; загрузить результат в регистр настройки порта
	LDR		R3, =POWER_VAL				; длительность включения
	LDR		R4, =POWER_VAL				; длительность выключения
	MOV		R5, #0						; Флаг декремента

loop									; Бесконечный цикл
    MOV32	R0, GPIOC_BSRR				; адрес порта выходных сигналов
	
	CMP		R5, #0
	IT		EQ
	BLEQ	on_true
	
	CMP		R5, #0
	IT		NE
	BLNE	on_false	
	

	MOV 	R1, #(PIN8)					; устанавливаем вывод в '1'
	STR 	R1, [R0]					; загружаем в порт
	
	MOV		R7, R3
	BL		delay						; задержка
	
	MOV		R1, #(PIN8 << 16)			; сбрасываем в '0'
	STR 	R1, [R0]					; загружаем в порт
	
	MOV		R7, R4	
	BL		delay						; задержка

	B 		loop						; возвращаемся к началу цикла
	
	ENDP

on_true	PROC
	ADD		R3, #DIFF_VAL 
	SUBS	R4, #DIFF_VAL
	CMP		R4, #DIFF_VAL
	IT 		EQ
	MOVEQ	R5, #1	
	BX		LR							; выход из подпрограммы (переход к адресу в регистре LR - вершина стека)	
	ENDP
	
on_false	PROC
	ADD		R4, #DIFF_VAL 
	SUBS	R3, #DIFF_VAL
	CMP		R3, #DIFF_VAL
	IT 		EQ
	MOVEQ	R5, #0	
	BX		LR							; выход из подпрограммы (переход к адресу в регистре LR - вершина стека)
	ENDP
	

delay		PROC
delay_loop								; Подпрограмма задержки
	SUBS	R7, #1						; SUB с установкой флагов результата
	IT 		NE
	BNE		delay_loop					; переход, если Z==0 (результат вычитания не равен нулю)
	BX		LR							; выход из подпрограммы (переход к адресу в регистре LR - вершина стека)
	ENDP
	
    END
