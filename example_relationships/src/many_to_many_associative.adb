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
-- File Name:                Many_To_Many_Associative.adb
-- Version:                  As detailed by ClearCase
-- Version Date:             As detailed by ClearCase
-- Creation Date:            03-11-99
-- Security Classification:  Unclassified
-- Project:                  SRLE (Sting Ray Life Extension)
-- Author:                   J Mann
-- Section:                  Tactical Software/ Software Architecture
-- Division:                 Underwater Systems Division
-- Description:              Generic implementation of 1-M:M relationship
-- Comments:
--
--  MODIFICATION RECORD
--  --------------------
--     NAME     DATE             ECR No            MODIFICATION
--
--     DB       24/09/01         PILOT_0000_2473   Rename Link, Unlink & Unassociate parameters
--                                                 to match those for 1:1 type relationships,
--                                                 at the request of George.
--
--     db      17/04/02          SRLE100003005     Correlated associative navigations supported.
--
--     db      22/04/02          SRLE100002907     Procedure initialise removed as surplus to requirements
--
--     db      09/05/02          SRLE100002899     Role phrase string is limited to 32 characters
--                                                 by calling routine, no checks necessary here.
--
--     db      14/08/02          SRLE100003644     Correlated associative navigations leave
--                                                 iteration lists on the heap, remove them.
--
--     db      10/10/02          SRLE100003928     Remove null checks on source navigates and
--                                                 calls to log.
--
--     db      03/12/02          SRLE100004150     Add extra check for navigate from empty set
--
--     DNS     20/05/15          CR 10265          For Navigate procedures returning a list,
--                                                 the Return is now an "in" parameter
--
-- **************************************************************************************

with Root_Object;
use type Root_Object.Object_Access;
use type Root_Object.Object_List.Node_Access_Type;

with Ada.Tags;
use type Ada.Tags.Tag;

with One_To_Many_Associative;

package body Many_To_Many_Associative is

------------------------------------------------------------------------

   package M1_Single_M2_Multiple is new One_To_Many_Associative;
   package M2_Single_M1_Multiple is new One_To_Many_Associative;

------------------------------------------------------------------------

   M1_Side:  Ada.Tags.Tag;
   M2_Side: Ada.Tags.Tag;
   Associative_Side: Ada.Tags.Tag;

---------------------------------------------------------------------
   procedure Register_M1_End_Class (M1_Instance: in Ada.Tags.Tag) is
   begin
      M1_Side := M1_Instance;
      M1_Single_M2_Multiple.Register_Single_End_Class (M1_Instance);
      M2_Single_M1_Multiple.Register_Multiple_End_Class (M1_Instance);
   end Register_M1_End_Class;

---------------------------------------------------------------------

   function Report_M1_End_Class return Ada.Tags.Tag is
   begin
      return M1_Side;
   end Report_M1_End_Class;

-----------------------------------------------------------------------

   procedure Register_M2_End_Class (M2_Instance: in Ada.Tags.Tag) is
   begin
      M2_Side := M2_Instance;
      M1_Single_M2_Multiple.Register_Multiple_End_Class (M2_Instance);
      M2_Single_M1_Multiple.Register_Single_End_Class (M2_Instance);
   end Register_M2_End_Class;

---------------------------------------------------------------------

   function Report_M2_End_Class return Ada.Tags.Tag is
   begin
      return M2_Side;
   end Report_M2_End_Class;

-----------------------------------------------------------------------

   procedure Register_Associative_End_Class (Associative_Instance: in Ada.Tags.Tag) is
   begin
      Associative_Side := Associative_Instance;
      M1_Single_M2_Multiple.Register_Associative_End_Class (Associative_Instance);
      M2_Single_M1_Multiple.Register_Associative_End_Class (Associative_Instance);
   end Register_Associative_End_Class;

---------------------------------------------------------------------

   function Report_Associative_End_Class return Ada.Tags.Tag is
   begin
      return Associative_Side;
   end Report_Associative_End_Class;

---------------------------------------------------------------------

   procedure Link (
      A_Instance : in Root_Object.Object_Access;
      B_Instance : in Root_Object.Object_Access;
      Using      : in Root_Object.Object_Access) is

  begin

    M1_Single_M2_Multiple.Link (
       A_Instance => A_Instance,
       B_Instance => B_Instance,
       Using      => Using);

    M2_Single_M1_Multiple.Link (
       A_Instance => A_Instance,
       B_Instance => B_Instance,
       Using      => Using);

   end Link;
-----------------------------------------------------------------------
   procedure Unassociate (
      A_Instance : in Root_Object.Object_Access;
      B_Instance : in Root_Object.Object_Access;
      From       : in Root_Object.Object_Access) is

   begin

      M1_Single_M2_Multiple.Unassociate (
         A_Instance => A_Instance,
         B_Instance => B_Instance,
         From       => From);

      M2_Single_M1_Multiple.Unassociate (
         A_Instance => B_Instance,
         B_Instance => A_Instance,
         From       => From);

   end Unassociate;

-----------------------------------------------------------------------

   procedure Unlink (
      A_Instance : in Root_Object.Object_Access;
      B_Instance : in Root_Object.Object_Access) is

   begin

      M1_Single_M2_Multiple.Unlink (
         A_Instance => A_Instance,
         B_Instance => B_Instance);

      M2_Single_M1_Multiple.Unlink (
         A_Instance => B_Instance,
         B_Instance => A_Instance);

   end Unlink;

-----------------------------------------------------------------------

   procedure Navigate (
      From  : in     Root_Object.Object_List.List_Header_Access_Type;
      Class : in     Ada.Tags.Tag;
      To    : in     Root_Object.Object_List.List_Header_Access_Type) is

      The_A_Instance: Root_Object.Object_Access;

   begin

      The_A_Instance := Root_Object.Object_List.First_Entry_Of (From).Item;

      if The_A_Instance /= null then

         if The_A_Instance.all'tag = M1_Side then

            M1_Single_M2_Multiple.Navigate (
               From   => From,
               Class  => Class,
               To     => To);

         elsif The_A_Instance.all'tag = M2_Side then

            M2_Single_M1_Multiple.Navigate (
               From  => From,
               Class => Class,
               To    => To);

         elsif The_A_Instance.all'tag = Associative_Side then

            if Class = M2_Side then

               M1_Single_M2_Multiple.Navigate (
                  From  => From,
                  Class => Class,
                  To    => To);

            elsif Class = M1_Side then

               M2_Single_M1_Multiple.Navigate (
                  From  => From,
                  Class => Class,
                  To    => To);

            end if;

         end if;

      end if;


   end Navigate;

---------------------------------------------------------------------

   procedure Navigate (
      From  : in     Root_Object.Object_Access;
      Class : in     Ada.Tags.Tag;
      To    : in     Root_Object.Object_List.List_Header_Access_Type) is
      --
      -- navigate from a single to a set
      -- valid for:
      --   M1 -> M2
      --   M1 -> A
      --   M2 -> M1
      --   M2 -> A
      --
   begin

      if From.all'tag = M1_Side then

         M1_Single_M2_Multiple.Navigate (
            From  => From,
            Class => Class,
            To    => To);

      elsif From.all'tag = M2_Side then

         M2_Single_M1_Multiple.Navigate (
            From  => From,
            Class => Class,
            To    => To);

      elsif From.all'tag = Associative_Side then

         if Class = M2_Side then

            M1_Single_M2_Multiple.Navigate (
               From  => From,
               Class => Class,
               To    => To);

         elsif Class = M1_Side then


            M2_Single_M1_Multiple.Navigate (
               From  => From,
               Class => Class,
               To    => To);

         end if;

      end if;

   end Navigate;

---------------------------------------------------------------------

   procedure Navigate (
      From  : in     Root_Object.Object_Access;
      Class : in     Ada.Tags.Tag;
      To    :    out Root_Object.Object_Access) is
      --
      -- navigate from a single to a single
      -- valid for:
      --   A -> M1
      --   A -> M2
      --
   begin

      if From.all'tag = Associative_Side then

         if Class = M2_Side then

            M1_Single_M2_Multiple.Navigate (
               From  => From,
               Class => Class,
               To    => To);

         elsif Class = M1_Side then

            M2_Single_M1_Multiple.Navigate (
               From  => From,
               Class => Class,
               To    => To);

         end if;

      end if;


   end Navigate;

---------------------------------------------------------------------


   -- associative correlated navigation
   procedure Navigate (
      From  : in     Root_Object.Object_Access;
      Also  : in     Root_Object.Object_Access;
      Class : in     Ada.Tags.Tag;
      To    :    out Root_Object.Object_Access) is

      --
      -- navigate from two singles to a single
      -- valid for:
      --   M1 and M2 -> A
      --   M1 and M2 -> A

      Temp_Associative_One, Temp_Associative_Two : Root_Object.Object_Access := null;

      Assoc_Set_One   : Root_Object.Object_List.List_Header_Access_Type := Root_Object.Object_List.Initialise;
      Assoc_Set_Two   : Root_Object.Object_List.List_Header_Access_Type := Root_Object.Object_List.Initialise;

      Matched, Inner_Matched : Boolean := FALSE;

   begin

      -- Reset the output pointer to null so that if we don't find anything
      -- useful, the caller can check for it.
      To := null;

      if ((( From.all'tag = M1_Side) and then
           ( Also.all'Tag = M2_Side))
      or else (( From.all'tag = M2_Side) and then
               ( Also.all'Tag = M1_Side)))
      then

         -- Navigate from single instance of first object
         -- returns a set.
         Navigate (
            From  => Also,
            Class => Class,
            To    => Assoc_Set_One);

         -- Navigate from single instance of second object
         -- returns a set.
         Navigate (
            From  => From,
            Class => Class,
            To    => Assoc_Set_Two);

         -- Compare results of the two sets from the above navigations.
         -- A nice simple find operation on a set would be appropriate here, but
         -- there isn't one available, so do it the hard way.

         -- Outer loop
         declare
            use type Root_Object.Object_List.Node_Access_Type;
            Temp_Entry : Root_Object.Object_List.Node_Access_Type;
            Matched : boolean := FALSE;
         begin
            -- Grab the first entry of the set
            Temp_Entry := Root_Object.Object_List.First_Entry_Of(Assoc_Set_One);
            -- While the set is not empty and the entry does not match the
            -- assoc instance already found, burn rubber

            while (not Matched) and (Temp_Entry /= null) loop

               Temp_Associative_One := Temp_Entry.Item;
               -- Compare this entry against the other set.

               -- Inner loop
               declare
                  use type Root_Object.Object_List.Node_Access_Type;
                  Inner_Temp_Entry : Root_Object.Object_List.Node_Access_Type;
               begin

                  -- Grab the first entry of the set
                  Inner_Temp_Entry := Root_Object.Object_List.First_Entry_Of(Assoc_Set_Two);

                  -- While the set is not empty and the entry does not match the
                  -- assoc instance already found, smoke 'em

                  while (not matched) and (Inner_Temp_Entry /= null) loop

							Temp_Associative_Two := Inner_Temp_Entry.Item;
                     -- If M-M:M associative was ever implemented,
                     -- it would be easy to add the matched instance into a set for
                     -- return from this procedure.

							Matched := Temp_Associative_One = Temp_Associative_Two;

							if not Matched then
                        Inner_Temp_Entry := Root_Object.Object_List.Next_Entry_Of(Assoc_Set_Two);
                     end if;

                  end loop; -- end of (Temp_Entry /= null) or else Matched loop
               end;

               Temp_Entry := Root_Object.Object_List.Next_Entry_Of(Assoc_Set_One);

            end loop; -- end of (Temp_Entry /= null) and not matched loop

            if Matched and then Temp_associative_One /= null then
               -- Gotcha
               To := Temp_Associative_One;
            end if;

         end;

         Root_Object.Object_List.Destroy_List(Assoc_Set_One);

         Root_Object.Object_List.Destroy_List(Assoc_Set_Two);

      end if;

   end Navigate;


-----------------------------------------------------------------------


end Many_To_Many_Associative;


