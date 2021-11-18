-- *************************************************************************************
--
-- The recipient is warned that this code should be handled in accordance
-- with the HM Government Security Classification indicated throughout.
--
-- This code and its contents shall not be used for other than UK Government
-- purposes.
--
-- The copyright in this code is the property of BAE SYSTEMS Electronic Systems Limited.
-- The Code is supplied by BAE SYSTEMS on the express terms that it is to be treated in
-- confidence and that it may not be copied, used or disclosed to others for any
-- purpose except in accordance with DEFCON 91 (Edn 10/92).
--
-- File Name:                One_To_Many.adb
-- Version:                  As detailed by ClearCase
-- Version Date:             As detailed by ClearCase
-- Creation Date:            03-11-99
-- Security Classification:  Unclassified
-- Project:                  SRLE (Sting Ray Life Extension)
-- Author:                   J Mann
-- Section:                  Tactical Software/ Software Architecture
-- Division:                 Underwater Systems Division
-- Description:              Generic implementation of 1:M relationship
-- Comments:
--
--  MODIFICATION RECORD
--  --------------------
--     NAME     DATE             ECR No            MODIFICATION
--
--    jmm     25/04/00        PILOT_0000_0325   Increase length of role to 32 characters for compatibility with
--                                              type base_text_type.
--
--    jmm     27/04/00        PILOT_0000_0331   Introduce extra tests to make navigate cope with
--                                              null instances.
--
--    jmm     28/06/00        PILOT_0000_0423   Include diagnostic references.
--
--    db      24/09/01        PILOT_0000_0230   Coding Standards.
--
--    db      22/04/02        SRLE100002907     Procedure initialise removed as surplus to requirements
--
--    db      09/05/02        SRLE100002899     Role phrase string is limited to 32 characters
--                                              by calling routine, no checks necessary here.
--
--    db      11/10/02        SRLE100003928     Remove belt and braces checks, and logging
--
--    db      03/12/02        SRLE100004150     Add extra check for navigate from empty set.
--
--    DNS     20/05/15        CR 10265          For Navigate procedures returning a list,
--                                              the Return is now an "in" parameter
--
-- **************************************************************************************
with Generic_List;

with Root_Object;
use type Root_Object.Object_Access;
use type Root_Object.Object_List.Node_Access_Type;
--
-- PILOT_0000_0423   Include diagnostic references.
--
with Application_Types;

with Ada.Tags;
use type Ada.Tags.Tag;

package body One_To_Many is

   subtype Role_Phrase_Type is string (1 .. Application_Types.Maximum_Number_Of_Characters_In_String);

   Left_Side             :  Ada.Tags.Tag;
   Left_Side_Role        : Role_Phrase_Type;
   Left_Side_Role_Length : natural;

   Right_Side             : Ada.Tags.Tag;
   Right_Side_Role        : Role_Phrase_Type;
   Right_Side_Role_Length : natural;
   --
   -- A = LEFT  = MULTIPLE
   -- B = RIGHT = SINGLE
   --
---------------------------------------------------------------------

   procedure Register_A_End_Class (A_Instance: in Ada.Tags.Tag) is

   begin
      Left_Side := A_Instance;
   end Register_A_End_Class;

---------------------------------------------------------------------

   procedure Register_A_End_Role (A_Role: in string) is

   begin
      Left_Side_Role (1 .. A_Role'length) := A_Role;
      Left_Side_Role_Length               := A_Role'length;
   end Register_A_End_Role;

---------------------------------------------------------------------

   function Report_A_End_Role return string is

   begin
      return Left_Side_Role (1 .. Left_Side_Role_Length);
   end Report_A_End_Role;

---------------------------------------------------------------------

   procedure Register_B_End_Class (B_Instance: in Ada.Tags.Tag) is

   begin
      Right_Side := B_Instance;
   end Register_B_End_Class;

---------------------------------------------------------------------

   procedure Register_B_End_Role (B_Role: in string) is

   begin
      Right_Side_Role (1 .. B_Role'length) := B_Role;
      Right_Side_Role_Length               := B_Role'length;
   end Register_B_End_Role;

---------------------------------------------------------------------

   function Report_B_End_Role return string is

   begin
      return Right_Side_Role (1 .. Right_Side_Role_Length);
   end Report_B_End_Role;

---------------------------------------------------------------------

   B_End_Write : Root_Object.Formalised_Relationship_Write_Type;
   B_End_Read  : Root_Object.Formalised_Relationship_Read_Type;

   A_End_Write : Root_Object.Formalised_Multiple_Relationship_Write_Type;
   A_End_Read  : Root_Object.Formalised_Multiple_Relationship_Read_Type;

---------------------------------------------------------------------

   procedure Register_B_End_Relationship_Write (To_Write: in Root_Object.Formalised_Relationship_Write_Type) is

   begin
      B_End_Write := To_Write;
   end Register_B_End_Relationship_Write;

---------------------------------------------------------------------

   procedure Register_B_End_Relationship_Read (To_Read: in Root_Object.Formalised_Relationship_Read_Type) is

   begin
      B_End_Read := To_Read;
   end Register_B_End_Relationship_Read;

---------------------------------------------------------------------

   procedure Register_A_End_Relationship_Write (To_Write: in Root_Object.Formalised_Multiple_Relationship_Write_Type) is

   begin
      A_End_Write := To_Write;
   end Register_A_End_Relationship_Write;

---------------------------------------------------------------------

   procedure Register_A_End_Relationship_Read (To_Read: in Root_Object.Formalised_Multiple_Relationship_Read_Type) is

   begin
      A_End_Read := To_Read;
   end Register_A_End_Relationship_Read;

---------------------------------------------------------------------

   procedure Link (
      A_Instance : in Root_Object.Object_Access;
      B_Instance : in Root_Object.Object_Access) is

   begin

      if A_Instance.all'tag = Left_Side then


         B_End_Write (
            This_Object  => A_Instance,
            Remote_Value => B_Instance);

         Root_Object.Object_List.Insert (
            New_Item => A_Instance,
            On_To    => A_End_Read(This_Object => B_Instance));
         --
         -- PILOT_0000_0423   Include diagnostic references.
         --
         Application_Types.Count_Of_Relationships := Application_Types.Count_Of_Relationships + 1;

      elsif A_Instance.all'tag = Right_Side then


         Root_Object.Object_List.Insert (
            New_Item => B_Instance,
            On_To    => A_End_Read(A_Instance));

         B_End_Write (
            This_Object  => B_Instance,
            Remote_Value => A_Instance);
         --
         -- PILOT_0000_0423   Include diagnostic references.
         --
         Application_Types.Count_Of_Relationships := Application_Types.Count_Of_Relationships + 1;

      end if;

   end Link;

---------------------------------------------------------------------

   procedure Link (
      A_Instance : in Root_Object.Object_Access;
      B_Role     : in string;
      B_Instance : in Root_Object.Object_Access) is

   begin


      if B_Role = Right_Side_Role (1 .. Right_Side_Role_Length) then


         B_End_Write (
            This_Object  => A_Instance,
            Remote_Value => B_Instance);

         Root_Object.Object_List.Insert (
            New_Item => A_Instance,
            On_To    => A_End_Read (This_Object => B_Instance));

         --
         -- PILOT_0000_0423   Include diagnostic references.
         --
         Application_Types.Count_Of_Relationships := Application_Types.Count_Of_Relationships + 1;

      elsif B_Role = Left_Side_Role (1.. Left_Side_Role_Length) then


         Root_Object.Object_List.Insert (
            New_Item => B_Instance,
            On_To    => A_End_Read (This_Object => A_Instance));

         B_End_Write (
            This_Object  => B_Instance,
            Remote_Value => A_Instance);

         --
         -- PILOT_0000_0423   Include diagnostic references.
         --
         Application_Types.Count_Of_Relationships := Application_Types.Count_Of_Relationships + 1;

      end if;

   end Link;
---------------------------------------------------------------------

   procedure Local_Delete (
      Old_Instance : in     Root_Object.Object_Access;
      From_List    : in out Root_Object.Object_List.List_Header_Access_Type) is

      Temp_Entry: Root_Object.Object_List.Node_Access_Type;

   begin

      Temp_Entry := Root_Object.Object_List.First_Entry_Of (Target_List => From_List);

      -- if Temp_Entry = null then
      --  end if;

      while Temp_Entry /= null loop
         if Temp_Entry.Item = Old_Instance then

            Root_Object.Object_List.Delete (
               Item => Temp_Entry,
               From => From_List);

          exit;

        end if;

        Temp_Entry := Root_Object.Object_List.Next_Entry_Of (Target_List => From_List);

      end loop;

    end Local_Delete;

---------------------------------------------------------------------

   procedure Unlink (
      A_Instance : in Root_Object.Object_Access;
      B_Instance : in Root_Object.Object_Access) is

      Target_List: Root_Object.Object_List.List_Header_Access_Type;

   begin

      if A_Instance.all'tag = Left_Side then


         B_End_Write (
            This_Object  => A_Instance,
            Remote_Value => null);

         Target_List := A_End_Read (This_Object => B_Instance);

         Local_Delete (
            Old_Instance => A_Instance,
            From_List    => Target_List);

         --
         -- PILOT_0000_0423   Include diagnostic references.
         --
         Application_Types.Count_Of_Relationships := Application_Types.Count_Of_Relationships - 1;

      elsif A_Instance.all'tag = Right_Side then


         B_End_Write (
            This_Object  => B_Instance,
            Remote_Value => null);

         Target_List := A_End_Read(This_Object => A_Instance);

         Local_Delete (
            Old_Instance => B_Instance,
            From_List    => Target_List);

       --
       -- PILOT_0000_0423   Include diagnostic references.
       --
         Application_Types.Count_Of_Relationships := Application_Types.Count_Of_Relationships - 1;

      end if;

   end Unlink;

---------------------------------------------------------------------

   procedure Unlink (
      A_Instance : in Root_Object.Object_Access;
      B_Role     : in string;
      B_Instance : in Root_Object.Object_Access) is

      Target_List: Root_Object.Object_List.List_Header_Access_Type;

   begin

      if B_Role = Right_Side_Role (1..B_Role'length) then

         B_End_Write (
            This_Object  => A_Instance,
            Remote_Value => null);

         Target_List := A_End_Read(This_Object => B_Instance);

         Local_Delete (
            Old_Instance => A_Instance,
            From_List    => Target_List);

         --
         -- PILOT_0000_0423   Include diagnostic references.
         --
         Application_Types.Count_Of_Relationships := Application_Types.Count_Of_Relationships - 1;

      elsif B_Role = Left_Side_Role (1..B_Role'length) then


         B_End_Write (
            This_Object  => B_Instance,
            Remote_Value => null);

         Target_List := A_End_Read(This_Object => A_Instance);

         Local_Delete (
            Old_Instance => B_Instance,
            From_List    => Target_List);

         --
         -- PILOT_0000_0423   Include diagnostic references.
         --
         Application_Types.Count_Of_Relationships := Application_Types.Count_Of_Relationships - 1;


      end if;

   end Unlink;

---------------------------------------------------------------------

   procedure Navigate (
      From  : in     Root_Object.Object_Access;
      Class : in     Ada.Tags.Tag;
      To    :    out Root_Object.Object_Access) is
      --
      -- this procedure is defined ONLY for navigates from the 'M' to the '1'.
      --
   begin

      To := null;

      if Class = Right_Side then

         To := B_End_Read (This_Object => From);

      end if;

   end Navigate;

---------------------------------------------------------------------

   procedure Navigate (
      From  : in     Root_Object.Object_Access;
      Class : in     Ada.Tags.Tag;
      To    : in     Root_Object.Object_List.List_Header_Access_Type) is
   --
   -- this procedure is defined ONLY for navigates from the '1' to the 'M'.
   --
     Temp_Right:     Root_Object.Object_List.Node_Access_Type;

   begin

      if Class = Left_Side then

         Temp_Right := Root_Object.Object_List.First_Entry_Of (Target_List => A_End_Read (This_Object => From));

         while Temp_Right /= null loop

            Root_Object.Object_List.Insert (
               New_Item => Temp_Right.Item,
               On_To    => To );

            Temp_Right := Root_Object.Object_List.Next_Entry_Of (Target_List => A_End_Read (This_Object => From));

         end loop; -- while Temp_Entry /= null

      end if;

   end Navigate;

---------------------------------------------------------------------

   procedure Navigate (
      From  : in     Root_Object.Object_List.List_Header_Access_Type;
      Class : in     Ada.Tags.Tag;
      To    : in     Root_Object.Object_List.List_Header_Access_Type) is
      --
      -- this procedure is defined for BOTH for navigates from the 'M' to the '1' AND from the '1' to the 'M'
      --
      The_From_Instance: Root_Object.Object_Access;
      The_To_Instance:   Root_Object.Object_Access;
      The_From_Pointer:  Root_Object.Object_List.Node_Access_Type;

   begin

      The_From_Pointer := Root_Object.Object_List.First_Entry_Of (Target_List => From);

      if The_From_Pointer /= null then

         The_From_Instance := The_From_Pointer.Item;

         if The_From_Instance.all'tag = Left_Side then

            while The_From_Pointer /= null loop

               The_From_Instance := The_From_Pointer.Item;

               Navigate (
                  From  => The_From_Instance,
                  Class => Class,
                  To    => The_To_Instance);

               if The_To_Instance /= null then

                  Root_Object.Object_List.Insert (
                     New_Item => The_To_Instance,
                     On_To    => To );

               end if;

               The_From_Pointer := Root_Object.Object_List.Next_Entry_Of (Target_List => From);

            end loop;

         elsif The_From_Instance.all'tag = Right_Side then

            while The_From_Pointer /= null loop

               The_From_Instance := The_From_Pointer.Item;

               Navigate (
                  From  => The_From_Instance,
                  Class => Class,
                  To    => To);

               The_From_Pointer := Root_Object.Object_List.Next_Entry_Of (Target_List => From);

            end loop;

         end if;

      end if;

   end Navigate;

---------------------------------------------------------------------

   procedure Navigate (
      From : in     Root_Object.Object_Access;
      Role : in     string;
      To   :    out Root_Object.Object_Access) is
      --
      -- this procedure is defined ONLY for navigates from the 'M' to the '1'.
      --
   begin

      To := null;

      if From.all'tag = Left_Side and then Role = Right_Side_Role (1.. Right_Side_Role_Length) then
         To := B_End_Read (This_Object => From);
      end if;

   end Navigate;

---------------------------------------------------------------------

   procedure Navigate (
      From : in     Root_Object.Object_Access;
      Role : in     string;
      To   : in     Root_Object.Object_List.List_Header_Access_Type) is
      --
      -- this procedure is defined ONLY for navigates from the '1' to the 'M'.
      --

      Temp_Right:     Root_Object.Object_List.Node_Access_Type;

   begin

      if From.all'tag = Right_Side and then Role = Left_Side_Role (1.. Left_Side_Role_Length) then

         Temp_Right := Root_Object.Object_List.First_Entry_Of (Target_LIst => A_End_Read (This_Object => From));

         while Temp_Right /= null loop

            Root_Object.Object_List.Insert (
               New_Item => Temp_Right.Item,
               On_To    => To );

            Temp_Right := Root_Object.Object_List.Next_Entry_Of (Target_List => A_End_Read (This_Object => From));

         end loop; -- while Temp_Entry /= null

      end if;

   end Navigate;

---------------------------------------------------------------------

   procedure Navigate (
      From : in     Root_Object.Object_List.List_Header_Access_Type;
      Role : in     string;
      To   : in     Root_Object.Object_List.List_Header_Access_Type) is
      --
      -- this procedure is defined for BOTH for navigates from the 'M' to the '1' AND from the '1' to the 'M'
      --
      The_From_Instance: Root_Object.Object_Access;
      The_To_Instance:   Root_Object.Object_Access;
      The_From_Pointer:  Root_Object.Object_List.Node_Access_Type;
   begin
      The_From_Pointer := Root_Object.Object_List.First_Entry_Of (From);
      --
      -- Check that The_From_Pointer /= null
      --
      if The_From_Pointer /= null then
         The_From_Instance := The_From_Pointer.Item;
         --
         -- Check that The_From_Instance /= null
         --
         if The_From_Instance /= null then
            if The_From_Instance.all'tag = Left_Side and then Role = Right_Side_Role (1.. Right_Side_Role_Length) then
               --
               -- M -> 1."role" navigate
               --
               while The_From_Pointer /= null loop

                  The_From_Instance := The_From_Pointer.Item;

                  Navigate (From => The_From_Instance,
                            Role => Role,
                            To   => The_To_Instance);

                  if The_To_Instance /= null then

                     Root_Object.Object_List.Insert (
                        New_Item => The_To_Instance,
                        On_To    => To );

                  end if;

                 The_From_Pointer := Root_Object.Object_List.Next_Entry_Of (Target_List => From);

               end loop;

            elsif The_From_Instance.all'tag = Right_Side and then Role = Left_Side_Role (1.. Left_Side_Role_Length) then
               --
               -- 1 -> M."role" navigate
               --

               while The_From_Pointer /= null loop

                  The_From_Instance := The_From_Pointer.Item;

                  Navigate (
                     From => The_From_Instance,
                     Role => Role,
                     To   => To);

                  The_From_Pointer := Root_Object.Object_List.Next_Entry_Of (Target_List => From);

               end loop;

            end if;

         end if;

      end if;

   end Navigate;

-----------------------------------------------------------------------

end One_To_Many;

