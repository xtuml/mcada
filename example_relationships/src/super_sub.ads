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
-- File Name:                Super_Sub.ads
-- Version:                  As detailed by ClearCase
-- Version Date:             As detailed by ClearCase
-- Creation Date:            03-11-99
-- Security Classification:  Unclassified
-- Project:                  SRLE (Sting Ray Life Extension)
-- Author:                   J Mann
-- Section:                  Tactical Software/ Software Architecture
-- Division:                 Underwater Systems Division
-- Description:              Generic specification of Supertype-Subtype relationship
-- Comments:
--
--  MODIFICATION RECORD
--  --------------------
--    NAME     DATE             ECR No            MODIFICATION
--
--    db      22/04/02        SRLE100002907     Procedure initialise removed as surplus to requirements
--
--    DNS     20/05/15        CR 10265          For Navigate procedures returning a list,
--                                              the Return is now an "in" parameter
--
-- **************************************************************************************
with Root_Object;
with Ada.Tags;

generic
package Super_Sub is

   procedure Register_Super_End_Class (Super_Class: in Ada.Tags.Tag);

   procedure Register_Sub_End_Relationship_Write (To_Write : in Root_Object.Formalised_Relationship_Write_Type);
   procedure Register_Sub_End_Relationship_Read  (To_Read  : in Root_Object.Formalised_Relationship_Read_Type);

   procedure Register_Super_End_Relationship_Write (To_Write : in Root_Object.Formalised_Relationship_Write_Type);
   procedure Register_Super_End_Relationship_Read  (To_Read  : in Root_Object.Formalised_Relationship_Read_Type);

   procedure Link (
      A_Instance : in Root_Object.Object_Access;
      B_Instance : in Root_Object.Object_Access);

   procedure Unlink (
      A_Instance : in Root_Object.Object_Access;
      B_Instance : in Root_Object.Object_Access);

   procedure Navigate (
      From : in     Root_Object.Object_Access;
      To   :    out Root_Object.Object_Access);

   procedure Navigate (
      From  : in  Root_Object.Object_Access;
      Class : in  Ada.Tags.Tag;
      To    : out Root_Object.Object_Access);

   procedure Navigate (
      From : in  Root_Object.Object_List.List_Header_Access_Type;
      To   : in  Root_Object.Object_List.List_Header_Access_Type);

   procedure Navigate (
      From  : in  Root_Object.Object_List.List_Header_Access_Type;
      Class : in  Ada.Tags.Tag;
      To    : in  Root_Object.Object_List.List_Header_Access_Type);
------------------------------------------------------------------------------------------------------

end Super_Sub;
