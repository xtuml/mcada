with Ada.Text_IO;
with MicrowaveOven;

procedure DefineOven is
  mo        : access MicrowaveOven.MO_O;
  tube      : access MicrowaveOven.MO_MT;
  light     : access MicrowaveOven.MO_IL;
  beeper    : access MicrowaveOven.MO_B;
  door      : access MicrowaveOven.MO_D;
  turntable : access MicrowaveOven.MO_TRN;
begin
  -- // Create the instances in the system.
  -- create object instance mo of MO_O;

  -- assign mo.remaining_cooking_time = 0;

  -- create object instance tube of MO_MT;
  -- relate mo to tube across R1;
  -- assign tube.current_power_output = tube_wattage::high;

  -- create object instance light of MO_IL;
  -- relate mo to light across R2;

  -- create object instance beeper of MO_B;
  -- relate mo to beeper across R3;

  -- create object instance door of MO_D;
  -- relate mo to door across R4;
  -- assign door.is_secure = false;

  -- create object instance turntable of MO_TRN;
  -- relate mo to turntable across R5;
  
  Ada.Text_IO.Put_Line("Defining oven...");

  mo := new MicrowaveOven.MO_O'( BeeperID => 0, DoorID => 0, LightID => 0, OvenID => 0, TubeID => 0, TurntableID => 0, current_state => 0, oven_timer => 0, remaining_cooking_time => 0 );

  tube := new MicrowaveOven.MO_MT'( TubeID => 0, current_power_output => 0, current_state => 0 );
  mo.TubeID := tube.TubeID;

  light := new MicrowaveOven.MO_IL'( LightID => 0, current_state => 0 );
  mo.LightID := light.LightID;

  beeper := new MicrowaveOven.MO_B'( BeeperID => 0, beep_count => 0, beeper_delay_over => 0, beeper_timer => 0, current_state => 0 );
  mo.BeeperID := beeper.BeeperID;

  door := new MicrowaveOven.MO_D'( DoorID => 0, current_state => 0, is_secure => 0 );
  mo.DoorID := door.DoorID;

  turntable := new MicrowaveOven.MO_TRN'( TurntableID => 0, current_state => 0 );
  mo.TurntableID := turntable.TurntableID;
  
  Ada.Text_IO.Put_Line("Done.");

end DefineOven;
