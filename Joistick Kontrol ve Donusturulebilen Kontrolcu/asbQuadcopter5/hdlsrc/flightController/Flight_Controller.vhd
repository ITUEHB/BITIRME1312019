-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc\flightController\Flight_Controller.vhd
-- Created: 2019-01-13 13:17:28
-- 
-- Generated by MATLAB 9.5 and HDL Coder 3.13
-- 
-- 
-- -------------------------------------------------------------
-- Rate and Clocking Details
-- -------------------------------------------------------------
-- Model base rate: 0.005
-- Target subsystem base rate: 0.005
-- 
-- 
-- Clock Enable  Sample Time
-- -------------------------------------------------------------
-- ce_out        0.005
-- -------------------------------------------------------------
-- 
-- 
-- Output Signal                 Clock Enable  Sample Time
-- -------------------------------------------------------------
-- motors_refout                 ce_out        0.005
-- pose_refout                   ce_out        0.005
-- -------------------------------------------------------------
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: Flight_Controller
-- Source Path: flightController/Flight Controller
-- Hierarchy Level: 0
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.Flight_Controller_pkg.ALL;

ENTITY Flight_Controller IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        clk_enable                        :   IN    std_logic;
        ReferenceValueServerBus_Inport_1_controlModePosVSOrient :   IN    std_logic;
        ReferenceValueServerBus_Inport_1_pos_ref :   IN    vector_of_std_logic_vector32(0 TO 2);  -- single [3]
        ReferenceValueServerBus_Inport_1_takeoff_flag :   IN    std_logic;
        ReferenceValueServerBus_Inport_1_orient_ref :   IN    vector_of_std_logic_vector32(0 TO 2);  -- single [3]
        ReferenceValueServerBus_Inport_1_live_time_ticks :   IN    std_logic_vector(31 DOWNTO 0);  -- uint32
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
        ce_out                            :   OUT   std_logic;
        motors_refout                     :   OUT   vector_of_std_logic_vector32(0 TO 3);  -- single [4]
        pose_refout                       :   OUT   vector_of_std_logic_vector32(0 TO 7)  -- single [8]
        );
END Flight_Controller;


ARCHITECTURE rtl OF Flight_Controller IS

  -- Component Declarations
  COMPONENT Yaw
    PORT( yaw_ref                         :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          states_estim_X                  :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          states_estim_Y                  :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          states_estim_Z                  :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          states_estim_yaw                :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          states_estim_pitch              :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          states_estim_roll               :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          states_estim_dx                 :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          states_estim_dy                 :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          states_estim_dz                 :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          states_estim_p                  :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          states_estim_q                  :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          states_estim_r                  :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          yaw_1                           :   OUT   std_logic_vector(31 DOWNTO 0);  -- single
          tau_yaw                         :   OUT   std_logic_vector(31 DOWNTO 0)  -- single
          );
  END COMPONENT;

  COMPONENT XY_to_reference_orientation
    PORT( posXY                           :   IN    vector_of_std_logic_vector32(0 TO 1);  -- single [2]
          states_estim_X                  :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          states_estim_Y                  :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          states_estim_Z                  :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          states_estim_yaw                :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          states_estim_pitch              :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          states_estim_roll               :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          states_estim_dx                 :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          states_estim_dy                 :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          states_estim_dz                 :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          states_estim_p                  :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          states_estim_q                  :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          states_estim_r                  :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          yaw                             :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          pitch_roll_cmd                  :   OUT   vector_of_std_logic_vector32(0 TO 1)  -- single [2]
          );
  END COMPONENT;

  COMPONENT Attitude
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          refAttitude                     :   IN    vector_of_std_logic_vector32(0 TO 1);  -- single [2]
          states_estim_X                  :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          states_estim_Y                  :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          states_estim_Z                  :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          states_estim_yaw                :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          states_estim_pitch              :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          states_estim_roll               :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          states_estim_dx                 :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          states_estim_dy                 :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          states_estim_dz                 :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          states_estim_p                  :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          states_estim_q                  :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          states_estim_r                  :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          tau_pitch                       :   OUT   std_logic_vector(31 DOWNTO 0);  -- single
          tau_roll                        :   OUT   std_logic_vector(31 DOWNTO 0)  -- single
          );
  END COMPONENT;

  COMPONENT equilibrium_thrust
    PORT( states_estim_X                  :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          states_estim_Y                  :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          states_estim_Z                  :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          states_estim_yaw                :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          states_estim_pitch              :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          states_estim_roll               :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          states_estim_dx                 :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          states_estim_dy                 :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          states_estim_dz                 :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          states_estim_p                  :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          states_estim_q                  :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          states_estim_r                  :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          PosZ                            :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          takeoff_flag                    :   IN    std_logic;
          altitude_cmd                    :   OUT   std_logic_vector(31 DOWNTO 0)  -- single
          );
  END COMPONENT;

  COMPONENT ControlMixer
    PORT( tau_pitch                       :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          tau_roll                        :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          tau_yaw                         :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          totalThrust                     :   IN    std_logic_vector(31 DOWNTO 0);  -- single
          thrusts_refout                  :   OUT   vector_of_std_logic_vector32(0 TO 3)  -- single [4]
          );
  END COMPONENT;

  COMPONENT thrustsToMotorCommands
    PORT( thrusts_refin                   :   IN    vector_of_std_logic_vector32(0 TO 3);  -- single [4]
          motors_cmdout                   :   OUT   vector_of_std_logic_vector32(0 TO 3)  -- single [4]
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : Yaw
    USE ENTITY work.Yaw(rtl);

  FOR ALL : XY_to_reference_orientation
    USE ENTITY work.XY_to_reference_orientation(rtl);

  FOR ALL : Attitude
    USE ENTITY work.Attitude(rtl);

  FOR ALL : equilibrium_thrust
    USE ENTITY work.equilibrium_thrust(rtl);

  FOR ALL : ControlMixer
    USE ENTITY work.ControlMixer(rtl);

  FOR ALL : thrustsToMotorCommands
    USE ENTITY work.thrustsToMotorCommands(rtl);

  -- Signals
  SIGNAL orient_ref                       : vector_of_std_logic_vector32(0 TO 2);  -- ufix32 [3]
  SIGNAL controlModePosVSOrient           : std_logic;
  SIGNAL Selector2_out1                   : vector_of_std_logic_vector32(0 TO 1);  -- ufix32 [2]
  SIGNAL pos_ref                          : vector_of_std_logic_vector32(0 TO 2);  -- ufix32 [3]
  SIGNAL pos                              : vector_of_std_logic_vector32(0 TO 1);  -- ufix32 [2]
  SIGNAL orient_ref_1                     : vector_of_std_logic_vector32(0 TO 2);  -- ufix32 [3]
  SIGNAL Yaw_out1                         : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Yaw_out2                         : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL pitch_roll_cmd                   : vector_of_std_logic_vector32(0 TO 1);  -- ufix32 [2]
  SIGNAL Switch_refAtt_out1               : vector_of_std_logic_vector32(0 TO 1);  -- ufix32 [2]
  SIGNAL Attitude_out1                    : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL Attitude_out2                    : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL pos_ref_1                        : vector_of_std_logic_vector32(0 TO 2);  -- ufix32 [3]
  SIGNAL takeoff_flag                     : std_logic;
  SIGNAL gravity_feedforward_equilibrium_thrust_out1 : std_logic_vector(31 DOWNTO 0);  -- ufix32
  SIGNAL ControlMixer_out1                : vector_of_std_logic_vector32(0 TO 3);  -- ufix32 [4]
  SIGNAL thrustsToMotorCommands_out1      : vector_of_std_logic_vector32(0 TO 3);  -- ufix32 [4]
  SIGNAL pos_ref_2                        : vector_of_std_logic_vector32(0 TO 2);  -- ufix32 [3]
  SIGNAL orient_ref_2                     : vector_of_std_logic_vector32(0 TO 2);  -- ufix32 [3]
  SIGNAL Mux2_out1                        : vector_of_std_logic_vector32(0 TO 7);  -- ufix32 [8]

BEGIN
  u_Yaw : Yaw
    PORT MAP( yaw_ref => orient_ref_1(0),  -- single
              states_estim_X => states_estim_X,  -- single
              states_estim_Y => states_estim_Y,  -- single
              states_estim_Z => states_estim_Z,  -- single
              states_estim_yaw => states_estim_yaw,  -- single
              states_estim_pitch => states_estim_pitch,  -- single
              states_estim_roll => states_estim_roll,  -- single
              states_estim_dx => states_estim_dx,  -- single
              states_estim_dy => states_estim_dy,  -- single
              states_estim_dz => states_estim_dz,  -- single
              states_estim_p => states_estim_p,  -- single
              states_estim_q => states_estim_q,  -- single
              states_estim_r => states_estim_r,  -- single
              yaw_1 => Yaw_out1,  -- single
              tau_yaw => Yaw_out2  -- single
              );

  u_XY_to_reference_orientation : XY_to_reference_orientation
    PORT MAP( posXY => pos,  -- single [2]
              states_estim_X => states_estim_X,  -- single
              states_estim_Y => states_estim_Y,  -- single
              states_estim_Z => states_estim_Z,  -- single
              states_estim_yaw => states_estim_yaw,  -- single
              states_estim_pitch => states_estim_pitch,  -- single
              states_estim_roll => states_estim_roll,  -- single
              states_estim_dx => states_estim_dx,  -- single
              states_estim_dy => states_estim_dy,  -- single
              states_estim_dz => states_estim_dz,  -- single
              states_estim_p => states_estim_p,  -- single
              states_estim_q => states_estim_q,  -- single
              states_estim_r => states_estim_r,  -- single
              yaw => Yaw_out1,  -- single
              pitch_roll_cmd => pitch_roll_cmd  -- single [2]
              );

  u_Attitude : Attitude
    PORT MAP( clk => clk,
              reset => reset,
              enb => clk_enable,
              refAttitude => Switch_refAtt_out1,  -- single [2]
              states_estim_X => states_estim_X,  -- single
              states_estim_Y => states_estim_Y,  -- single
              states_estim_Z => states_estim_Z,  -- single
              states_estim_yaw => states_estim_yaw,  -- single
              states_estim_pitch => states_estim_pitch,  -- single
              states_estim_roll => states_estim_roll,  -- single
              states_estim_dx => states_estim_dx,  -- single
              states_estim_dy => states_estim_dy,  -- single
              states_estim_dz => states_estim_dz,  -- single
              states_estim_p => states_estim_p,  -- single
              states_estim_q => states_estim_q,  -- single
              states_estim_r => states_estim_r,  -- single
              tau_pitch => Attitude_out1,  -- single
              tau_roll => Attitude_out2  -- single
              );

  u_gravity_feedforward_equilibrium_thrust : equilibrium_thrust
    PORT MAP( states_estim_X => states_estim_X,  -- single
              states_estim_Y => states_estim_Y,  -- single
              states_estim_Z => states_estim_Z,  -- single
              states_estim_yaw => states_estim_yaw,  -- single
              states_estim_pitch => states_estim_pitch,  -- single
              states_estim_roll => states_estim_roll,  -- single
              states_estim_dx => states_estim_dx,  -- single
              states_estim_dy => states_estim_dy,  -- single
              states_estim_dz => states_estim_dz,  -- single
              states_estim_p => states_estim_p,  -- single
              states_estim_q => states_estim_q,  -- single
              states_estim_r => states_estim_r,  -- single
              PosZ => pos_ref_1(2),  -- single
              takeoff_flag => takeoff_flag,
              altitude_cmd => gravity_feedforward_equilibrium_thrust_out1  -- single
              );

  u_ControlMixer : ControlMixer
    PORT MAP( tau_pitch => Attitude_out1,  -- single
              tau_roll => Attitude_out2,  -- single
              tau_yaw => Yaw_out2,  -- single
              totalThrust => gravity_feedforward_equilibrium_thrust_out1,  -- single
              thrusts_refout => ControlMixer_out1  -- single [4]
              );

  u_thrustsToMotorCommands : thrustsToMotorCommands
    PORT MAP( thrusts_refin => ControlMixer_out1,  -- single [4]
              motors_cmdout => thrustsToMotorCommands_out1  -- single [4]
              );

  orient_ref <= ReferenceValueServerBus_Inport_1_orient_ref;

  controlModePosVSOrient <= ReferenceValueServerBus_Inport_1_controlModePosVSOrient;

  Selector2_out1(0) <= orient_ref(1);
  Selector2_out1(1) <= ReferenceValueServerBus_Inport_1_orient_ref(2);

  pos_ref <= ReferenceValueServerBus_Inport_1_pos_ref;

  pos(0) <= pos_ref(0);
  pos(1) <= ReferenceValueServerBus_Inport_1_pos_ref(1);

  orient_ref_1 <= ReferenceValueServerBus_Inport_1_orient_ref;

  
  Switch_refAtt_out1(0) <= Selector2_out1(0) WHEN controlModePosVSOrient = '0' ELSE
      pitch_roll_cmd(0);
  
  Switch_refAtt_out1(1) <= Selector2_out1(1) WHEN controlModePosVSOrient = '0' ELSE
      pitch_roll_cmd(1);

  pos_ref_1 <= ReferenceValueServerBus_Inport_1_pos_ref;

  takeoff_flag <= ReferenceValueServerBus_Inport_1_takeoff_flag;

  pos_ref_2 <= ReferenceValueServerBus_Inport_1_pos_ref;

  orient_ref_2 <= ReferenceValueServerBus_Inport_1_orient_ref;

  Mux2_out1(0) <= pos_ref_2(0);
  Mux2_out1(1) <= ReferenceValueServerBus_Inport_1_pos_ref(1);
  Mux2_out1(2) <= ReferenceValueServerBus_Inport_1_pos_ref(2);
  Mux2_out1(3) <= orient_ref_2(0);
  Mux2_out1(4) <= ReferenceValueServerBus_Inport_1_orient_ref(1);
  Mux2_out1(5) <= ReferenceValueServerBus_Inport_1_orient_ref(2);
  Mux2_out1(6) <= Switch_refAtt_out1(0);
  Mux2_out1(7) <= Switch_refAtt_out1(1);

  ce_out <= clk_enable;

  motors_refout <= thrustsToMotorCommands_out1;

  pose_refout <= Mux2_out1;

END rtl;

