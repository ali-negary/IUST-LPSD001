****array multiplier design****
.include 'cmos_45nm.lib'

* transient analysis
.tran	0.1ns	100ns	1ns
.print power

* options to create files:
.options POST=2
.options AUTOSTOP
.options INGOLD=2

* design parameters
.global	Vddh
* .global	Vddl
.global	Vss

.param maxswing = 2v

Vground Vss 0 0V
Vsupplyh Vddh 0 maxswing
* Vsupplyl Vddl 0 maxswing


******* define required components *******

***** or gate
.subckt OR orin1 orin2 orout1
mp1 n2 orin1 Vddh Vddh pmos w=90n l=45n
mp2 n2 orin2 n3 n3 pmos w=90n l=45n

mn1 n3 orin2 Vss Vss nmos w=45n l=45n
mn2 n3 orin1 Vss Vss nmos w=45n l=45n

mp3 orout1 n3 Vddh Vddh pmos w=90n l=45n
mn3 orout1 n3 Vss Vss nmos w=45n l=45n

.ends 

***** and gate 
.subckt AND andin1 andin2 andout1
mp1 n2 andin1 Vddh Vddh pmos w=90n l=45n
mp2 n2 andin2 Vddh Vddh pmos w=90n l=45n

mn1 n2 andin2 n3 n3 nmos w=45n l=45n
mn2 n3 andin1 Vss Vss nmos w=45n l=45n

mp3 andout1 n2 Vddh Vddh pmos w=90n l=45n
mn3 andout1 n3 Vss Vss nmos w=45n l=45n

.ends 

***** 2 input Exor gate
.subckt ORX xorin1 xorin2 xorout1

mp1 n2 xorin1 Vddh Vddh pmos w=90n l=45n
mp2 xorout1 xorin2 xorin1 xorin1 pmos w=90n l=45n

mn1 n2 xorin1 Vss Vss nmos w=45n l=45n
mn2 xorout1 xorin2 n2 n2 nmos w=45n l=45n

.ends 


***** half adder
.subckt halfadder hain1 hain2 hasum1 hacarry1
* sum
Xorxha1 hain1 hain2 hasum1 ORX
* carry
Xandha1 hain1 hain2 hacarry1 AND

.ends

***** 3 input Exor gate using the 2 input exor gate
.subckt ORX3F2 xor3in1 xor3in2 xor3in3 xor3out1

Xor3f1 xor3in1 xor3in2 xortemp1 ORX
Xor3f2 xortemp1 xor3in3 xorout1 ORX

.ends

***** full adder
.subckt fulladder fain1 fain2 facin fasumout facarry_out

* sum
XOrexfa fain1 fain2 facin fasumout  ORX3F2

* carry
Xandfa0  fain1  fain2   fatemp0 AND
Xandfa1  fain1  facin   fatemp1 AND
Xandfa2  facin  fain2   fatemp2 AND

Xorfa0   fatemp0  fatemp1  fatemp3   OR
Xorfa1   fatemp2  fatemp3  facarry_out   OR

.ends


******* all the components are defined *******

******* ARRAY MULTIPLIER NETLIST BEGIN *******
.subckt AM88 A7 A6 A5 A4 A3 A2 A1 A0 B7 B6 B5 B4 B3 B2 B1 B0 outP15 outP14 outP13 outP12 outP11 outP10 outP9 outP8 outP7 outP6 outP5 outP4 outP3 outP2 outP0

******* create all instances of and gates *******

Xandgate00   A0   B0   outP0   AND
Xandgate01   A0   B1   andout01   AND
Xandgate02   A0   B2   andout02   AND
Xandgate03   A0   B3   andout03   AND
Xandgate04   A0   B4   andout04   AND
Xandgate05   A0   B5   andout05   AND
Xandgate06   A0   B6   andout06   AND
Xandgate07   A0   B7   andout07   AND
Xandgate10   A1   B0   andout10   AND
Xandgate11   A1   B1   andout11   AND
Xandgate12   A1   B2   andout12   AND
Xandgate13   A1   B3   andout13   AND
Xandgate14   A1   B4   andout14   AND
Xandgate15   A1   B5   andout15   AND
Xandgate16   A1   B6   andout16   AND
Xandgate17   A1   B7   andout17   AND
Xandgate20   A2   B0   andout20   AND
Xandgate21   A2   B1   andout21   AND
Xandgate22   A2   B2   andout22   AND
Xandgate23   A2   B3   andout23   AND
Xandgate24   A2   B4   andout24   AND
Xandgate25   A2   B5   andout25   AND
Xandgate26   A2   B6   andout26   AND
Xandgate27   A2   B7   andout27   AND
Xandgate30   A3   B0   andout30   AND
Xandgate31   A3   B1   andout31   AND
Xandgate32   A3   B2   andout32   AND
Xandgate33   A3   B3   andout33   AND
Xandgate34   A3   B4   andout34   AND
Xandgate35   A3   B5   andout35   AND
Xandgate36   A3   B6   andout36   AND
Xandgate37   A3   B7   andout37   AND
Xandgate40   A4   B0   andout40   AND
Xandgate41   A4   B1   andout41   AND
Xandgate42   A4   B2   andout42   AND
Xandgate43   A4   B3   andout43   AND
Xandgate44   A4   B4   andout44   AND
Xandgate45   A4   B5   andout45   AND
Xandgate46   A4   B6   andout46   AND
Xandgate47   A4   B7   andout47   AND
Xandgate50   A5   B0   andout50   AND
Xandgate51   A5   B1   andout51   AND
Xandgate52   A5   B2   andout52   AND
Xandgate53   A5   B3   andout53   AND
Xandgate54   A5   B4   andout54   AND
Xandgate55   A5   B5   andout55   AND
Xandgate56   A5   B6   andout56   AND
Xandgate57   A5   B7   andout57   AND
Xandgate60   A6   B0   andout60   AND
Xandgate61   A6   B1   andout61   AND
Xandgate62   A6   B2   andout62   AND
Xandgate63   A6   B3   andout63   AND
Xandgate64   A6   B4   andout64   AND
Xandgate65   A6   B5   andout65   AND
Xandgate66   A6   B6   andout66   AND
Xandgate67   A6   B7   andout67   AND
Xandgate70   A7   B0   andout70   AND
Xandgate71   A7   B1   andout71   AND
Xandgate72   A7   B2   andout72   AND
Xandgate73   A7   B3   andout73   AND
Xandgate74   A7   B4   andout74   AND
Xandgate75   A7   B5   andout75   AND
Xandgate76   A7   B6   andout76   AND
Xandgate77   A7   B7   andout77   AND

******* all the and gates are created *******

******* create all fulladders *******

**** first row ****
Xfulladder01   andout20   andout11   hacarry1   outfa01   facarry01   fulladder
Xfulladder02   andout30   andout21   outfa01   outfa02   facarry02   fulladder
Xfulladder03   andout40   andout31   outfa02   outfa03   facarry03   fulladder
Xfulladder04   andout50   andout41   outfa03   outfa04   facarry04   fulladder
Xfulladder05   andout60   andout51   outfa04   outfa05   facarry05   fulladder
Xfulladder06   andout70   andout61   outfa05   outfa06   facarry06   fulladder

**** next rows ****

** first columns **
Xfulladder11   outfa02   andout12   hacarry2   outfa11   facarry11   fulladder
Xfulladder21   outfa12   andout13   hacarry3   outfa21   facarry21   fulladder
Xfulladder31   outfa22   andout14   hacarry4   outfa31   facarry31   fulladder
Xfulladder41   outfa32   andout15   hacarry5   outfa41   facarry41   fulladder
Xfulladder51   outfa42   andout16   hacarry6   outfa51   facarry51   fulladder
Xfulladder61   outfa52   andout17   hacarry7   outP8   facarry61   fulladder

** fa16
Xfulladder16   facarry15   andout62   hacarry8   outfa16   facarry16   fulladder

** rest of them **
Xfulladder12   facarry11   outfa03   andout22   outfa12   facarry12   fulladder
Xfulladder13   facarry12   outfa04   andout32   outfa13   facarry13   fulladder
Xfulladder14   facarry13   outfa05   andout42   outfa14   facarry14   fulladder
Xfulladder15   facarry14   outfa06   andout52   outfa15   facarry15   fulladder

Xfulladder17   facarry16   outfa08   andout72   outfa17   facarry17   fulladder
Xfulladder22   facarry21   outfa13   andout23   outfa22   facarry22   fulladder
Xfulladder23   facarry22   outfa14   andout33   outfa23   facarry23   fulladder
Xfulladder24   facarry23   outfa15   andout43   outfa24   facarry24   fulladder
Xfulladder25   facarry24   outfa16   andout53   outfa25   facarry25   fulladder
Xfulladder26   facarry25   outfa17   andout63   outfa26   facarry26   fulladder
Xfulladder27   facarry26   outfa18   andout73   outfa27   facarry27   fulladder
Xfulladder32   facarry31   outfa23   andout24   outfa32   facarry32   fulladder
Xfulladder33   facarry32   outfa24   andout34   outfa33   facarry33   fulladder
Xfulladder34   facarry33   outfa25   andout44   outfa34   facarry34   fulladder
Xfulladder35   facarry34   outfa26   andout54   outfa35   facarry35   fulladder
Xfulladder36   facarry35   outfa27   andout64   outfa36   facarry36   fulladder
Xfulladder37   facarry36   outfa28   andout74   outfa37   facarry37   fulladder
Xfulladder42   facarry41   outfa33   andout25   outfa42   facarry42   fulladder
Xfulladder43   facarry42   outfa34   andout35   outfa43   facarry43   fulladder
Xfulladder44   facarry43   outfa35   andout45   outfa44   facarry44   fulladder
Xfulladder45   facarry44   outfa36   andout55   outfa45   facarry45   fulladder
Xfulladder46   facarry45   outfa37   andout65   outfa46   facarry46   fulladder
Xfulladder47   facarry46   outfa38   andout75   outfa47   facarry47   fulladder
Xfulladder52   facarry51   outfa43   andout26   outfa52   facarry52   fulladder
Xfulladder53   facarry52   outfa44   andout36   outfa53   facarry53   fulladder
Xfulladder54   facarry53   outfa45   andout46   outfa54   facarry54   fulladder
Xfulladder55   facarry54   outfa46   andout56   outfa55   facarry55   fulladder
Xfulladder56   facarry55   outfa47   andout66   outfa56   facarry56   fulladder
Xfulladder57   facarry56   outfa48   andout76   outfa57   facarry57   fulladder
Xfulladder62   facarry61   outfa53   andout27   outP9   facarry62   fulladder
Xfulladder63   facarry62   outfa54   andout37   outP10   facarry63   fulladder
Xfulladder64   facarry63   outfa55   andout47   outP11   facarry64   fulladder
Xfulladder65   facarry64   outfa56   andout57   outP12   facarry65   fulladder
Xfulladder66   facarry65   outfa57   andout67   outP13   facarry66   fulladder
Xfulladder67   facarry66   outfa58   andout77   outP14   outP15   fulladder

******* all the fulladders are created *******

******* create all halfadders *******

Xhalfadder1   andout01   andout10   outP1   hacarry1   halfadder
Xhalfadder2   andout02   outfa01   outP2   hacarry2   halfadder
Xhalfadder3   andout03   outfa11   outP3   hacarry3   halfadder
Xhalfadder4   andout04   outfa21   outP4   hacarry4   halfadder
Xhalfadder5   andout05   outfa31   outP5   hacarry5   halfadder
Xhalfadder6   andout06   outfa41   outP6   hacarry6   halfadder
Xhalfadder7   andout07   outfa51   outP7   hacarry7   halfadder
Xhalfadder8   andout71   facarry06   outha8   hacarry8   halfadder

******** all the halfadders are created *******

.ends
******* ARRAY MULTIPLIER NETLIST END *******


* prividing input sources

XAM88 XX7 XX6 XX5 XX4 XX3 XX2 XX1 XX0 YY7 YY6 YY5 YY4 YY3 YY2 YY1 YY0 ZZ15 ZZ14 ZZ13 ZZ12 ZZ11 ZZ10 ZZ9 ZZ8 ZZ7 ZZ6 ZZ5 ZZ4 ZZ3 ZZ2 ZZ0 AM88


VXX0   XX0   VSS pulse(0 maxswing 0 0.01ns 0.01ns 5ns 10ns)
VXX1   XX1   VSS pulse(maxswing maxswing 0 0.01ns 0.01ns 5ns 10ns)
VXX2   XX2   VSS pulse(maxswing maxswing 0 0.01ns 0.01ns 5ns 10ns)
VXX3   XX3   VSS pulse(maxswing maxswing 0 0.01ns 0.01ns 5ns 10ns)
VXX4   XX4   VSS pulse(maxswing 0 0 0.01ns 0.01ns 5ns 10ns)
VXX5   XX5   VSS pulse(maxswing maxswing 0 0.01ns 0.01ns 5ns 10ns)
VXX6   XX6   VSS pulse(0 maxswing 0 0.01ns 0.01ns 5ns 10ns)
VXX7   XX7   VSS pulse(maxswing maxswing 0 0.01ns 0.01ns 5ns 10ns)
*******************
VYY0   YY0   VSS pulse(maxswing maxswing 0 0.01ns 0.01ns 5ns 10ns)
VYY1   YY1   VSS pulse(maxswing maxswing 0 0.01ns 0.01ns 5ns 10ns)
VYY2   YY2   VSS pulse(maxswing maxswing 0 0.01ns 0.01ns 5ns 10ns)
VYY3   YY3   VSS pulse(maxswing maxswing 0 0.01ns 0.01ns 5ns 10ns)
VYY4   YY4   VSS pulse(maxswing 0 0 0.01ns 0.01ns 5ns 10ns)
VYY5   YY5   VSS pulse(0 maxswing 0 0.01ns 0.01ns 5ns 10ns)
VYY6   YY6   VSS pulse(0 maxswing 0 0.01ns 0.01ns 5ns 10ns)
VYY7   YY7   VSS pulse(0 maxswing 0 0.01ns 0.01ns 5ns 10ns)


.MEASURE average_power AVG power FROM=10n TO=30n
.MEASURE TRAN t_delay TRIG v(XX0) VAL=1 CROSS=1 TARG v(ZZ15) VAL=1.6 CROSS=1
.MEASURE t_rise TRIG v(ZZ7) VAL=0.4 RISE=1 TARG v(ZZ7) VAL=1 RISE=1


.end