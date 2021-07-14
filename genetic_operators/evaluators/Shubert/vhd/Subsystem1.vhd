-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc/Shubert/Subsystem1.vhd
-- Created: 2021-07-14 22:59:16
-- 
-- Generated by MATLAB 9.6 and HDL Coder 3.14
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: Subsystem1
-- Source Path: Shubert/Approximation/Subsystem1
-- Hierarchy Level: 1
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.Approximation_pkg.ALL;

ENTITY Subsystem1 IS
  PORT( In1                               :   IN    std_logic_vector(15 DOWNTO 0);  -- sfix16_En12
        Out1                              :   OUT   std_logic_vector(15 DOWNTO 0)  -- sfix16_En10
        );
END Subsystem1;


ARCHITECTURE rtl OF Subsystem1 IS

  -- Constants
  CONSTANT LUT_data                       : vector_of_signed16(0 TO 60) := 
    (to_signed(16#3F70#, 16), to_signed(16#1B26#, 16), to_signed(-16#221A#, 16), to_signed(-16#3FFF#, 16),
     to_signed(-16#230E#, 16), to_signed(16#1A1E#, 16), to_signed(16#3F47#, 16), to_signed(16#2A43#, 16),
     to_signed(-16#119C#, 16), to_signed(-16#3D4A#, 16), to_signed(-16#309F#, 16), to_signed(16#08C0#, 16),
     to_signed(16#3A14#, 16), to_signed(16#3602#, 16), to_signed(16#0049#, 16), to_signed(-16#35B3#, 16),
     to_signed(-16#3A50#, 16), to_signed(-16#0950#, 16), to_signed(16#3040#, 16), to_signed(16#3D73#, 16),
     to_signed(16#1228#, 16), to_signed(-16#29D5#, 16), to_signed(-16#3F5C#, 16), to_signed(-16#1AA2#, 16),
     to_signed(16#2294#, 16), to_signed(16#4000#, 16), to_signed(16#2294#, 16), to_signed(-16#1AA2#, 16),
     to_signed(-16#3F5C#, 16), to_signed(-16#29D5#, 16), to_signed(16#1228#, 16), to_signed(16#3D73#, 16),
     to_signed(16#3040#, 16), to_signed(-16#0950#, 16), to_signed(-16#3A50#, 16), to_signed(-16#35B3#, 16),
     to_signed(16#0049#, 16), to_signed(16#3602#, 16), to_signed(16#3A14#, 16), to_signed(16#08C0#, 16),
     to_signed(-16#309F#, 16), to_signed(-16#3D4A#, 16), to_signed(-16#119C#, 16), to_signed(16#2A43#, 16),
     to_signed(16#3F47#, 16), to_signed(16#1A1E#, 16), to_signed(-16#230E#, 16), to_signed(-16#3FFF#, 16),
     to_signed(-16#221A#, 16), to_signed(16#1B26#, 16), to_signed(16#3F70#, 16), to_signed(16#2967#, 16),
     to_signed(-16#12B2#, 16), to_signed(-16#3D9B#, 16), to_signed(-16#2FE0#, 16), to_signed(16#09DF#, 16),
     to_signed(16#3A8B#, 16), to_signed(16#3564#, 16), to_signed(-16#00DA#, 16), to_signed(-16#364F#, 16),
     to_signed(-16#39D6#, 16));  -- sfix16 [61]
  CONSTANT LUT3_data                      : vector_of_signed16(0 TO 60) := 
    (to_signed(16#3F70#, 16), to_signed(16#1B26#, 16), to_signed(-16#221A#, 16), to_signed(-16#3FFF#, 16),
     to_signed(-16#230E#, 16), to_signed(16#1A1E#, 16), to_signed(16#3F47#, 16), to_signed(16#2A43#, 16),
     to_signed(-16#119C#, 16), to_signed(-16#3D4A#, 16), to_signed(-16#309F#, 16), to_signed(16#08C0#, 16),
     to_signed(16#3A14#, 16), to_signed(16#3602#, 16), to_signed(16#0049#, 16), to_signed(-16#35B3#, 16),
     to_signed(-16#3A50#, 16), to_signed(-16#0950#, 16), to_signed(16#3040#, 16), to_signed(16#3D73#, 16),
     to_signed(16#1228#, 16), to_signed(-16#29D5#, 16), to_signed(-16#3F5C#, 16), to_signed(-16#1AA2#, 16),
     to_signed(16#2294#, 16), to_signed(16#4000#, 16), to_signed(16#2294#, 16), to_signed(-16#1AA2#, 16),
     to_signed(-16#3F5C#, 16), to_signed(-16#29D5#, 16), to_signed(16#1228#, 16), to_signed(16#3D73#, 16),
     to_signed(16#3040#, 16), to_signed(-16#0950#, 16), to_signed(-16#3A50#, 16), to_signed(-16#35B3#, 16),
     to_signed(16#0049#, 16), to_signed(16#3602#, 16), to_signed(16#3A14#, 16), to_signed(16#08C0#, 16),
     to_signed(-16#309F#, 16), to_signed(-16#3D4A#, 16), to_signed(-16#119C#, 16), to_signed(16#2A43#, 16),
     to_signed(16#3F47#, 16), to_signed(16#1A1E#, 16), to_signed(-16#230E#, 16), to_signed(-16#3FFF#, 16),
     to_signed(-16#221A#, 16), to_signed(16#1B26#, 16), to_signed(16#3F70#, 16), to_signed(16#2967#, 16),
     to_signed(-16#12B2#, 16), to_signed(-16#3D9B#, 16), to_signed(-16#2FE0#, 16), to_signed(16#09DF#, 16),
     to_signed(16#3A8B#, 16), to_signed(16#3564#, 16), to_signed(-16#00DA#, 16), to_signed(-16#364F#, 16),
     to_signed(-16#39D6#, 16));  -- sfix16 [61]
  CONSTANT LUT1_data                      : vector_of_signed16(0 TO 60) := 
    (to_signed(16#3F70#, 16), to_signed(16#1B26#, 16), to_signed(-16#221A#, 16), to_signed(-16#3FFF#, 16),
     to_signed(-16#230E#, 16), to_signed(16#1A1E#, 16), to_signed(16#3F47#, 16), to_signed(16#2A43#, 16),
     to_signed(-16#119C#, 16), to_signed(-16#3D4A#, 16), to_signed(-16#309F#, 16), to_signed(16#08C0#, 16),
     to_signed(16#3A14#, 16), to_signed(16#3602#, 16), to_signed(16#0049#, 16), to_signed(-16#35B3#, 16),
     to_signed(-16#3A50#, 16), to_signed(-16#0950#, 16), to_signed(16#3040#, 16), to_signed(16#3D73#, 16),
     to_signed(16#1228#, 16), to_signed(-16#29D5#, 16), to_signed(-16#3F5C#, 16), to_signed(-16#1AA2#, 16),
     to_signed(16#2294#, 16), to_signed(16#4000#, 16), to_signed(16#2294#, 16), to_signed(-16#1AA2#, 16),
     to_signed(-16#3F5C#, 16), to_signed(-16#29D5#, 16), to_signed(16#1228#, 16), to_signed(16#3D73#, 16),
     to_signed(16#3040#, 16), to_signed(-16#0950#, 16), to_signed(-16#3A50#, 16), to_signed(-16#35B3#, 16),
     to_signed(16#0049#, 16), to_signed(16#3602#, 16), to_signed(16#3A14#, 16), to_signed(16#08C0#, 16),
     to_signed(-16#309F#, 16), to_signed(-16#3D4A#, 16), to_signed(-16#119C#, 16), to_signed(16#2A43#, 16),
     to_signed(16#3F47#, 16), to_signed(16#1A1E#, 16), to_signed(-16#230E#, 16), to_signed(-16#3FFF#, 16),
     to_signed(-16#221A#, 16), to_signed(16#1B26#, 16), to_signed(16#3F70#, 16), to_signed(16#2967#, 16),
     to_signed(-16#12B2#, 16), to_signed(-16#3D9B#, 16), to_signed(-16#2FE0#, 16), to_signed(16#09DF#, 16),
     to_signed(16#3A8B#, 16), to_signed(16#3564#, 16), to_signed(-16#00DA#, 16), to_signed(-16#364F#, 16),
     to_signed(-16#39D6#, 16));  -- sfix16 [61]
  CONSTANT LUT4_data                      : vector_of_signed16(0 TO 60) := 
    (to_signed(16#3F70#, 16), to_signed(16#1B26#, 16), to_signed(-16#221A#, 16), to_signed(-16#3FFF#, 16),
     to_signed(-16#230E#, 16), to_signed(16#1A1E#, 16), to_signed(16#3F47#, 16), to_signed(16#2A43#, 16),
     to_signed(-16#119C#, 16), to_signed(-16#3D4A#, 16), to_signed(-16#309F#, 16), to_signed(16#08C0#, 16),
     to_signed(16#3A14#, 16), to_signed(16#3602#, 16), to_signed(16#0049#, 16), to_signed(-16#35B3#, 16),
     to_signed(-16#3A50#, 16), to_signed(-16#0950#, 16), to_signed(16#3040#, 16), to_signed(16#3D73#, 16),
     to_signed(16#1228#, 16), to_signed(-16#29D5#, 16), to_signed(-16#3F5C#, 16), to_signed(-16#1AA2#, 16),
     to_signed(16#2294#, 16), to_signed(16#4000#, 16), to_signed(16#2294#, 16), to_signed(-16#1AA2#, 16),
     to_signed(-16#3F5C#, 16), to_signed(-16#29D5#, 16), to_signed(16#1228#, 16), to_signed(16#3D73#, 16),
     to_signed(16#3040#, 16), to_signed(-16#0950#, 16), to_signed(-16#3A50#, 16), to_signed(-16#35B3#, 16),
     to_signed(16#0049#, 16), to_signed(16#3602#, 16), to_signed(16#3A14#, 16), to_signed(16#08C0#, 16),
     to_signed(-16#309F#, 16), to_signed(-16#3D4A#, 16), to_signed(-16#119C#, 16), to_signed(16#2A43#, 16),
     to_signed(16#3F47#, 16), to_signed(16#1A1E#, 16), to_signed(-16#230E#, 16), to_signed(-16#3FFF#, 16),
     to_signed(-16#221A#, 16), to_signed(16#1B26#, 16), to_signed(16#3F70#, 16), to_signed(16#2967#, 16),
     to_signed(-16#12B2#, 16), to_signed(-16#3D9B#, 16), to_signed(-16#2FE0#, 16), to_signed(16#09DF#, 16),
     to_signed(16#3A8B#, 16), to_signed(16#3564#, 16), to_signed(-16#00DA#, 16), to_signed(-16#364F#, 16),
     to_signed(-16#39D6#, 16));  -- sfix16 [61]
  CONSTANT LUT2_data                      : vector_of_signed16(0 TO 60) := 
    (to_signed(16#3F70#, 16), to_signed(16#1B26#, 16), to_signed(-16#221A#, 16), to_signed(-16#3FFF#, 16),
     to_signed(-16#230E#, 16), to_signed(16#1A1E#, 16), to_signed(16#3F47#, 16), to_signed(16#2A43#, 16),
     to_signed(-16#119C#, 16), to_signed(-16#3D4A#, 16), to_signed(-16#309F#, 16), to_signed(16#08C0#, 16),
     to_signed(16#3A14#, 16), to_signed(16#3602#, 16), to_signed(16#0049#, 16), to_signed(-16#35B3#, 16),
     to_signed(-16#3A50#, 16), to_signed(-16#0950#, 16), to_signed(16#3040#, 16), to_signed(16#3D73#, 16),
     to_signed(16#1228#, 16), to_signed(-16#29D5#, 16), to_signed(-16#3F5C#, 16), to_signed(-16#1AA2#, 16),
     to_signed(16#2294#, 16), to_signed(16#4000#, 16), to_signed(16#2294#, 16), to_signed(-16#1AA2#, 16),
     to_signed(-16#3F5C#, 16), to_signed(-16#29D5#, 16), to_signed(16#1228#, 16), to_signed(16#3D73#, 16),
     to_signed(16#3040#, 16), to_signed(-16#0950#, 16), to_signed(-16#3A50#, 16), to_signed(-16#35B3#, 16),
     to_signed(16#0049#, 16), to_signed(16#3602#, 16), to_signed(16#3A14#, 16), to_signed(16#08C0#, 16),
     to_signed(-16#309F#, 16), to_signed(-16#3D4A#, 16), to_signed(-16#119C#, 16), to_signed(16#2A43#, 16),
     to_signed(16#3F47#, 16), to_signed(16#1A1E#, 16), to_signed(-16#230E#, 16), to_signed(-16#3FFF#, 16),
     to_signed(-16#221A#, 16), to_signed(16#1B26#, 16), to_signed(16#3F70#, 16), to_signed(16#2967#, 16),
     to_signed(-16#12B2#, 16), to_signed(-16#3D9B#, 16), to_signed(-16#2FE0#, 16), to_signed(16#09DF#, 16),
     to_signed(16#3A8B#, 16), to_signed(16#3564#, 16), to_signed(-16#00DA#, 16), to_signed(-16#364F#, 16),
     to_signed(-16#39D6#, 16));  -- sfix16 [61]

  -- Signals
  SIGNAL Constant1_out1                   : unsigned(15 DOWNTO 0);  -- ufix16_En14
  SIGNAL Constant_out1                    : unsigned(15 DOWNTO 0);  -- ufix16_En13
  SIGNAL In1_signed                       : signed(15 DOWNTO 0);  -- sfix16_En12
  SIGNAL Constant7_out1                   : unsigned(15 DOWNTO 0);  -- ufix16_En13
  SIGNAL Constant6_out1                   : unsigned(15 DOWNTO 0);  -- ufix16_En13
  SIGNAL Constant3_out1                   : unsigned(15 DOWNTO 0);  -- ufix16_En13
  SIGNAL Constant2_out1                   : unsigned(15 DOWNTO 0);  -- ufix16_En13
  SIGNAL Constant9_out1                   : unsigned(15 DOWNTO 0);  -- ufix16_En13
  SIGNAL Constant8_out1                   : unsigned(15 DOWNTO 0);  -- ufix16_En13
  SIGNAL Constant5_out1                   : unsigned(15 DOWNTO 0);  -- ufix16_En13
  SIGNAL Constant4_out1                   : unsigned(15 DOWNTO 0);  -- ufix16_En13
  SIGNAL Product_cast                     : signed(16 DOWNTO 0);  -- sfix17_En13
  SIGNAL Product_mul_temp                 : signed(32 DOWNTO 0);  -- sfix33_En25
  SIGNAL Product_cast_1                   : signed(31 DOWNTO 0);  -- sfix32_En25
  SIGNAL Product_out1                     : signed(15 DOWNTO 0);  -- sfix16_En9
  SIGNAL Add_add_cast                     : signed(15 DOWNTO 0);  -- sfix16_En9
  SIGNAL Add_out1                         : signed(15 DOWNTO 0);  -- sfix16_En9
  SIGNAL LUT_out1                         : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL Data_Type_Conversion_out1        : signed(15 DOWNTO 0);  -- sfix16_En10
  SIGNAL Product3_cast                    : signed(16 DOWNTO 0);  -- sfix17_En13
  SIGNAL Product3_mul_temp                : signed(32 DOWNTO 0);  -- sfix33_En25
  SIGNAL Product3_cast_1                  : signed(31 DOWNTO 0);  -- sfix32_En25
  SIGNAL Product3_out1                    : signed(15 DOWNTO 0);  -- sfix16_En9
  SIGNAL Add4_add_cast                    : signed(15 DOWNTO 0);  -- sfix16_En9
  SIGNAL Add4_out1                        : signed(15 DOWNTO 0);  -- sfix16_En9
  SIGNAL LUT3_out1                        : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL Data_Type_Conversion3_out1       : signed(15 DOWNTO 0);  -- sfix16_En10
  SIGNAL Product1_cast                    : signed(16 DOWNTO 0);  -- sfix17_En13
  SIGNAL Product1_mul_temp                : signed(32 DOWNTO 0);  -- sfix33_En25
  SIGNAL Product1_cast_1                  : signed(31 DOWNTO 0);  -- sfix32_En25
  SIGNAL Product1_out1                    : signed(15 DOWNTO 0);  -- sfix16_En9
  SIGNAL Add1_add_cast                    : signed(15 DOWNTO 0);  -- sfix16_En9
  SIGNAL Add1_out1                        : signed(15 DOWNTO 0);  -- sfix16_En9
  SIGNAL LUT1_out1                        : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL Data_Type_Conversion1_out1       : signed(15 DOWNTO 0);  -- sfix16_En10
  SIGNAL Product4_cast                    : signed(16 DOWNTO 0);  -- sfix17_En13
  SIGNAL Product4_mul_temp                : signed(32 DOWNTO 0);  -- sfix33_En25
  SIGNAL Product4_cast_1                  : signed(31 DOWNTO 0);  -- sfix32_En25
  SIGNAL Product4_out1                    : signed(15 DOWNTO 0);  -- sfix16_En9
  SIGNAL Add5_add_cast                    : signed(15 DOWNTO 0);  -- sfix16_En9
  SIGNAL Add5_out1                        : signed(15 DOWNTO 0);  -- sfix16_En9
  SIGNAL LUT4_out1                        : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL Data_Type_Conversion4_out1       : signed(15 DOWNTO 0);  -- sfix16_En10
  SIGNAL Product2_cast                    : signed(16 DOWNTO 0);  -- sfix17_En13
  SIGNAL Product2_mul_temp                : signed(32 DOWNTO 0);  -- sfix33_En25
  SIGNAL Product2_cast_1                  : signed(31 DOWNTO 0);  -- sfix32_En25
  SIGNAL Product2_out1                    : signed(15 DOWNTO 0);  -- sfix16_En9
  SIGNAL Add2_add_cast                    : signed(15 DOWNTO 0);  -- sfix16_En9
  SIGNAL Add2_out1                        : signed(15 DOWNTO 0);  -- sfix16_En9
  SIGNAL LUT2_out1                        : signed(15 DOWNTO 0);  -- sfix16_En14
  SIGNAL Data_Type_Conversion2_out1       : signed(15 DOWNTO 0);  -- sfix16_En10
  SIGNAL Add3_add_temp                    : signed(15 DOWNTO 0);  -- sfix16_En10
  SIGNAL Add3_add_temp_1                  : signed(15 DOWNTO 0);  -- sfix16_En10
  SIGNAL Add3_add_temp_2                  : signed(15 DOWNTO 0);  -- sfix16_En10
  SIGNAL Add3_out1                        : signed(15 DOWNTO 0);  -- sfix16_En10

BEGIN
  Constant1_out1 <= to_unsigned(16#4000#, 16);

  Constant_out1 <= to_unsigned(16#4000#, 16);

  In1_signed <= signed(In1);

  Constant7_out1 <= to_unsigned(16#8000#, 16);

  Constant6_out1 <= to_unsigned(16#A000#, 16);

  Constant3_out1 <= to_unsigned(16#4000#, 16);

  Constant2_out1 <= to_unsigned(16#6000#, 16);

  Constant9_out1 <= to_unsigned(16#A000#, 16);

  Constant8_out1 <= to_unsigned(16#C000#, 16);

  Constant5_out1 <= to_unsigned(16#6000#, 16);

  Constant4_out1 <= to_unsigned(16#8000#, 16);

  Product_cast <= signed(resize(Constant_out1, 17));
  Product_mul_temp <= Product_cast * In1_signed;
  Product_cast_1 <= Product_mul_temp(31 DOWNTO 0);
  Product_out1 <= Product_cast_1(31 DOWNTO 16);

  Add_add_cast <= signed(resize(Constant1_out1(15 DOWNTO 5), 16));
  Add_out1 <= Add_add_cast + Product_out1;

  LUT_output : PROCESS (Add_out1)
    VARIABLE dout_low : signed(15 DOWNTO 0);
    VARIABLE k : unsigned(5 DOWNTO 0);
    VARIABLE f : unsigned(31 DOWNTO 0);
    VARIABLE sub_temp : signed(15 DOWNTO 0);
    VARIABLE in0 : signed(15 DOWNTO 0);
    VARIABLE add_cast : signed(48 DOWNTO 0);
    VARIABLE cast : signed(32 DOWNTO 0);
    VARIABLE sub_temp_0 : signed(15 DOWNTO 0);
    VARIABLE mul_temp : signed(48 DOWNTO 0);
    VARIABLE add_cast_0 : signed(47 DOWNTO 0);
    VARIABLE add_cast_1 : signed(48 DOWNTO 0);
    VARIABLE add_temp : signed(48 DOWNTO 0);
  BEGIN
    IF Add_out1 <= to_signed(-16#3200#, 16) THEN 
      k := to_unsigned(16#00#, 6);
    ELSIF Add_out1 >= to_signed(16#4600#, 16) THEN 
      k := to_unsigned(16#3C#, 6);
    ELSE 
      sub_temp := Add_out1 - to_signed(-16#3200#, 16);
      k := unsigned(sub_temp(14 DOWNTO 9));
    END IF;
    IF (Add_out1 <= to_signed(-16#3200#, 16)) OR (Add_out1 >= to_signed(16#4600#, 16)) THEN 
      f := to_unsigned(0, 32);
    ELSE 
      in0 := Add_out1 AND to_signed(16#01FF#, 16);
      f := unsigned(in0(8 DOWNTO 0) & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0');
    END IF;
    dout_low := LUT_data(to_integer(k));
    IF k = to_unsigned(16#3C#, 6) THEN 
      NULL;
    ELSE 
      k := k + to_unsigned(16#01#, 6);
    END IF;
    add_cast := resize(dout_low & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 49);
    cast := signed(resize(f, 33));
    sub_temp_0 := LUT_data(to_integer(k)) - dout_low;
    mul_temp := cast * sub_temp_0;
    add_cast_0 := mul_temp(47 DOWNTO 0);
    add_cast_1 := resize(add_cast_0, 49);
    add_temp := add_cast + add_cast_1;
    LUT_out1 <= add_temp(47 DOWNTO 32);
  END PROCESS LUT_output;


  Data_Type_Conversion_out1 <= resize(LUT_out1(15 DOWNTO 4), 16);

  Product3_cast <= signed(resize(Constant6_out1, 17));
  Product3_mul_temp <= Product3_cast * In1_signed;
  Product3_cast_1 <= Product3_mul_temp(31 DOWNTO 0);
  Product3_out1 <= Product3_cast_1(31 DOWNTO 16);

  Add4_add_cast <= signed(resize(Constant7_out1(15 DOWNTO 4), 16));
  Add4_out1 <= Add4_add_cast + Product3_out1;

  LUT3_output : PROCESS (Add4_out1)
    VARIABLE dout_low1 : signed(15 DOWNTO 0);
    VARIABLE k1 : unsigned(5 DOWNTO 0);
    VARIABLE f1 : unsigned(31 DOWNTO 0);
    VARIABLE sub_temp1 : signed(15 DOWNTO 0);
    VARIABLE in01 : signed(15 DOWNTO 0);
    VARIABLE add_cast1 : signed(48 DOWNTO 0);
    VARIABLE cast1 : signed(32 DOWNTO 0);
    VARIABLE sub_temp_01 : signed(15 DOWNTO 0);
    VARIABLE mul_temp1 : signed(48 DOWNTO 0);
    VARIABLE add_cast_01 : signed(47 DOWNTO 0);
    VARIABLE add_cast_11 : signed(48 DOWNTO 0);
    VARIABLE add_temp1 : signed(48 DOWNTO 0);
  BEGIN
    IF Add4_out1 <= to_signed(-16#3200#, 16) THEN 
      k1 := to_unsigned(16#00#, 6);
    ELSIF Add4_out1 >= to_signed(16#4600#, 16) THEN 
      k1 := to_unsigned(16#3C#, 6);
    ELSE 
      sub_temp1 := Add4_out1 - to_signed(-16#3200#, 16);
      k1 := unsigned(sub_temp1(14 DOWNTO 9));
    END IF;
    IF (Add4_out1 <= to_signed(-16#3200#, 16)) OR (Add4_out1 >= to_signed(16#4600#, 16)) THEN 
      f1 := to_unsigned(0, 32);
    ELSE 
      in01 := Add4_out1 AND to_signed(16#01FF#, 16);
      f1 := unsigned(in01(8 DOWNTO 0) & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0');
    END IF;
    dout_low1 := LUT3_data(to_integer(k1));
    IF k1 = to_unsigned(16#3C#, 6) THEN 
      NULL;
    ELSE 
      k1 := k1 + to_unsigned(16#01#, 6);
    END IF;
    add_cast1 := resize(dout_low1 & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 49);
    cast1 := signed(resize(f1, 33));
    sub_temp_01 := LUT3_data(to_integer(k1)) - dout_low1;
    mul_temp1 := cast1 * sub_temp_01;
    add_cast_01 := mul_temp1(47 DOWNTO 0);
    add_cast_11 := resize(add_cast_01, 49);
    add_temp1 := add_cast1 + add_cast_11;
    LUT3_out1 <= add_temp1(47 DOWNTO 32);
  END PROCESS LUT3_output;


  Data_Type_Conversion3_out1 <= resize(LUT3_out1(15 DOWNTO 4), 16);

  Product1_cast <= signed(resize(Constant2_out1, 17));
  Product1_mul_temp <= Product1_cast * In1_signed;
  Product1_cast_1 <= Product1_mul_temp(31 DOWNTO 0);
  Product1_out1 <= Product1_cast_1(31 DOWNTO 16);

  Add1_add_cast <= signed(resize(Constant3_out1(15 DOWNTO 4), 16));
  Add1_out1 <= Add1_add_cast + Product1_out1;

  LUT1_output : PROCESS (Add1_out1)
    VARIABLE dout_low2 : signed(15 DOWNTO 0);
    VARIABLE k2 : unsigned(5 DOWNTO 0);
    VARIABLE f2 : unsigned(31 DOWNTO 0);
    VARIABLE sub_temp2 : signed(15 DOWNTO 0);
    VARIABLE in02 : signed(15 DOWNTO 0);
    VARIABLE add_cast2 : signed(48 DOWNTO 0);
    VARIABLE cast2 : signed(32 DOWNTO 0);
    VARIABLE sub_temp_02 : signed(15 DOWNTO 0);
    VARIABLE mul_temp2 : signed(48 DOWNTO 0);
    VARIABLE add_cast_02 : signed(47 DOWNTO 0);
    VARIABLE add_cast_12 : signed(48 DOWNTO 0);
    VARIABLE add_temp2 : signed(48 DOWNTO 0);
  BEGIN
    IF Add1_out1 <= to_signed(-16#3200#, 16) THEN 
      k2 := to_unsigned(16#00#, 6);
    ELSIF Add1_out1 >= to_signed(16#4600#, 16) THEN 
      k2 := to_unsigned(16#3C#, 6);
    ELSE 
      sub_temp2 := Add1_out1 - to_signed(-16#3200#, 16);
      k2 := unsigned(sub_temp2(14 DOWNTO 9));
    END IF;
    IF (Add1_out1 <= to_signed(-16#3200#, 16)) OR (Add1_out1 >= to_signed(16#4600#, 16)) THEN 
      f2 := to_unsigned(0, 32);
    ELSE 
      in02 := Add1_out1 AND to_signed(16#01FF#, 16);
      f2 := unsigned(in02(8 DOWNTO 0) & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0');
    END IF;
    dout_low2 := LUT1_data(to_integer(k2));
    IF k2 = to_unsigned(16#3C#, 6) THEN 
      NULL;
    ELSE 
      k2 := k2 + to_unsigned(16#01#, 6);
    END IF;
    add_cast2 := resize(dout_low2 & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 49);
    cast2 := signed(resize(f2, 33));
    sub_temp_02 := LUT1_data(to_integer(k2)) - dout_low2;
    mul_temp2 := cast2 * sub_temp_02;
    add_cast_02 := mul_temp2(47 DOWNTO 0);
    add_cast_12 := resize(add_cast_02, 49);
    add_temp2 := add_cast2 + add_cast_12;
    LUT1_out1 <= add_temp2(47 DOWNTO 32);
  END PROCESS LUT1_output;


  Data_Type_Conversion1_out1 <= resize(LUT1_out1(15 DOWNTO 4), 16);

  Product4_cast <= signed(resize(Constant8_out1, 17));
  Product4_mul_temp <= Product4_cast * In1_signed;
  Product4_cast_1 <= Product4_mul_temp(31 DOWNTO 0);
  Product4_out1 <= Product4_cast_1(31 DOWNTO 16);

  Add5_add_cast <= signed(resize(Constant9_out1(15 DOWNTO 4), 16));
  Add5_out1 <= Add5_add_cast + Product4_out1;

  LUT4_output : PROCESS (Add5_out1)
    VARIABLE dout_low3 : signed(15 DOWNTO 0);
    VARIABLE k3 : unsigned(5 DOWNTO 0);
    VARIABLE f3 : unsigned(31 DOWNTO 0);
    VARIABLE sub_temp3 : signed(15 DOWNTO 0);
    VARIABLE in03 : signed(15 DOWNTO 0);
    VARIABLE add_cast3 : signed(48 DOWNTO 0);
    VARIABLE cast3 : signed(32 DOWNTO 0);
    VARIABLE sub_temp_03 : signed(15 DOWNTO 0);
    VARIABLE mul_temp3 : signed(48 DOWNTO 0);
    VARIABLE add_cast_03 : signed(47 DOWNTO 0);
    VARIABLE add_cast_13 : signed(48 DOWNTO 0);
    VARIABLE add_temp3 : signed(48 DOWNTO 0);
  BEGIN
    IF Add5_out1 <= to_signed(-16#3200#, 16) THEN 
      k3 := to_unsigned(16#00#, 6);
    ELSIF Add5_out1 >= to_signed(16#4600#, 16) THEN 
      k3 := to_unsigned(16#3C#, 6);
    ELSE 
      sub_temp3 := Add5_out1 - to_signed(-16#3200#, 16);
      k3 := unsigned(sub_temp3(14 DOWNTO 9));
    END IF;
    IF (Add5_out1 <= to_signed(-16#3200#, 16)) OR (Add5_out1 >= to_signed(16#4600#, 16)) THEN 
      f3 := to_unsigned(0, 32);
    ELSE 
      in03 := Add5_out1 AND to_signed(16#01FF#, 16);
      f3 := unsigned(in03(8 DOWNTO 0) & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0');
    END IF;
    dout_low3 := LUT4_data(to_integer(k3));
    IF k3 = to_unsigned(16#3C#, 6) THEN 
      NULL;
    ELSE 
      k3 := k3 + to_unsigned(16#01#, 6);
    END IF;
    add_cast3 := resize(dout_low3 & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 49);
    cast3 := signed(resize(f3, 33));
    sub_temp_03 := LUT4_data(to_integer(k3)) - dout_low3;
    mul_temp3 := cast3 * sub_temp_03;
    add_cast_03 := mul_temp3(47 DOWNTO 0);
    add_cast_13 := resize(add_cast_03, 49);
    add_temp3 := add_cast3 + add_cast_13;
    LUT4_out1 <= add_temp3(47 DOWNTO 32);
  END PROCESS LUT4_output;


  Data_Type_Conversion4_out1 <= resize(LUT4_out1(15 DOWNTO 4), 16);

  Product2_cast <= signed(resize(Constant4_out1, 17));
  Product2_mul_temp <= Product2_cast * In1_signed;
  Product2_cast_1 <= Product2_mul_temp(31 DOWNTO 0);
  Product2_out1 <= Product2_cast_1(31 DOWNTO 16);

  Add2_add_cast <= signed(resize(Constant5_out1(15 DOWNTO 4), 16));
  Add2_out1 <= Add2_add_cast + Product2_out1;

  LUT2_output : PROCESS (Add2_out1)
    VARIABLE dout_low4 : signed(15 DOWNTO 0);
    VARIABLE k4 : unsigned(5 DOWNTO 0);
    VARIABLE f4 : unsigned(31 DOWNTO 0);
    VARIABLE sub_temp4 : signed(15 DOWNTO 0);
    VARIABLE in04 : signed(15 DOWNTO 0);
    VARIABLE add_cast4 : signed(48 DOWNTO 0);
    VARIABLE cast4 : signed(32 DOWNTO 0);
    VARIABLE sub_temp_04 : signed(15 DOWNTO 0);
    VARIABLE mul_temp4 : signed(48 DOWNTO 0);
    VARIABLE add_cast_04 : signed(47 DOWNTO 0);
    VARIABLE add_cast_14 : signed(48 DOWNTO 0);
    VARIABLE add_temp4 : signed(48 DOWNTO 0);
  BEGIN
    IF Add2_out1 <= to_signed(-16#3200#, 16) THEN 
      k4 := to_unsigned(16#00#, 6);
    ELSIF Add2_out1 >= to_signed(16#4600#, 16) THEN 
      k4 := to_unsigned(16#3C#, 6);
    ELSE 
      sub_temp4 := Add2_out1 - to_signed(-16#3200#, 16);
      k4 := unsigned(sub_temp4(14 DOWNTO 9));
    END IF;
    IF (Add2_out1 <= to_signed(-16#3200#, 16)) OR (Add2_out1 >= to_signed(16#4600#, 16)) THEN 
      f4 := to_unsigned(0, 32);
    ELSE 
      in04 := Add2_out1 AND to_signed(16#01FF#, 16);
      f4 := unsigned(in04(8 DOWNTO 0) & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0');
    END IF;
    dout_low4 := LUT2_data(to_integer(k4));
    IF k4 = to_unsigned(16#3C#, 6) THEN 
      NULL;
    ELSE 
      k4 := k4 + to_unsigned(16#01#, 6);
    END IF;
    add_cast4 := resize(dout_low4 & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 49);
    cast4 := signed(resize(f4, 33));
    sub_temp_04 := LUT2_data(to_integer(k4)) - dout_low4;
    mul_temp4 := cast4 * sub_temp_04;
    add_cast_04 := mul_temp4(47 DOWNTO 0);
    add_cast_14 := resize(add_cast_04, 49);
    add_temp4 := add_cast4 + add_cast_14;
    LUT2_out1 <= add_temp4(47 DOWNTO 32);
  END PROCESS LUT2_output;


  Data_Type_Conversion2_out1 <= resize(LUT2_out1(15 DOWNTO 4), 16);

  Add3_add_temp <= Data_Type_Conversion_out1 + Data_Type_Conversion3_out1;
  Add3_add_temp_1 <= Add3_add_temp + Data_Type_Conversion1_out1;
  Add3_add_temp_2 <= Add3_add_temp_1 + Data_Type_Conversion4_out1;
  Add3_out1 <= Add3_add_temp_2 + Data_Type_Conversion2_out1;

  Out1 <= std_logic_vector(Add3_out1);

END rtl;

