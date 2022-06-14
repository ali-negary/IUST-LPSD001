----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:43:55 01/20/2022 
-- Design Name: 
-- Module Name:    simple_multiplier - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity simple_multiplier is
    Port ( A : in  BIT_VECTOR(7 DOWNTO 0);
           B : in  BIT_VECTOR(7 DOWNTO 0);
           P : out  BIT_VECTOR(15 DOWNTO 0));
end simple_multiplier;

architecture Behavioral of simple_multiplier is
    
    signal C1, C2, C3, C4, C5, C6, C7: BIT_VECTOR(7 DOWNTO 0);
    signal S1, S2, S3, S4, S5, S6, S7: BIT_VECTOR(7 DOWNTO 0);
    signal AB0, AB1, AB2, AB3, AB4, AB5, AB6, AB7: BIT_VECTOR(7 DOWNTO 0);
    
    component FullAdder
    port(A,B,Cin: in BIT; Cout, Sum: out BIT);
    end component;

    component HalfAdder
    port(A,B: in BIT; Cout, Sum: out BIT);
    end component;

begin

    -- According to the inherited design, there will be 64 "and" gates,
    -- 8 Halfadders, and 48 Fulladders.
    -- calculate output of the "and" gates.
    -- ABi(j) <= A(j) and B(i)
    AB0(0) <= A(0) and B(0); AB1(0) <= A(0) and B(1);
    AB0(1) <= A(1) and B(0); AB1(1) <= A(1) and B(1);
    AB0(2) <= A(2) and B(0); AB1(2) <= A(2) and B(1);
    AB0(3) <= A(3) and B(0); AB1(3) <= A(3) and B(1);
    AB0(4) <= A(4) and B(0); AB1(4) <= A(4) and B(1);
    AB0(5) <= A(5) and B(0); AB1(5) <= A(5) and B(1);
    AB0(6) <= A(6) and B(0); AB1(6) <= A(6) and B(1);
    AB0(7) <= A(7) and B(0); AB1(7) <= A(7) and B(1);

    AB2(0) <= A(0) and B(2); AB3(0) <= A(0) and B(3);
    AB2(1) <= A(1) and B(2); AB3(1) <= A(1) and B(3);
    AB2(2) <= A(2) and B(2); AB3(2) <= A(2) and B(3);
    AB2(3) <= A(3) and B(2); AB3(3) <= A(3) and B(3);
    AB2(4) <= A(4) and B(2); AB3(4) <= A(4) and B(3);
    AB2(5) <= A(5) and B(2); AB3(5) <= A(5) and B(3);
    AB2(6) <= A(6) and B(2); AB3(6) <= A(6) and B(3);
    AB2(7) <= A(7) and B(2); AB3(7) <= A(7) and B(3);

    AB4(0) <= A(0) and B(4); AB5(0) <= A(0) and B(5);
    AB4(1) <= A(1) and B(4); AB5(1) <= A(1) and B(5);
    AB4(2) <= A(2) and B(4); AB5(2) <= A(2) and B(5);
    AB4(3) <= A(3) and B(4); AB5(3) <= A(3) and B(5);
    AB4(4) <= A(4) and B(4); AB5(4) <= A(4) and B(5);
    AB4(5) <= A(5) and B(4); AB5(5) <= A(5) and B(5);
    AB4(6) <= A(6) and B(4); AB5(6) <= A(6) and B(5);
    AB4(7) <= A(7) and B(4); AB5(7) <= A(7) and B(5);

    AB6(0) <= A(0) and B(6); AB7(0) <= A(0) and B(7);
    AB6(1) <= A(1) and B(6); AB7(1) <= A(1) and B(7);
    AB6(2) <= A(2) and B(6); AB7(2) <= A(2) and B(7);
    AB6(3) <= A(3) and B(6); AB7(3) <= A(3) and B(7);
    AB6(4) <= A(4) and B(6); AB7(4) <= A(4) and B(7);
    AB6(5) <= A(5) and B(6); AB7(5) <= A(5) and B(7);
    AB6(6) <= A(6) and B(6); AB7(6) <= A(6) and B(7);
    AB6(7) <= A(7) and B(6); AB7(7) <= A(7) and B(7);


    -- HalfAdders: input0, input1, carry-out, sum.
    -- row 1
    HA1: HalfAdder port map (AB0(1), AB1(0), C1(0), S1(0));
    HA2: HalfAdder port map (AB1(7), C1(6), C1(7), S1(7));
    
    -- row 2
    HA3: HalfAdder port map (S1(1), AB2(0), C2(0), S2(0));

    -- row 3
    HA4: HalfAdder port map (S2(1), AB3(0), C3(0), S3(0));

    -- row 4
    HA5: HalfAdder port map (S3(1), AB4(0), C4(0), S4(0));

    -- row 5
    HA6: HalfAdder port map (S4(1), AB5(0), C5(0), S5(0));

    -- row 6
    HA7: HalfAdder port map (S5(1), AB6(0), C6(0), S6(0));

    -- row 7
    HA8: HalfAdder port map (S6(1), AB7(0), C7(0), S7(0));


    -- Fulladders: input0, input1, carry-in, carry-out, sum.
    -- row 1 
    FA11: FullAdder port map (AB0(2), AB1(1), C1(0), C1(1), S1(1));
    FA12: FullAdder port map (AB0(3), AB1(2), C1(1), C1(2), S1(2));
    FA13: FullAdder port map (AB0(4), AB1(3), C1(2), C1(3), S1(3));
    FA14: FullAdder port map (AB0(5), AB1(4), C1(3), C1(4), S1(4));
    FA15: FullAdder port map (AB0(6), AB1(5), C1(4), C1(5), S1(5));
    FA16: FullAdder port map (AB0(7), AB1(6), C1(5), C1(6), S1(6));

    -- row 2
    FA21: FullAdder port map (AB2(1), S1(2), C2(0), C2(1), S2(1));
    FA22: FullAdder port map (AB2(2), S1(3), C2(1), C2(2), S2(2));
    FA23: FullAdder port map (AB2(3), S1(4), C2(2), C2(3), S2(3));
    FA24: FullAdder port map (AB2(4), S1(5), C2(3), C2(4), S2(4));
    FA25: FullAdder port map (AB2(5), S1(6), C2(4), C2(5), S2(5));
    FA26: FullAdder port map (AB2(6), S1(7), C2(5), C2(6), S2(6));
    FA27: FullAdder port map (AB2(7), C1(7), C2(6), C2(7), S2(7));

    -- row 3
    FA31: FullAdder port map (AB3(1), S2(2), C3(0), C3(1), S3(1));
    FA32: FullAdder port map (AB3(2), S2(3), C3(1), C3(2), S3(2));
    FA33: FullAdder port map (AB3(3), S2(4), C3(2), C3(3), S3(3));
    FA34: FullAdder port map (AB3(4), S2(5), C3(3), C3(4), S3(4));
    FA35: FullAdder port map (AB3(5), S2(6), C3(4), C3(5), S3(5));
    FA36: FullAdder port map (AB3(6), S2(7), C3(5), C3(6), S3(6));
    FA37: FullAdder port map (AB3(7), C2(7), C3(6), C3(7), S3(7));

    -- row 4
    FA41: FullAdder port map (AB4(1), S3(2), C4(0), C4(1), S4(1));
    FA42: FullAdder port map (AB4(2), S3(3), C4(1), C4(2), S4(2));
    FA43: FullAdder port map (AB4(3), S3(4), C4(2), C4(3), S4(3));
    FA44: FullAdder port map (AB4(4), S3(5), C4(3), C4(4), S4(4));
    FA45: FullAdder port map (AB4(5), S3(6), C4(4), C4(5), S4(5));
    FA46: FullAdder port map (AB4(6), S3(7), C4(5), C4(6), S4(6));
    FA47: FullAdder port map (AB4(7), C3(7), C4(6), C4(7), S4(7));

    -- row 5
    FA51: FullAdder port map (AB5(1), S4(2), C5(0), C5(1), S5(1));
    FA52: FullAdder port map (AB5(2), S4(3), C5(1), C5(2), S5(2));
    FA53: FullAdder port map (AB5(3), S4(4), C5(2), C5(3), S5(3));
    FA54: FullAdder port map (AB5(4), S4(5), C5(3), C5(4), S5(4));
    FA55: FullAdder port map (AB5(5), S4(6), C5(4), C5(5), S5(5));
    FA56: FullAdder port map (AB5(6), S4(7), C5(5), C5(6), S5(6));
    FA57: FullAdder port map (AB5(7), C4(7), C5(6), C5(7), S5(7));

    -- row 6
    FA61: FullAdder port map (AB6(1), S5(2), C6(0), C6(1), S6(1));
    FA62: FullAdder port map (AB6(2), S5(3), C6(1), C6(2), S6(2));
    FA63: FullAdder port map (AB6(3), S5(4), C6(2), C6(3), S6(3));
    FA64: FullAdder port map (AB6(4), S5(5), C6(3), C6(4), S6(4));
    FA65: FullAdder port map (AB6(5), S5(6), C6(4), C6(5), S6(5));
    FA66: FullAdder port map (AB6(6), S5(7), C6(5), C6(6), S6(6));
    FA67: FullAdder port map (AB6(7), C5(7), C6(6), C6(7), S6(7));

    -- row 7
    FA71: FullAdder port map (AB7(1), S6(2), C7(0), C7(1), S7(1));
    FA72: FullAdder port map (AB7(2), S6(3), C7(1), C7(2), S7(2));
    FA73: FullAdder port map (AB7(3), S6(4), C7(2), C7(3), S7(3));
    FA74: FullAdder port map (AB7(4), S6(5), C7(3), C7(4), S7(4));
    FA75: FullAdder port map (AB7(5), S6(6), C7(4), C7(5), S7(5));
    FA76: FullAdder port map (AB7(6), S6(7), C7(5), C7(6), S7(6));
    FA77: FullAdder port map (AB7(7), C6(7), C7(6), C7(7), S7(7));


    -- Output bits: 14 sum, 1 carry-out.
    P(0) <= AB0(0);
    P(1) <= S1(0); 
    P(2) <= S2(0);
    P(3) <= S3(0);
    P(4) <= S4(0);
    P(5) <= S5(0);
    P(6) <= S6(0);
    P(7) <= S7(0);
    P(8) <= S7(1);
    P(9) <= S7(2);
    P(10) <= S7(3);
    P(11) <= S7(4);
    P(12) <= S7(5);
    P(13) <= S7(6);
    P(14) <= S7(7);
    P(15) <= C7(7);
    
    

end Behavioral;

    entity FullAdder is 
    port(A, B, Cin: in BIT; Cout, Sum: out BIT);
    end FullAdder;
    architecture BehavioralFA of FullAdder is
        begin
            Sum <= A xor B xor Cin;
            Cout <= (A and B) or (A and Cin) or (B and Cin);   
        end BehavioralFA;
    
    entity HalfAdder is
    port(A, B: in BIT; Cout, Sum: out BIT);
    end HalfAdder;
    architecture BehavioralHA of HalfAdder is
        begin
            Sum <= A xor B;
            Cout <= A and B;
        end BehavioralHA;