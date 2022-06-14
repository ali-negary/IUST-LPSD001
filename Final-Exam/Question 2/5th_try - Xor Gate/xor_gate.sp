****exor gate design****
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

* name drain gate source body model options

.subckt ORX in1 in2 xorout1
mp1 n2 in1 Vddh Vddh pmos w=90n l=45n
mp2 xorout1 in2 in1 in1 pmos w=90n l=45n

mn1 n2 in1 Vss Vss nmos w=45n l=45n
mn2 xorout1 in2 n2 n2 nmos w=45n l=45n

.ends 

* input sources

Xor1 ina inb outf ORX

Va ina Vss pulse(0 1 0 0.01ns 0.01ns 2n 4n)
Vb inb Vss 0v

.end