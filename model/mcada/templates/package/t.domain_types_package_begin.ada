-- domain types package:  ${self.name}
-- description:  self.description

with Application_Types;
with Ada.Unchecked_Conversion;
with Ada.Finalization;
with Root_Object;


package ${self.name} is

    type Domain_Structure is new Ada.Finalization.Controlled with null record;
