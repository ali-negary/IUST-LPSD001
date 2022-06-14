****full adder design****
.include 'cmos_45nm.lib'

* transient analysis
.tran	0.1ns	100ns	1ns
.print power

* options to create files:
.options POST=2
.options AUTOSTOP
.options INGOLD=2 DCON=1

* design parameters
.global	Vddh
.global	Vddl
.global	Vss

.param maxswing = 5v

Vground Vss 0 0V
Vsupplyh Vddh 0 maxswing
Vsupplyl Vddl 0 maxswing


* or gate

.subckt OR in1 in2 orout1
mp1 n2 in1 Vddh Vddh pmos w=90n l=45n
mp2 n2 in2 n3 n3 pmos w=90n l=45n

mn1 n3 in2 Vss Vss nmos w=45n l=45n
mn2 n3 in1 Vss Vss nmos w=45n l=45n

mp3 orout1 n3 Vddh Vddh pmos w=90n l=45n
mn3 orout1 n3 Vss Vss nmos w=45n l=45n

.ends 

* and gate 

.subckt AND in1 in2 andout1
mp1 n2 in1 Vddh Vddh pmos w=90n l=45n
mp2 n2 in2 Vddh Vddh pmos w=90n l=45n

mn1 n2 in2 n3 n3 nmos w=45n l=45n
mn2 n3 in1 Vss Vss nmos w=45n l=45n

mp3 andout1 n2 Vddh Vddh pmos w=90n l=45n
mn3 andout1 n3 Vss Vss nmos w=45n l=45n

.ends 

** 2 input Exor gate
.subckt ORX in1 in2 xorout1

mp1 n2 in1 Vddh Vddh pmos w=90n l=45n
mp2 xorout1 in2 in1 in1 pmos w=90n l=45n

mn1 n2 in1 Vss Vss nmos w=45n l=45n
mn2 xorout1 in2 n2 n2 nmos w=45n l=45n

.ends 

* 3 input Exor gate using the 2 input exor gate

.subckt ORX3F2 in31 in32 in33 xorout31

Xor1 in31 in32 xortemp1 ORX
Xor2 xortemp1 in33 xorout31 ORX

.ends

* full adder

.subckt fulladder in7 in8 in9 sumout0 carry_out0

* sum
XOrex2 in7 in8 in9 sumout0  ORX3F2

* carry
Xand6  in7 in8 x4   AND
Xand7  x3  in9 x5   AND
Xor3   x4  x5  carry_out0   OR

.ends


* input sources

Xfa ina inb inc sumf carryf fulladder

Va ina Vss pulse(0 1 0 0.01ns 0.01ns 2n 4n)
Vb inb Vss 1v
Vc inc Vss 1v

.end