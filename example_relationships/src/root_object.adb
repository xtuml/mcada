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
-- File Name:                Root_Object.adb
-- Version:                  As detailed by ClearCase
-- Version Date:             As detailed by ClearCase
-- Creation Date:            03-11-99
-- Security Classification:  Unclassified
-- Project:                  SRLE (Sting Ray Life Extension)
-- Author:                   J Mann
-- Section:                  Tactical Software/ Software Architecture
-- Division:                 Underwater Systems Division
-- Description:              Top-level object and event hierarchy implementation
-- Comments:
--
--  MODIFICATION RECORD
--  --------------------
--    NAME     DATE             ECR No            MODIFICATION
--
--    jmm     06/07/00        PILOT_0000_0247   Legacy code removed from application
--
--    db      09/07/01        PILOT_0000_0230   Remove use clause as per coding standards
--
--    db      08/02/02        SRLE100001622     Legacy code removed from application
--
--    db      18/03/02        SRLE100002754     Simplification of withing statements.
--
--    db      03/04/02        SRLE100002907     Remove Initialise_List
--
--    db      17/04/02        SRLE100003005     Removal of loitering legacy code.
--
-- **************************************************************************************
with log;

package body Root_Object is

------------------------------------------------------------------------
--*********************  Object Management *****************************
------------------------------------------------------------------------

   function Create return Object_Access is
      this: Object_Access;
   begin
      this := new Object_Type;
      return this;
   end Create;

------------------------------------------------------------------------

   procedure Description (This_Object: Object_Type) is
   begin
      Log.Put (Object_String&".Description: ID = ");
      Log.Put_Line (integer'image (This_Object.Root_Object_Attribute));
   end Description;

------------------------------------------------------------------------

   procedure Delete (Old_Object: in out Object_Access) is
   begin
      Log.Put (Object_String&".Delete");
   end Delete;

---------------------------------------------------------------------

   Root_Object_Attribute: integer := 0;

   function Get_Next_Root_Object_Attribute return integer is
   begin
      Root_Object_Attribute := Root_Object_Attribute + 1;
      return Root_Object_Attribute;
   end Get_Next_Root_Object_Attribute;

------------------------------------------------------------------------
--**************************  Event Stuff ******************************
------------------------------------------------------------------------

   procedure Do_Events is
      -- The_Object: Object_Access;
   begin
      Log.Put_Line (Object_String&" Do_Events ");
   end Do_Events ;

------------------------------------------------------------------------

   procedure Put_Event (Event:    in Root_Object.Root_Event_Access_Type;
                        To_Class: in Object_Type;
                        Top:      in boolean := false) is
   begin
      Log.Put_Line (Object_String&" Put_Event");
   end Put_Event;

--------------------------------------------------------------------------

   procedure Polymorphic_Put (This_Object: in out Object_Type;
   	                          This_Event:  in     Root_Event_Access_Type) is
   begin
      Log.Put_Line (Object_String&" Polymorphic_Put");
   end Polymorphic_Put;

--------------------------------------------------------------------------

   Root_Event_Attribute: integer := 0;

   function Get_Root_Event_Attribute return integer is
   begin
      return Root_Event_Attribute;
   end Get_Root_Event_Attribute;

--------------------------------------------------------------------------

   function Get_Next_Root_Event_Attribute return integer is
   begin
      Root_Event_Attribute := Root_Event_Attribute + 1;
      return Root_Event_Attribute;
   end Get_Next_Root_Event_Attribute;

----------------------------------------------------------------------

   procedure Process_Events (This_Event: in Root_Event_Type) is
   begin
      Log.Put_Line (Object_String&": Process_Events ");
   end Process_Events;

----------------------------------------------------------------------

   procedure Event_Action (Dispatch_Event: in     Root_Event_Type;
                           This_Event:     in out Root_Event_Access_Type) is
   begin
      Log.Put_Line (Object_String&": Event_Action ");
   end Event_Action;

------------------------------------------------------------------------
--*******************  Navigation Utilities ****************************
------------------------------------------------------------------------

   function Size_Of_Access return natural is
   begin
      return Access_Type_Size;
   end Size_Of_Access;

------------------------------------------------------------------------

   function Size_Of_Boolean return natural is
   begin
      return Boolean'Size;
   end Size_Of_Boolean;

------------------------------------------------------------------------

end Root_Object;

