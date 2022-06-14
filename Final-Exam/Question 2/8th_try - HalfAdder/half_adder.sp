****half adder design****
.include 'cmos_45nm.lib'

* transient analysis
.tran	0.1ns	50ns	1ns
.print power

* options to create files:
.options POST=2
.options AUTOSTOP
.options INGOLD=2 DCON=1

* design parameters
.global	Vddh
.global	Vddl
.global	Vss

.param maxswing = 3v

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


* half adder

.subckt halfadder in5 in6 sum1 carry1
* sum
Xorx1 in5 in6 sum1 ORX
* carry
Xand1 in5 in6 carry1 AND

.ends


* input sources

Xha ina inb sumf carryf halfadder

Va ina Vss pulse(0 1 0 0.01ns 0.01ns 2n 4n)
Vb inb Vss 1v

.end