****3 input exor gate design****
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

.param maxswing = 2v

Vground Vss 0 0V
Vsupplyh Vddh 0 maxswing
Vsupplyl Vddl 0 maxswing

** 2 input Exor gate
.subckt ORX in1 in2 xorout1

* name drain gate source body model options

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

* input sources

Xor3 ina inb inc outf ORX3F2

Va ina Vss pulse(0 1 0 0.01ns 0.01ns 2n 4n)
Vb inb Vss 0v
Vc inc Vss 1v

.end