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
-- File Name:                Super_Sub.adb
-- Version:                  As detailed by ClearCase
-- Version Date:             As detailed by ClearCase
-- Creation Date:            03-11-99
-- Security Classification:  Unclassified
-- Project:                  SRLE (Sting Ray Life Extension)
-- Author:                   J Mann
-- Section:                  Tactical Software/ Software Architecture
-- Division:                 Underwater Systems Division
-- Description:              Generic implementation of Supertype-Subtype relationship
-- Comments:
--
--  MODIFICATION RECORD
--  --------------------
--     NAME     DATE             ECR No            MODIFICATION
--
--     db      22/04/02        SRLE100002907     Procedure initialise removed as surplus to requirements
--
--     db      11/10/02        SRLE100003928     Remove null checks on source navigates and
--                                               calls to log.
--
--    DNS     20/05/15         CR 10265          For Navigate procedures returning a list,
--                                               the Return is now an "in" parameter
--
-- **************************************************************************************
with Generic_List;
with Root_Object;
use type Root_Object.Object_Access;
use type Root_Object.Object_List.Node_Access_Type;
with Ada.Tags;
use type Ada.Tags.Tag;

package body Super_Sub is

   Super_Side : Ada.Tags.Tag;

---------------------------------------------------------------------
   procedure Register_Super_End_Class (Super_Class : in Ada.Tags.Tag) is
   begin
      Super_Side := Super_Class;
   end Register_Super_End_Class;

---------------------------------------------------------------------
   Sub_End_Write   : Root_Object.Formalised_Relationship_Write_Type;
   Sub_End_Read    : Root_Object.Formalised_Relationship_Read_Type;
   Super_End_Write : Root_Object.Formalised_Relationship_Write_Type;
   Super_End_Read  : Root_Object.Formalised_Relationship_Read_Type;

-------------------------------------------------------------------
   procedure Register_Sub_End_Relationship_Write (To_Write : in Root_Object.Formalised_Relationship_Write_Type) is
   begin
      Sub_End_Write := To_Write;
   end Register_Sub_End_Relationship_Write;

---------------------------------------------------------------------
   procedure Register_Sub_End_Relationship_Read (To_Read : in Root_Object.Formalised_Relationship_Read_Type) is
   begin
      Sub_End_Read := To_Read;
   end Register_Sub_End_Relationship_Read;

---------------------------------------------------------------------
   procedure Register_Super_End_Relationship_Write (To_Write : in Root_Object.Formalised_Relationship_Write_Type) is
   begin
      Super_End_Write := To_Write;
   end Register_Super_End_Relationship_Write;

---------------------------------------------------------------------
   procedure Register_Super_End_Relationship_Read  (To_Read : in Root_Object.Formalised_Relationship_Read_Type) is
   begin
      Super_End_Read := To_Read;
   end Register_Super_End_Relationship_Read;

---------------------------------------------------------------------
   procedure Link (
      A_Instance : in Root_Object.Object_Access;
      B_Instance : in Root_Object.Object_Access) is

   begin

      if A_Instance.all'tag = Super_Side then
         --A-Left Link
         Sub_End_Write (A_Instance, B_Instance);
         Super_End_Write (B_Instance, A_Instance);
      elsif B_Instance.all'tag = Super_Side then
         --A-Right Link
         Super_End_Write (A_Instance, B_Instance);
         Sub_End_Write (B_Instance, A_Instance);
     end if;

   end Link;

---------------------------------------------------------------------
   procedure Unlink (
      A_Instance : in Root_Object.Object_Access;
      B_Instance : in Root_Object.Object_Access) is

   begin

      if A_Instance.all'tag = Super_Side then
         -- A-Left Unlink
         Sub_End_Write (A_Instance, null);
         Super_End_Write (B_Instance, null);

      elsif B_Instance.all'tag = Super_Side then
         -- A-Right Unlink
         Super_End_Write (A_Instance, null);
         Sub_End_Write (B_Instance, null);
      end if;

   end Unlink;

---------------------------------------------------------------------
   procedure Navigate (
      From : in  Root_Object.Object_Access;
      To   : out Root_Object.Object_Access) is

   begin

      if From.all'tag = Super_Side then
         -- A-Right Navigate
         To := Sub_End_Read (From);
      else
         --A-Left Navigate
         To := Super_End_Read (From);
     end if;

   end Navigate;
---------------------------------------------------------------------
   procedure Navigate (
      From  : in  Root_Object.Object_Access;
      Class : in  Ada.Tags.Tag;
      To    : out Root_Object.Object_Access) is

   begin

      Navigate (
         From => From,
         To   => To);

      if To /= null and then To'tag /= Class then
         To := null;
      end if;

   end Navigate;

---------------------------------------------------------------------
   procedure Navigate (
      From : in  Root_Object.Object_List.List_Header_Access_Type;
      To   : in  Root_Object.Object_List.List_Header_Access_Type) is

      The_From_Instance : Root_Object.Object_Access;
      The_To_Instance   : Root_Object.Object_Access;
      The_From_Pointer  : Root_Object.Object_List.Node_Access_Type;

   begin

      The_From_Pointer := Root_Object.Object_List.First_Entry_Of (From);

      while The_From_Pointer /= null loop

         The_From_Instance := The_From_Pointer.Item;

         Navigate (
            From => The_From_Instance,
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
   procedure Navigate (
      From  : in  Root_Object.Object_List.List_Header_Access_Type;
      Class : in  Ada.Tags.Tag;
      To    : in  Root_Object.Object_List.List_Header_Access_Type) is

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
end Super_Sub;

