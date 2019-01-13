-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc\flightControlSystem\equilibrium_thrust.vhd
-- Created: 2019-01-13 13:16:31
-- 
-- Generated by MATLAB 9.5 and HDL Coder 3.13
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: equilibrium_thrust
-- Source Path: flightController/Flight Controller/gravity feedforward//equilibrium thrust
-- Hierarchy Level: 2
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY equilibrium_thrust IS
  PORT( states_estim_X                    :   IN    std_logic_vector(31 DOWNTO 0);  -- single
        states_estim_Y                    :   IN    std_logic_vector(31 DOWNTO 0);  -- single
        states_estim_Z                    :   IN    std_logic_vector(31 DOWNTO 0);  -- single
        states_estim_yaw                  :   IN    std_logic_vector(31 DOWNTO 0);  -- single
        states_estim_pitch                :   IN    std_logic_vector(31 DOWNTO 0);  -- single
        states_estim_roll                 :   IN    std_logic_vector(31 DOWNTO 0);  -- single
        states_estim_dx                   :   IN    std_logic_vector(31 DOWNTO 0);  -- single
        states_estim_dy                   :   IN    std_logic_vector(31 DOWNTO 0);  -- single
        states_estim_dz                   :   IN    std_logic_vector(31 DOWNTO 0);  -- single
        states_estim_p                    :   IN    std_logic_vector(31 DOWNTO 0);  -- single
        states_estim_q                    :   IN    std_logic_vector(31 DOWNTO 0);  -- single
        states_estim_r                    :   IN    std_logic_vector(31 DOWNTO 0);  -- single
        PosZ                              :   IN    std_logic_vector(31 DOWNTO 0);  -- single
        takeoff_flag                      :   IN    std_logic;
        altitude_cmd                      :   OUT   std_logic_vector(31 DOWNTO 0)  -- single
        );
END equilibrium_thrust;


ARCHITECTURE rtl OF equilibrium_thrust IS

  -- Component Declarations
  COMPONENT nfp_sub_comp
    PORT( nfp_in1                         :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          nfp_in2                         :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          nfp_out                         :   OUT   std_logic_vector(31 DOWNTO 0)  -- single
          );
  END COMPONENT;

  COMPONENT nfp_mul_comp
    PORT( nfp_in1                         :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          nfp_in2                         :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          nfp_out                         :   OUT   std_logic_vector(31 DOWNTO 0)  -- single
          );
  END COMPONENT;

  COMPONENT nfp_add_comp
    PORT( nfp_in1                         :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          nfp_in2                         :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          nfp_out                         :   OUT   std_logic_vector(31 DOWNTO 0)  -- single
          );
  END COMPONENT;

  COMPONENT nfp_relop_comp_block
    PORT( nfp_in1                         :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          nfp_in2                         :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          nfp_out1                        :   OUT   std_logic
          );
  END COMPONENT;

  COMPONENT nfp_relop_comp
    PORT( nfp_in1                         :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          nfp_in2                         :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          nfp_out1                        :   OUT   std_logic
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : nfp_sub_comp
    USE ENTITY work.nfp_sub_comp(rtl);

  FOR ALL : nfp_mul_comp
    USE ENTITY work.nfp_mul_comp(rtl);

  FOR ALL : nfp_add_comp
    USE ENTITY work.nfp_add_comp(rtl);

  FOR ALL : nfp_relop_comp_block
    USE ENTITY work.nfp_relop_comp_block(rtl);

  FOR ALL : nfp_relop_comp
    USE ENTITY work.nfp_relop_comp(rtl);

  -- Signals
  SIGNAL w0_out1                          : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL kconst                           : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Z                                : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL kconst_1                         : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL errZ                             : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL P_z_out1                         : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL dz                               : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL dz_1                             : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Sum15_out1                       : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL takeoff_gain_out1                : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL TakeoffOrControl_Switch_out1     : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Sum4_out1                        : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Upperlimit_out                   : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL LowerRelop_out                   : std_logic;
  SIGNAL Lowerlimit_out                   : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL UpperRelop_out                   : std_logic;
  SIGNAL Switch1_out                      : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL SaturationThrust_out1            : std_logic_vector(31 DOWNTO 0);  -- ufix32

BEGIN
  -- ALTITUDE

  u_nfp_sub_comp : nfp_sub_comp
    PORT MAP( nfp_in1 => PosZ,  -- single
              nfp_in2 => Z,  -- single
              nfp_out => errZ  -- single
              );

  u_nfp_mul_comp : nfp_mul_comp
    PORT MAP( nfp_in1 => kconst,  -- single
              nfp_in2 => errZ,  -- single
              nfp_out => P_z_out1  -- single
              );

  u_nfp_mul_comp_1 : nfp_mul_comp
    PORT MAP( nfp_in1 => kconst_1,  -- single
              nfp_in2 => dz,  -- single
              nfp_out => dz_1  -- single
              );

  u_nfp_sub_comp_1 : nfp_sub_comp
    PORT MAP( nfp_in1 => P_z_out1,  -- single
              nfp_in2 => dz_1,  -- single
              nfp_out => Sum15_out1  -- single
              );

  u_nfp_add_comp : nfp_add_comp
    PORT MAP( nfp_in1 => w0_out1,  -- single
              nfp_in2 => TakeoffOrControl_Switch_out1,  -- single
              nfp_out => Sum4_out1  -- single
              );

  u_nfp_relop_comp : nfp_relop_comp_block
    PORT MAP( nfp_in1 => Sum4_out1,  -- single
              nfp_in2 => Upperlimit_out,  -- single
              nfp_out1 => LowerRelop_out
              );

  u_nfp_relop_comp_1 : nfp_relop_comp
    PORT MAP( nfp_in1 => Sum4_out1,  -- single
              nfp_in2 => Lowerlimit_out,  -- single
              nfp_out1 => UpperRelop_out
              );

  w0_out1 <= X"bf1e3737";

  kconst <= X"3f4ccccd";

  Z <= states_estim_Z;

  kconst_1 <= X"3e99999a";

  dz <= states_estim_dz;

  takeoff_gain_out1 <= X"be8e64e4";

  
  TakeoffOrControl_Switch_out1 <= Sum15_out1 WHEN takeoff_flag = '0' ELSE
      takeoff_gain_out1;

  Upperlimit_out <= X"3f99dc8e";

  Lowerlimit_out <= X"bf99dc8e";

  
  Switch1_out <= Sum4_out1 WHEN UpperRelop_out = '0' ELSE
      Lowerlimit_out;

  
  SaturationThrust_out1 <= Switch1_out WHEN LowerRelop_out = '0' ELSE
      Upperlimit_out;

  altitude_cmd <= SaturationThrust_out1;

END rtl;

