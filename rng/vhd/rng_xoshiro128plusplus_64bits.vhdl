library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity rng_xoshiro128plusplus_64bits is
    generic (
        -- Default seed values.
        init_seed1:  std_logic_vector(127 downto 0);
        init_seed2:  std_logic_vector(127 downto 0));
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

architecture xoshiro128plusplus_64bits_arch of rng_xoshiro128plusplus_64bits is
-- Auxiliar signals
signal output_signal : std_logic_vector(63 downto 0);
signal out_valid1    : std_logic;
signal out_valid2    : std_logic;

-- Declaring RNG component
component rng_xoshiro128plusplus is
    generic (
        init_seed:  std_logic_vector(127 downto 0);
        pipeline:   boolean := true );
    port (
        clk:        in  std_logic;
        rst:        in  std_logic;
        reseed:     in  std_logic;
        newseed:    in  std_logic_vector(127 downto 0);
        out_ready:  in  std_logic;
        out_valid:  out std_logic;
        out_data:   out std_logic_vector(31 downto 0) );
end component;

begin
rng_u01  :      rng_xoshiro128plusplus
	GENERIC MAP(init_seed => init_seed1)
        PORT MAP(clk => clk, 
		 rst => rst,
		 reseed => '0',
		 newseed => (others=>'0'),
		 out_ready => out_ready,
		 out_valid => out_valid1,
		 out_data=>output_signal(31 downto 0));

rng_u02  :      rng_xoshiro128plusplus
	GENERIC MAP(init_seed => init_seed2)
        PORT MAP(clk => clk, 
		 rst => rst,
		 reseed => '0',
		 newseed => (others=>'0'),
		 out_ready => out_ready,
		 out_valid => out_valid2,
		 out_data=>output_signal(63 downto 32));

out_data <= output_signal;
out_valid <= out_valid1 and out_valid2;
end architecture;
