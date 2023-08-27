# ALU
ALU is the fundamental building block of the processor,  which is responsible for carrying out different functions:
<br>- Arithmetic functions through ARITHMETIC_UNIT block.
<br>- Logic functions through LOGIC_UNIT block.
<br>- Shift functions through SHIFT _UNIT block.
<br>- Comparison functions through CMP_UNIT block. 
<br>And Decoder Unit responsibles for enable which Function to operate according to the highest Most significant 2-bit of the ALU_FUNC control bus ALU_FUNC [3:2].
<br>Test bench to test all the ALU functions with operating clock frequency 100 KHz with duty cycle 40% low and 60% high.

![WhatsApp Image 2023-08-27 at 20 31 44](https://github.com/BassantAhmedElbakry/ALU/assets/104600321/5d5a7f02-5eff-455c-abf6-9afe3b916f0f)

![WhatsApp Image 2023-08-27 at 20 50 50](https://github.com/BassantAhmedElbakry/ALU/assets/104600321/73fa44ee-1622-4763-bb8d-e413a59fa6a3)

# Specifications: -
<br>● All Outputs are registered. 
<br>● All registers are cleared using Asynchronous active low reset
<br>● Arith_flag is activated "High" only when ALU performs one of 
the arithmetic operations (Addition, Subtraction, Multiplication, 
division), otherwise "LOW"
<br>● Logic_flag is activated "High" only when ALU performs one of 
the Boolean operations (AND, OR, NAND, NOR), otherwise "LOW"
<br>● CMP_flag is activated "High" only when ALU performs one of 
the Comparison operations (Equal, Greater than, less than) or 
NOP, otherwise "LOW"
<br>● Shift_flag is activated "High" only when ALU performs one of 
the shifting operations (shift right, shift left), otherwise "LOW"
<br>● The ALU function is carried out according to the value of the 
ALU_FUN input signal stated in the following table


