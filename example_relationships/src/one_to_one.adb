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
-- File Name:                One_To_One.ads
-- Version:                  As detailed by ClearCase
-- Version Date:             As detailed by ClearCase
-- Creation Date:            03-11-99
-- Security Classification:  Unclassified
-- Project:                  SRLE (Sting Ray Life Extension)
-- Author:                   J Mann
-- Section:                  Tactical Software/ Software Architecture
-- Division:                 Underwater Systems Division
-- Description:              Generic implementation of 1-1 relationship
-- Comments:
--
--  MODIFICATION RECORD
--  --------------------
--     NAME     DATE             ECR No            MODIFICATION
--
--    jmm     25/04/00        PILOT_0000_0325   Increase length of role to 32 characters for compatibility with
--                                              type base_text_type.
--
--    jmm     27/04/00        PILOT_0000_0331   Introduce extra tests to make unlink and navigate cope with
--                                              role names.
--
--    db      22/04/02        SRLE100002907     Procedure initialise removed as surplus to requirements
--
--    db      09/05/02        SRLE100002899     Role phrase string is limited to 32 characters
--                                              by calling routine, no checks necessary here.
--
--    db      11/10/02        SRLE100003928     Remove belt and braces checks, and logging
--
--    DNS     20/05/15        CR 10265          For Navigate procedures returning a list,
--                                              the Return is now an "in" parameter
--
-- **************************************************************************************
with Generic_List;
with Root_Object;
with Application_Types;

use type Root_Object.Object_Access;
use type Root_Object.Object_List.Node_Access_Type;
with Ada.Tags;
use type Ada.Tags.Tag;

package body One_To_One is

------------------------------------------------------------------------

   subtype Role_Phrase_Type is string (1 .. Application_Types.Maximum_Number_Of_Characters_In_String);

   Left_Side             :  Ada.Tags.Tag;
   Left_Side_Role        : Role_Phrase_Type;
   Left_Side_Role_Length : natural;

   Right_Side             : Ada.Tags.Tag;
   Right_Side_Role        : Role_Phrase_Type;
   Right_Side_Role_Length : natural;

---------------------------------------------------------------------
   procedure Register_A_End_Class (A_Class : in Ada.Tags.Tag) is
   begin
      Left_Side := A_Class;
   end Register_A_End_Class;
---------------------------------------------------------------------
   procedure Register_B_End_Class (B_Class : in Ada.Tags.Tag) is
   begin
      Right_Side := B_Class;
   end Register_B_End_Class;
---------------------------------------------------------------------
   procedure Register_A_End_Role (A_Role : in string) is
   begin
      Left_Side_Role (1 .. A_Role'length) := A_Role;
      Left_Side_Role_Length             := A_Role'length;
   end Register_A_End_Role;
---------------------------------------------------------------------
   procedure Register_B_End_Role (B_Role : in string) is
   begin
      Right_Side_Role (1..B_Role'length) := B_Role;
      Right_Side_Role_Length             := B_Role'length;
   end Register_B_End_Role;
---------------------------------------------------------------------
   function Report_A_End_Role return string is
   begin
      return Left_Side_Role (1 .. Left_Side_Role'length);
   end Report_A_End_Role;
---------------------------------------------------------------------
   function Report_B_End_Role return string is
   begin
      return Right_Side_Role (1 .. Right_Side_Role'length);
   end Report_B_End_Role;
---------------------------------------------------------------------
   A_End_Write : Root_Object.Formalised_Relationship_Write_Type;
   A_End_Read  : Root_Object.Formalised_Relationship_Read_Type;

   B_End_Write : Root_Object.Formalised_Relationship_Write_Type;
   B_End_Read  : Root_Object.Formalised_Relationship_Read_Type;

---------------------------------------------------------------------
   procedure Register_A_End_Relationship_Write (To_Write : in Root_Object.Formalised_Relationship_Write_Type) is
   begin
      A_End_Write := To_Write;
   end Register_A_End_Relationship_Write;

---------------------------------------------------------------------
   procedure Register_A_End_Relationship_Read (To_Read : in Root_Object.Formalised_Relationship_Read_Type) is
   begin
      A_End_Read := To_Read;
   end Register_A_End_Relationship_Read;

---------------------------------------------------------------------
   procedure Register_B_End_Relationship_Write (To_Write : in Root_Object.Formalised_Relationship_Write_Type) is
   begin
      B_End_Write := To_Write;
   end Register_B_End_Relationship_Write;

---------------------------------------------------------------------
   procedure Register_B_End_Relationship_Read (To_Read : in Root_Object.Formalised_Relationship_Read_Type) is
   begin
      B_End_Read := To_Read;
   end Register_B_End_Relationship_Read;

---------------------------------------------------------------------
   procedure Link (
      A_Instance : in Root_Object.Object_Access;
      B_Instance : in Root_Object.Object_Access) is

   begin

      if A_Instance.all'tag = Left_Side then
         -- A-Left Link");
         A_End_Write (A_Instance, B_Instance);
         B_End_Write (B_Instance, A_Instance);
      elsif A_Instance.all'tag = Right_Side then
         --One_To_One: A-Right Link");
         B_End_Write (A_Instance, B_Instance);
         A_End_Write (B_Instance, A_Instance);
      end if;
   end Link;

---------------------------------------------------------------------
   procedure Link (
      A_Instance : in Root_Object.Object_Access;
      B_Role     : in string;
      B_Instance : in Root_Object.Object_Access) is

   begin

      if B_Role = Right_Side_Role (1.. Right_Side_Role_Length) then
         -- One_To_One: A-Right Link");
         A_End_Write (A_Instance, B_Instance);
         B_End_Write (B_Instance, A_Instance);
      elsif B_Role = Left_Side_Role (1.. Left_Side_Role_Length) then
         -- One_To_One: A-Left Link");
         B_End_Write (A_Instance, B_Instance);
         A_End_Write (B_Instance, A_Instance);
      end if;
   end Link;

---------------------------------------------------------------------
   procedure Unlink (
      A_Instance : in Root_Object.Object_Access;
      B_Instance : in Root_Object.Object_Access) is

   begin

      if A_Instance.all'tag = Left_Side then
         -- One_To_One: A-Left Unlink
         A_End_Write (A_Instance, null);
         B_End_Write (B_Instance, null);
      elsif A_Instance.all'tag = Right_Side then
         -- One_To_One: A-Right Unlink
         B_End_Write (A_Instance, null);
         A_End_Write (B_Instance, null);
      end if;
   end Unlink;

---------------------------------------------------------------------
   procedure Unlink (
      A_Instance : in Root_Object.Object_Access;
      B_Role     : in string;
      B_Instance : in Root_Object.Object_Access) is

   begin

      if B_Role = Right_Side_Role (1.. Right_Side_Role_Length) then
         --One_To_One: A-Right Link
         A_End_Write (A_Instance, null);
         B_End_Write (B_Instance, null);
      elsif B_Role = Left_Side_Role (1.. Left_Side_Role_Length) then
         -- One_To_One: A-Left Link
         B_End_Write (A_Instance, null);
         A_End_Write (B_Instance, null);
      end if;
   end Unlink;

---------------------------------------------------------------------
   procedure Navigate (
      From  : in     Root_Object.Object_Access;
      Class : in     Ada.Tags.Tag;
      To    :    out Root_Object.Object_Access) is

   begin

      if From /= null then
         if From.all'tag = Left_Side and then Class = Right_Side then
            -- One_To_One: A-Right Navigate
            To := A_End_Read (From);
         elsif From.all'tag = Right_Side and then Class = Left_Side then
            --One_To_One: A-Left Navigate
            To := B_End_Read (From);
         else
            To := null;
         end if;
      else
         To := null;
      end if;
   end Navigate;

---------------------------------------------------------------------
   procedure Navigate (
      From : in     Root_Object.Object_Access;
      Role : in     string;
      To   :    out Root_Object.Object_Access) is

   begin

      if From /= null then
         if From.all'tag = Left_Side and then Role = Right_Side_Role (1.. Right_Side_Role_Length) then
            -- One_To_One: A-Right Navigate
            To := A_End_Read (From);
         elsif From.all'tag = Right_Side and then Role = Left_Side_Role (1.. Left_Side_Role_Length) then
            --One_To_One: A-Left Navigate
            To := B_End_Read (From);
         else
            To := null;
         end if;
      else -- From = null
         To := null;
      end if;
   end Navigate;

---------------------------------------------------------------------
 procedure Navigate (
      From  : in     Root_Object.Object_List.List_Header_Access_Type;
      Class : in     Ada.Tags.Tag;
      To    : in     Root_Object.Object_List.List_Header_Access_Type) is

      The_From_Instance : Root_Object.Object_Access;
      The_To_Instance   : Root_Object.Object_Access;
      The_From_Pointer  : Root_Object.Object_List.Node_Access_Type;

   begin

      The_From_Pointer := Root_Object.Object_List.First_Entry_Of (From);

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

         The_From_Pointer := Root_Object.Object_List.Next_Entry_Of (From);

      end loop;

   end Navigate;

---------------------------------------------------------------------
   procedure Navigate (
      From : in     Root_Object.Object_List.List_Header_Access_Type;
      Role : in     string;
      To   : in     Root_Object.Object_List.List_Header_Access_Type) is

      The_From_Instance : Root_Object.Object_Access;
      The_To_Instance   : Root_Object.Object_Access;
      The_From_Pointer  : Root_Object.Object_List.Node_Access_Type;

   begin

      The_From_Pointer := Root_Object.Object_List.First_Entry_Of (From);

      while The_From_Pointer /= null loop

         The_From_Instance := The_From_Pointer.Item;

         Navigate (
            From => The_From_Instance,
            Role => Role,
            To   => The_To_Instance);

         if The_To_Instance /= null then
            Root_Object.Object_List.Insert (
               New_Item => The_To_Instance,
               On_To    => To );
         end if;

         The_From_Pointer := Root_Object.Object_List.Next_Entry_Of (From);
      end loop;

   end Navigate;

---------------------------------------------------------------------

end One_To_One;
