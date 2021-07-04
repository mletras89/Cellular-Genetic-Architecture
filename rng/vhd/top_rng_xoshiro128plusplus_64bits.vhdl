library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
    port (
        -- Clock, rising edge active.
        clk:        in  std_logic;
        -- Synchronous reset, active high.
        rst:        in  std_logic;
        -- High when the user accepts the current random data word
        -- and requests new random data for the next clock cycle.
        out_ready:  in  std_logic;
        -- High when valid random data is available on the output.
        -- This signal is low for 1 or 2 clock cycles after reset and
        -- after re-seeding, and high in all other cases.
        out_valid:  out std_logic;
        -- Random output data (valid when out_valid = '1').
        -- A new random word appears after every rising clock edge
        -- where out_ready = '1'.
        out_data:   out std_logic_vector(63 downto 0) );
end entity;

architecture top_arch of top is
component rng_xoshiro128plusplus_64bits is
    generic (
        init_seed1:  std_logic_vector(127 downto 0);
        init_seed2:  std_logic_vector(127 downto 0));
    port (
        clk:        in  std_logic;
        rst:        in  std_logic;
        out_ready:  in  std_logic;
        out_valid:  out std_logic;
        out_data:   out std_logic_vector(63 downto 0) );
end component;
begin

top_u : rng_xoshiro128plusplus_64bits
        GENERIC MAP(
                    init_seed1 => x"0123456789abcdef3141592653589793",
                    init_seed2 => x"0123456789abcdef3141592653589793")
        PORT MAP(
                    clk => clk,
                    rst => rst,
                    out_ready => out_ready,
                    out_valid => out_valid,
                    out_data => out_data);

end architecture;
