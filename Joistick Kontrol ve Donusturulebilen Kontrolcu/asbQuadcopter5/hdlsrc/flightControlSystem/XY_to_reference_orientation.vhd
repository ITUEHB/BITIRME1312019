-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc\flightControlSystem\XY_to_reference_orientation.vhd
-- Created: 2019-01-13 13:16:31
-- 
-- Generated by MATLAB 9.5 and HDL Coder 3.13
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: XY_to_reference_orientation
-- Source Path: flightController/Flight Controller/XY-to-reference-orientation
-- Hierarchy Level: 2
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.flightController_pkg.ALL;

ENTITY XY_to_reference_orientation IS
  PORT( posXY                             :   IN    vector_of_std_logic_vector32(0 TO 1);  -- single [2]
        states_estim_X                    :   IN    std_logic_vector(31 DOWNTO 0);  -- single
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
        yaw                               :   IN    std_logic_vector(31 DOWNTO 0);  -- single
        pitch_roll_cmd                    :   OUT   vector_of_std_logic_vector32(0 TO 1)  -- single [2]
        );
END XY_to_reference_orientation;


ARCHITECTURE rtl OF XY_to_reference_orientation IS

  -- Component Declarations
  COMPONENT nfp_sincos_comp
    PORT( nfp_in                          :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          nfp_out1                        :   OUT   std_logic_vector(31 DOWNTO 0);  -- single
          nfp_out2                        :   OUT   std_logic_vector(31 DOWNTO 0)  -- single
          );
  END COMPONENT;

  COMPONENT nfp_uminus_comp
    PORT( nfp_in                          :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          nfp_out                         :   OUT   std_logic_vector(31 DOWNTO 0)  -- single
          );
  END COMPONENT;

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
  FOR ALL : nfp_sincos_comp
    USE ENTITY work.nfp_sincos_comp(rtl);

  FOR ALL : nfp_uminus_comp
    USE ENTITY work.nfp_uminus_comp(rtl);

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
  SIGNAL kconst                           : vector_of_std_logic_vector32(0 TO 1);  -- ufix32 [2]
  SIGNAL Trigonometric_Function_out1      : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Trigonometric_Function_out2      : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Matrix_Concatenate_out1          : matrix_of_std_logic_vector32(0 TO 1, 0 TO 1);  -- ufix32 [2x2]
  SIGNAL Matrix_Concatenate_out1t         : matrix_of_std_logic_vector32(0 TO 1, 0 TO 1);  -- ufix32 [2x2]
  SIGNAL Y                                : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL nfp_out_2_1                      : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL tmp_Product_dotp_1               : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL X                                : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL nfp_out_1_1                      : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL tmp_Product_dotp_0               : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Product_0_0                      : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Upperlimit_out                   : vector_of_std_logic_vector32(0 TO 1);  -- ufix32 [2]
  SIGNAL nfp_out_1_1_1                    : std_logic;
  SIGNAL Lowerlimit_out                   : vector_of_std_logic_vector32(0 TO 1);  -- ufix32 [2]
  SIGNAL nfp_out_1_1_2                    : std_logic;
  SIGNAL Lowerlimit_out_0                 : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Switch1_out_0                    : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL kconst_1                         : vector_of_std_logic_vector32(0 TO 1);  -- ufix32 [2]
  SIGNAL tmp_Product_dotp_1_1             : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL XY_error                         : vector_of_std_logic_vector32(0 TO 1);  -- ufix32 [2]
  SIGNAL XY_error_1                       : vector_of_std_logic_vector32(0 TO 1);  -- ufix32 [2]
  SIGNAL tmp_Product_dotp_0_1             : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Product_1_0                      : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL nfp_out_2_1_1                    : std_logic;
  SIGNAL nfp_out_2_1_2                    : std_logic;
  SIGNAL Lowerlimit_out_1                 : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Switch1_out_1                    : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Upperlimit_out_0                 : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Saturation_out1_0                : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL nfp_out_1_1_3                    : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL dx                               : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL nfp_out_1_1_4                    : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Upperlimit_out_1                 : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Saturation_out1_1                : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL nfp_out_2_1_3                    : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL dy                               : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL nfp_out_2_1_4                    : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL pitch_roll_cmd_1                 : vector_of_std_logic_vector32(0 TO 1);  -- ufix32 [2]

BEGIN
  u_nfp_sincos_comp : nfp_sincos_comp
    PORT MAP( nfp_in => yaw,  -- single
              nfp_out1 => Trigonometric_Function_out1,  -- single
              nfp_out2 => Trigonometric_Function_out2  -- single
              );

  u_nfp_uminus_comp : nfp_uminus_comp
    PORT MAP( nfp_in => Trigonometric_Function_out1,  -- single
              nfp_out => Matrix_Concatenate_out1(1, 0)  -- single
              );

  u_nfp_sub_comp : nfp_sub_comp
    PORT MAP( nfp_in1 => posXY(1),  -- single
              nfp_in2 => Y,  -- single
              nfp_out => nfp_out_2_1  -- single
              );

  u_nfp_mul_comp : nfp_mul_comp
    PORT MAP( nfp_in1 => Matrix_Concatenate_out1t(1, 0),  -- single
              nfp_in2 => nfp_out_2_1,  -- single
              nfp_out => tmp_Product_dotp_1  -- single
              );

  u_nfp_sub_comp_1 : nfp_sub_comp
    PORT MAP( nfp_in1 => posXY(0),  -- single
              nfp_in2 => X,  -- single
              nfp_out => nfp_out_1_1  -- single
              );

  u_nfp_mul_comp_1 : nfp_mul_comp
    PORT MAP( nfp_in1 => Matrix_Concatenate_out1t(0, 0),  -- single
              nfp_in2 => nfp_out_1_1,  -- single
              nfp_out => tmp_Product_dotp_0  -- single
              );

  u_nfp_add_comp : nfp_add_comp
    PORT MAP( nfp_in1 => tmp_Product_dotp_1,  -- single
              nfp_in2 => tmp_Product_dotp_0,  -- single
              nfp_out => Product_0_0  -- single
              );

  u_nfp_relop_comp : nfp_relop_comp_block
    PORT MAP( nfp_in1 => Product_0_0,  -- single
              nfp_in2 => Upperlimit_out(0),  -- single
              nfp_out1 => nfp_out_1_1_1
              );

  u_nfp_relop_comp_1 : nfp_relop_comp
    PORT MAP( nfp_in1 => Product_0_0,  -- single
              nfp_in2 => Lowerlimit_out(0),  -- single
              nfp_out1 => nfp_out_1_1_2
              );

  u_nfp_mul_comp_2 : nfp_mul_comp
    PORT MAP( nfp_in1 => Matrix_Concatenate_out1t(1, 1),  -- single
              nfp_in2 => nfp_out_2_1,  -- single
              nfp_out => tmp_Product_dotp_1_1  -- single
              );

  u_nfp_mul_comp_3 : nfp_mul_comp
    PORT MAP( nfp_in1 => Matrix_Concatenate_out1t(0, 1),  -- single
              nfp_in2 => XY_error_1(0),  -- single
              nfp_out => tmp_Product_dotp_0_1  -- single
              );

  u_nfp_add_comp_1 : nfp_add_comp
    PORT MAP( nfp_in1 => tmp_Product_dotp_1_1,  -- single
              nfp_in2 => tmp_Product_dotp_0_1,  -- single
              nfp_out => Product_1_0  -- single
              );

  u_nfp_relop_comp_2 : nfp_relop_comp_block
    PORT MAP( nfp_in1 => Product_1_0,  -- single
              nfp_in2 => Upperlimit_out(1),  -- single
              nfp_out1 => nfp_out_2_1_1
              );

  u_nfp_relop_comp_3 : nfp_relop_comp
    PORT MAP( nfp_in1 => Product_1_0,  -- single
              nfp_in2 => Lowerlimit_out(1),  -- single
              nfp_out1 => nfp_out_2_1_2
              );

  u_nfp_mul_comp_4 : nfp_mul_comp
    PORT MAP( nfp_in1 => kconst(0),  -- single
              nfp_in2 => Saturation_out1_0,  -- single
              nfp_out => nfp_out_1_1_3  -- single
              );

  u_nfp_mul_comp_5 : nfp_mul_comp
    PORT MAP( nfp_in1 => kconst_1(0),  -- single
              nfp_in2 => dx,  -- single
              nfp_out => nfp_out_1_1_4  -- single
              );

  u_nfp_add_comp_2 : nfp_add_comp
    PORT MAP( nfp_in1 => nfp_out_1_1_3,  -- single
              nfp_in2 => nfp_out_1_1_4,  -- single
              nfp_out => pitch_roll_cmd_1(0)  -- single
              );

  u_nfp_mul_comp_6 : nfp_mul_comp
    PORT MAP( nfp_in1 => kconst(1),  -- single
              nfp_in2 => Saturation_out1_1,  -- single
              nfp_out => nfp_out_2_1_3  -- single
              );

  u_nfp_mul_comp_7 : nfp_mul_comp
    PORT MAP( nfp_in1 => kconst_1(1),  -- single
              nfp_in2 => dy,  -- single
              nfp_out => nfp_out_2_1_4  -- single
              );

  u_nfp_add_comp_3 : nfp_add_comp
    PORT MAP( nfp_in1 => nfp_out_2_1_3,  -- single
              nfp_in2 => nfp_out_2_1_4,  -- single
              nfp_out => pitch_roll_cmd_1(1)  -- single
              );

  kconst(0) <= X"be75c28f";
  kconst(1) <= X"3e75c28f";

  Matrix_Concatenate_out1(0, 0) <= Trigonometric_Function_out2;
  Matrix_Concatenate_out1(0, 1) <= Trigonometric_Function_out1;
  Matrix_Concatenate_out1(1, 1) <= Trigonometric_Function_out2;

  transpose_output : PROCESS (Matrix_Concatenate_out1)
  BEGIN
    Matrix_Concatenate_out1t(0, 0) <= Matrix_Concatenate_out1(0, 0);
    Matrix_Concatenate_out1t(1, 0) <= Matrix_Concatenate_out1(0, 1);
    Matrix_Concatenate_out1t(0, 1) <= Matrix_Concatenate_out1(1, 0);
    Matrix_Concatenate_out1t(1, 1) <= Matrix_Concatenate_out1(1, 1);
  END PROCESS transpose_output;


  Y <= states_estim_Y;

  X <= states_estim_X;

  Upperlimit_out(0) <= X"40400000";
  Upperlimit_out(1) <= X"40400000";

  Lowerlimit_out(0) <= X"c0400000";
  Lowerlimit_out(1) <= X"c0400000";

  Lowerlimit_out_0 <= Lowerlimit_out(0);

  
  Switch1_out_0 <= Product_0_0 WHEN nfp_out_1_1_2 = '0' ELSE
      Lowerlimit_out_0;

  kconst_1(0) <= X"3dcccccd";
  kconst_1(1) <= X"bdcccccd";

  XY_error(0) <= nfp_out_1_1;
  XY_error(1) <= nfp_out_2_1;

  XY_error_1 <= XY_error;

  Lowerlimit_out_1 <= Lowerlimit_out(1);

  
  Switch1_out_1 <= Product_1_0 WHEN nfp_out_2_1_2 = '0' ELSE
      Lowerlimit_out_1;

  Upperlimit_out_0 <= Upperlimit_out(0);

  
  Saturation_out1_0 <= Switch1_out_0 WHEN nfp_out_1_1_1 = '0' ELSE
      Upperlimit_out_0;

  dx <= states_estim_dx;

  Upperlimit_out_1 <= Upperlimit_out(1);

  
  Saturation_out1_1 <= Switch1_out_1 WHEN nfp_out_2_1_1 = '0' ELSE
      Upperlimit_out_1;

  dy <= states_estim_dy;


  pitch_roll_cmd <= pitch_roll_cmd_1;

END rtl;

