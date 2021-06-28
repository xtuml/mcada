
with System;
--

package Application_Types is

   type Time_Unit is (millisecond, second);
   Time_Unit_First: constant Time_Unit := Time_Unit'first;

   ----------------------------------------------------------------------------------------------

   type Base_Integer_Type is new integer;

   function "+" (A   : Base_Integer_Type;
                 B   : Base_Integer_Type) return Base_Integer_Type;

   function "-" (A   : Base_Integer_Type;
                 B   : Base_Integer_Type) return Base_Integer_Type;

   function "*" (A   : Base_Integer_Type;
                 B   : Base_Integer_Type) return Base_Integer_Type;

   function "/" (Numerator   : Base_Integer_Type;
                 Denominator : Base_Integer_Type) return Base_Integer_Type;

   type Base_Float_Type is new float;

   function "+" (A   : Base_Float_Type;
                 B   : Base_Float_Type) return Base_Float_Type;

   function "-" (A   : Base_Float_Type;
                 B   : Base_Float_Type) return Base_Float_Type;

   function "*" (A   : Base_Float_Type;
                 B   : Base_Float_Type) return Base_Float_Type;

   function "/" (Numerator   : Base_Float_Type;
                 Denominator : Base_Float_Type) return Base_Float_Type;

   function "**" (A   : Base_Float_Type;
                  B   : Integer) return Base_Float_Type;

   -- Do not change this value without exceedingly good reasons.
   Maximum_Number_Of_Characters_In_String : constant Positive := 32;

   subtype Base_Text_Index_Type is Positive range 1 .. Maximum_Number_Of_Characters_In_String;

   subtype Base_Text_Type is string (Base_Text_Index_Type'range);

   subtype Base_Boolean_Type is Boolean;


   ----------------------------------------------------------------------------------------------

   Base_Integer_Type_First : constant Base_Integer_Type := 0;
   Base_Float_Type_First   : constant Base_Float_Type   := 0.0;
   Base_Boolean_Type_First : constant Boolean           := False;
   Boolean_First           : constant Boolean           := False; -- To be depracated by Base_Boolean_Type_First
   Base_Text_Type_First    : constant Base_Text_Type    := (others => ' ');
   Time_First              : constant Base_Integer_Type := 0;

   ----------------------------------------------------------------------------------------------
   -- JM Debug code GLOBAL DATA ACCESS for Debugging purposes.
   --
   Count_Of_Objects       : integer := 0;
   Count_Of_Relationships : integer := 0;
   Count_Of_Lists         : integer := 0;
   Count_Of_Structures    : integer := 0;
   Count_Of_Events        : integer := 0;

   ----------------------------------------------------------------------------------------------
   --

   -- This is a hard coded value, and should therefore be changed if any new
   -- type or subtype is added. The count includes :
   -- (1) Time_Unit
   -- (2) Base_Integer_Type
   -- (3) Base_Float_Type
   -- (4) Base_Boolean_Type
   -- (5) Base_Text_Type
   -- (6) Base_Text_Index_Type
   Types_And_Subtypes_Count : constant Base_Integer_Type := 6;
   Stop_Application : exception;

   ----------------------------------------------------------------------------------------------
end Application_Types;

