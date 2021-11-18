with Ada.Text_IO;

-- List of objects used
with Root_Object.MicrowaveOven.MO_O;

with Root_Object;

-- package body MicrowaveOven_defineoven_service is

   procedure MicrowaveOven_defineoven is

      a : Integer;

   begin
      -- a := Root_Object.MicrowaveOven.MO_O.remaining_cooking_time;
      a := 1;
      Ada.Text_IO.Put_Line("Defining oven...");

   end MicrowaveOven_defineoven;

-- end MicrowaveOven_defineoven_service;
