//Unitate aritmetico-logica pe 8 biti pentru operatiile de adunare,scadere,si,sau,sau exclusiv,not

//definirea celor 7 stari
`define S0 3'b000//Starea in care se introduce primul operand
`define S1 3'b001//Starea in care se introduce al doilea operand
`define S2 3'b010//Starea in care se introduce operatia
`define S3 3'b011//Starea in care se afiseaza rezultatul operatiei selectate
`define S4 3'b100//Starea in care se afiseaza transportul/imprumutul operatiilor aritmetice
`define S5 3'b101//Starea in care se afiseaza overflow-ul operatiilor aritmetice
`define S6 3'b110//Starea in care se afiseaza indicatorul de zero(atunci cand rezultatul operatiei este 0 indicatorul afiseaza 1)

module main(out,DIG1,DIG2,DIG3,DIG4,statenumber,in8,btn,gclk);//definirea modulului principal al programului
output[7:0] out;//iesire pe 8 leduri
reg	  [7:0] out;
reg   [2:0] state_nr;//retine starea in care se afla unitatea aritmetico-logica
output      DIG1,DIG2,DIG3,DIG4;//declararea iesirii pe 7 segmente
output[6:0] statenumber;//iesire pe 7 segmente
reg         DIG1,DIG2,DIG3,DIG4;
input       btn,gclk;//declararea butonului care schimba starea si a clock-ului placii
input [7:0] in8;//declararea intrarii pe 8 switch-uri
reg   [2:0] state,next_state;//declararea variabilelor care retin starile
reg         clk;//clock
reg   [7:0] A,B;//operanzi
wire  [7:0] Y;//rezultat operatie
reg   [2:0] Op;//operatie

ual ual1(Y,C,V,Z,A,B,Op);//instantiere modul ual

BCD7SEG B7(statenumber,state_nr);//instantiere modul BCD7SEG

initial//clock initial va fi 0
clk=1'b0;//

always @(posedge clk)//cat timp clk devine 1
state=next_state;//starea curenta devine starea urmatorea

always @(posedge gclk)//starea se schimba daca se apasa butonul btn
begin 
	if(btn==1'b1)
	clk=1'b1;
	else
	clk=1'b0;
end

always@(in8)//starea se schimba dupa variabila in8(intrare)
        case (state)//structura de tip case
            `S0:begin//starea 1
				A=in8;//operandul A retine valoarea introdusa de pe switch-uri	
				out=7'd0;//led-urile iesirii raman stinse
				state_nr=3'd0;//numarul starii
				DIG1=1'b0;//numarul starii pe 7 segmente aprins
				DIG2=1'b1;//numarul starii pe 7 segmente stins
				DIG3=1'b1;//numarul starii pe 7 segmente stins
				DIG4=1'b1;//numarul starii pe 7 segmente stins
				next_state=`S1;//starea urmatoare
				end
				
            `S1:begin//starea 2
				B=in8;//operandul B retine valoarea introdusa de pe switch-uri	
			    out=7'd0;//led-urile iesirii raman stinse
				state_nr=3'd1;//numarul starii
				DIG1=1'b0;//numarul starii pe 7 segmente aprins
				DIG2=1'b1;//numarul starii pe 7 segmente stins
				DIG3=1'b1;//numarul starii pe 7 segmente stins
				DIG4=1'b1;//numarul starii pe 7 segmente stins
				next_state=`S2;//starea urmatoare
				end
			`S2:begin
				Op=in8;//Op retine valoarea introdusa de pe switch-uri
				out=7'd0;//led-urile iesirii raman stinse
				state_nr=3'd2;//numarulstarii
				DIG1=1'b0;//numarul starii pe 7 segmente aprins
				DIG2=1'b1;//numarul starii pe 7 segmente stins
				DIG3=1'b1;//numarul starii pe 7 segmente stins
				DIG4=1'b1;//numarul starii pe 7 segmente stins
				next_state=`S3;//starea urmatoare
				end
			`S3:begin
				out=Y;//se afiseaza rezultatul operatiei alsese pe cele 8 led-uri
				state_nr=3'd3;//numarul starii
				DIG1=1'b0;//numarul starii pe 7 segmente aprins
				DIG2=1'b1;//numarul starii pe 7 segmente stins
				DIG3=1'b1;//numarul starii pe 7 segmente stins
				DIG4=1'b1;//numarul starii pe 7 segmente stins
				next_state=`S4;//starea urmatoare
				end
			`S4:begin
				out=C;//se afiseaza carry/borrow pe 1 led
				state_nr=3'd4;//numarul starii
				DIG1=1'b0;//numarul starii pe 7 segmente aprins
				DIG2=1'b1;//numarul starii pe 7 segmente stins
				DIG3=1'b1;//numarul starii pe 7 segmente stins
				DIG4=1'b1;//numarul starii pe 7 segmente stins
				next_state=`S5;//starea urmatoare
				end
			`S5:begin
				out=V;//se afiseaza overflow pe 1 led
				state_nr=3'd5;//numarul starii
				DIG1=1'b0;//numarul starii pe 7 segmente aprins
				DIG2=1'b1;//numarul starii pe 7 segmente stins
				DIG3=1'b1;//numarul starii pe 7 segmente stins
				DIG4=1'b1;//numarul starii pe 7 segmente stins
				next_state=`S6;//starea urmatoare
				end
			`S6:begin
				out=Z;//se afiseaza indicatorul de 0 pe 1 led
				state_nr=3'd6;//numarul starii
				DIG1=1'b0;//numarul starii pe 7 segmente aprins
				DIG2=1'b1;//numarul starii pe 7 segmente stins
				DIG3=1'b1;//numarul starii pe 7 segmente stins
				DIG4=1'b1;//numarul starii pe 7 segmente stins
				next_state=`S0;//starea urmatoare
				end
        endcase//incheiere structura de tip case
			
initial//definirea starii initiale
begin 
    state=`S0;
    next_state=`S0;
end

endmodule

module ual(Y, C,V, Z, A, B, Op);//unitatea aritmetico-logica pe 8 biti
   output[7:0]Y; //rezultat
   output C,V,Z;//indicatori de carry/borrow,overflow si zero  
   input [7:0]A,B; //operanzi
   input [2:0]Op; //operatie
   wire  [7:0]AS,And,Or,Xor,Not;//rezultatele modulelor individuale
   wire s; 
   wire Cr,Of;//carry/overflow temporar(deoarece carry si overflow 
			  //nu sunt valabile pentru operatiile logice)
   
   // Operatii
   sum8bit s8bit(AS, Cr,Of, A, B, Op[0]);// Op == 3'b000, 3'b001
   andop ual_and(And, A, B);             // Op == 3'b010
   orop ual_or(Or, A, B);                // Op == 3'b011
   xorop ual_xor(Xor, A, B);             // Op == 3'b100
   notop ual_not(Not, A);                // Op == 3'b101
   
   //multiplexor 8 la 1 care selecteaza operatia
   multiplexor81 mux81(Y, AS, AS, And, Or, Xor, Not, 8'b0, 8'b0, Op);
 
   nor(s, Op[1], Op[2]); //daca s=0 =>operatie logica,daca s=1 =>operatie aritmetica  
   and(C, Cr, s);//carry/borrow final
   and(V, Of, s);//overflow final         
   zero z(Z, Y); //indicator de zero(valabil tuturor functiilor)         
endmodule 

module andop(Y, A, B);//modul care calculeaza functia si logic
   output [7:0] Y; //rezultat 
   input [7:0]  A,B; //operanzi  
   and(Y[0], A[0], B[0]);
   and(Y[1], A[1], B[1]);
   and(Y[2], A[2], B[2]);
   and(Y[3], A[3], B[3]);
   and(Y[4], A[4], B[4]);
   and(Y[5], A[5], B[5]);
   and(Y[6], A[6], B[6]);
   and(Y[7], A[7], B[7]);
endmodule 

module orop(Y, A, B);//modul care calculeaza functia sau logic
   output [7:0] Y;//rezultat
   input  [7:0] A,B;//operanzi
   or(Y[0], A[0], B[0]);
   or(Y[1], A[1], B[1]);
   or(Y[2], A[2], B[2]);
   or(Y[3], A[3], B[3]);
   or(Y[4], A[4], B[4]);
   or(Y[5], A[5], B[5]);
   or(Y[6], A[6], B[6]);
   or(Y[7], A[7], B[7]);
endmodule 

module xorop(Y, A, B);//modul care calculeaza functia sau exclusiv
   output [7:0] Y;//rezultat 
   input  [7:0] A,B;//operanzi
   xor(Y[0], A[0], B[0]);
   xor(Y[1], A[1], B[1]);
   xor(Y[2], A[2], B[2]);
   xor(Y[3], A[3], B[3]);
   xor(Y[4], A[4], B[4]);
   xor(Y[5], A[5], B[5]);
   xor(Y[6], A[6], B[6]);
   xor(Y[7], A[7], B[7]);
endmodule 

module notop(Y, A);//modul care calculeaza functia nu logic
   output [7:0] Y;//rezultat 
   input [7:0]  A;//operand 
   not(Y[0], A[0]);
   not(Y[1], A[1]);
   not(Y[2], A[2]);
   not(Y[3], A[3]);
   not(Y[4], A[4]);
   not(Y[5], A[5]);
   not(Y[6], A[6]);
   not(Y[7], A[7]);
endmodule 

module sum8bit(S, C,V, A, B, Op);//sumator/scazator pe 8 biti
   output[7:0]S;//suma/diferenta
   output 	  C,V;//indicatori de carry/borrow si overflow   
   input [7:0]A,B;//operanzi  
   input 	  Op; //operatie(adunare/scadere,0/1) 
   
   wire C0,C1,C2,C3,C4,C5,C6,C7;
   wire B0,B1,B2,B3,B4,B5,B6,B7;

   xor(B0, B[0], Op);
   xor(B1, B[1], Op);
   xor(B2, B[2], Op);
   xor(B3, B[3], Op);
   xor(B4, B[4], Op);
   xor(B5, B[5], Op);
   xor(B6, B[6], Op);
   xor(B7, B[7], Op);
   xor(C, C7, Op); //calcul carry/borrow
   xor(V, C7, C6); //calcul overflow  
      
   //se folosesc 8 instante ale unui sumator pe 1 bit
   sum1bit s0(S[0], C0, A[0], B0, Op);    
   sum1bit s1(S[1], C1, A[1], B1, C0);
   sum1bit s2(S[2], C2, A[2], B2, C1);
   sum1bit s3(S[3], C3, A[3], B3, C2);
   sum1bit s4(S[4], C4, A[4], B4, C3);    
   sum1bit s5(S[5], C5, A[5], B5, C4);
   sum1bit s6(S[6], C6, A[6], B6, C5);
   sum1bit s7(S[7], C7, A[7], B7, C6);
   
endmodule 


module sum1bit(S, Cout, A, B, Cin);//sumator pe 1 bit
   output S;//rezultat
   output Cout;//carry out 
   input  A,B;//operanzi
   input  Cin;//carry in
   
   wire w1,w2,w3,w4;
  
   xor(w1, A, B);
   xor(S, Cin, w1);
   and(w2, A, B);   
   and(w3, A, Cin);
   and(w4, B, Cin);   
   or(Cout, w2, w3, w4);
   
endmodule 

module zero(Z, A);//modul care calculeaza indicatorul de zero
   output Z;//rezultat(0 sau 1)       
   input [7:0]  A;//operand
   wire  [7:0] 	Y;//variabila care mentine valoare lui xnor(A,0) 
   xnor(Y[0], A[0], 0);
   xnor(Y[1], A[1], 0);
   xnor(Y[2], A[2], 0);
   xnor(Y[3], A[3], 0);
   xnor(Y[4], A[4], 0);
   xnor(Y[5], A[5], 0);
   xnor(Y[6], A[6], 0);
   xnor(Y[7], A[7], 0);
   and(Z,Y[0],Y[1],Y[2],Y[3],Y[4],Y[5],Y[6],Y[7]);//calcularea efectiva a indicatorului de zero
endmodule 

 
module multiplexor8_1(X,A0,A1,A2,A3,A4,A5,A6,A7,S);//multiplexor 8 la 1
output[7:0]X;//iesirea multiplexorului
input[7:0]A0,A1,A2,A3,A4,A5,A6,A7;//intrarile multiplexorului
input[2:0]S;//intrarea de selectie a multiplexorului
reg X;
always @(S or A0 or A1 or A2 or A3 or A4 or A5 or A6 or A7 )
	case({S})
		3'd0:X=A0;//adunare
		3'd1:X=A1;//scadere
		3'd2:X=A2;//and
		3'd3:X=A3;//or
		3'd4:X=A4;//xor
		3'd5:X=A5;//not
		3'd6:X=A6;//operatie nedefinita,iesirea multiplexorului va fi 0
		3'd7:X=A7;//operatie nedefinita,iesirea multiplexorului va fi 0
		default:$display("Semnal de selectie invalid!");
	endcase
endmodule
/*
module multiplexor81(X, A0, A1, A2, A3, A4, A5, A6, A7, S);
   output [7:0] X;   
   input [7:0]  A0,A1,A2,A3,A4,A5,A6,A7;  
   input [2:0]	      S;   

   assign X = (S[2] == 0 
	       ? (S[1] == 0 
		  ? (S[0] == 0 
		     ? A0      
		     : A1)      
		  : (S[0] == 0 
		     ? A2       
		     : A3))     
	       : (S[1] == 0 
		  ? (S[0] == 0 
		     ? A4       
		     : A5)      
		  : (S[0] == 0 
		     ? A6       
		     : A7)));   
endmodule 
*/

module BCD7SEG(out7,BCD);//decodificator pentru afisarea pe 7 segmente
    input[2:0] BCD;//intrare pe 3 biti
    output[6:0]out7;//iesire pe 7 biti
    reg[6:0]out7;
    always@(BCD)
    case (BCD)
    3'b000:out7=7'b0001000;//va afisa A 
    3'b001:out7=7'b1100000;//va afisa B 
    3'b010:out7=7'b0000001;//va afisa O 
    3'b011:out7=7'b1110110;//va afisa = 
	3'b100:out7=7'b0110001;//va afisa C 
	3'b101:out7=7'b1100010;//va afisa o
	3'b110:out7=7'b0010010;//va afisa Z
    default:out7=7'b1111111;//toate segmentele stinse
    endcase 
endmodule


