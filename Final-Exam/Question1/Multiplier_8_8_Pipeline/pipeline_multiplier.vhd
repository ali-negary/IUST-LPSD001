----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:50:51 01/21/2022 
-- Design Name: 
-- Module Name:    pipeline_multiplier - rtl_shift_and_add 
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
library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pipeline_8x8 is
port ( 
  i_clk      : in  std_logic;
  i_rstb     : in  std_logic;
  i_ma       : in  std_logic_vector(7 downto 0);
  i_mb       : in  std_logic_vector(7 downto 0);
  o_m        : out std_logic_vector(15 downto 0));
end pipeline_8x8;

architecture pipe1 of pipeline_8x8 is

-- the architecture implements the following calculation:
-- (A[7:4] x B[3:0] + A[3:0] x B[7:4] )x2^4 + A[3:0] x B[3:0]

type p_operand is array(0 to 3) of signed(3 downto 0);
signal p_ma_hi       : p_operand; -- msb bits of the ma register
signal p_ma_lo       : p_operand; -- lsb bits of the ma register
signal p_mb_hi       : p_operand; -- msb bits of the mb register
signal p_mb_lo       : p_operand; -- lsb bits of the mb register

signal r_p1          : signed(9 downto 0);  -- 5x5 => 10 bit (8 + 2 sgn bit)
signal r_p2          : signed(8 downto 0);  -- 4x5 => 9 bit (8 + 1 sgn bit)
signal r_p3          : signed(8 downto 0);  -- 4x5 => 9 bit (8 + 1 sgn bit)
signal r_p4          : signed(7 downto 0);  -- 4x4 => 8 bit

signal r_m1          : signed(9 downto 0);  -- 5x5 => 10 bit (8 + 2 sgn bit)
signal r_m2          : signed(8 downto 0);  -- 4x5 => 9 bit (8 + 1 sgn bit)
signal r_m3          : signed(8 downto 0);  -- 4x5 => 9 bit (8 + 1 sgn bit)
signal r_m4          : signed(7 downto 0);  -- 4x4 => 8 bit

-- next two signals apply the delay of the pipeline
signal p_m1          : p_operand;
signal p_m3          : signed(3 downto 0);

begin

-- next 3 lines will be the output of m.
o_m(15 downto 8)  <= std_logic_vector(r_m4(7 downto 0));
o_m(7 downto  4)  <= std_logic_vector(p_m3);
o_m(3 downto  0)  <= std_logic_vector(p_m1(2)); -- this might need change

multiplication_steps : process(i_clk,i_rstb)
begin
    if(i_rstb='0') then
        p_ma_hi       <= (others=>(others=>'0'));
        p_ma_lo       <= (others=>(others=>'0'));
        p_mb_hi       <= (others=>(others=>'0'));
        p_mb_lo       <= (others=>(others=>'0'));
        p_m1          <= (others=>(others=>'0'));
        p_m3          <= (others=>'0');

        r_m1          <= (others=>'0');
        r_m2          <= (others=>'0');
        r_m3          <= (others=>'0');
        r_m4          <= (others=>'0');
        p_m1          <= (others=>(others=>'0'));
        p_m3          <= (others=>'0');

    elsif(rising_edge(i_clk)) then
        p_ma_hi       <= signed(i_ma(7 downto 4)) & p_ma_hi(0 to p_ma_hi'length-2);
        p_ma_lo       <= signed(i_ma(3 downto 0)) & p_ma_lo(0 to p_ma_lo'length-2);
        p_mb_hi       <= signed(i_mb(7 downto 4)) & p_mb_hi(0 to p_mb_hi'length-2);
        p_mb_lo       <= signed(i_mb(3 downto 0)) & p_mb_lo(0 to p_mb_lo'length-2);
        p_m1          <= r_m1(3 downto 0)&p_m1(0 to p_m1'length-2);
        p_m3          <= r_m3(3 downto 0);

        r_p1          <= signed('0'&p_ma_lo(0)) * signed('0'&p_mb_lo(0));
        r_p2          <= signed('0'&p_ma_lo(1)) * p_mb_hi(1);
        r_p3          <= p_ma_hi(2) * signed('0'&p_mb_lo(2)); -- this might need change
        r_p4          <= p_ma_hi(3) * p_mb_hi(3); -- this might need change

        r_m1          <= r_p1;
        r_m2          <= r_p2 + r_m1(8 downto 4);
        r_m3          <= r_p3 + r_m2;
        r_m4          <= r_p4 + r_m3(8 downto 4);
    end if;
end process multiplication_steps;

end pipe1;