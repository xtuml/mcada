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
-- File Name:                One_To_Many_Associative.adb
-- Version:                  As detailed by ClearCase
-- Version Date:             As detailed by ClearCase
-- Creation Date:            11-11-99
-- Security Classification:  Unclassified
-- Project:                  SRLE (Sting Ray Life Extension)
-- Author:                   J Mann
-- Section:                  Tactical Software/ Software Architecture
-- Division:                 Underwater Systems Division
-- Description:              Generic implementation of 1-1:M relationship
-- Comments:
--
--  MODIFICATION RECORD
--  --------------------
--     NAME    DATE             ECR No            MODIFICATION
--
--    jmm     11/11/99        008310/9SR056     Order of instance specification in Unlink is wrong. Reverse it.
--
--    jmm     25/04/00        PILOT_0000_0325   Increase length of role to 32 characters for compatibility with
--                                              type base_text_type.
--
--    jmm     28/06/00        PILOT_0000_0423   Include diagnostic references.
--
--    jmm     26/01/01        PILOT_0000_0701   Comment out a line which was erroneously left uncommented.
--
--    db      09/08/01        PILOT_0000_1422   Illegal navigation should return null instance.
--
--    DB      24/09/01        PILOT_0000_2473   Rename Link, Unlink & Unassociate parameters
--                                              to match those for 1:1 type relationships,
--                                              at the request of George.
--
--    db      17/04/02        SRLE100003005     Correlated associative navigations supported.
--
--    db      22/04/02        SRLE100002907     Procedure initialise removed as surplus to requirements
--
--    db      09/05/02        SRLE100002899     Role phrase string is limited to 32 characters
--                                              by calling routine, no checks necessary here.
--
--    db      10/10/02        SRLE100003929     Remove exit condition from within Check_List_For_Multiple
--                                              and Check_List_For_Associative and rearrange loop
--                                              conditions accordingly.
--
--    db      11/10/02        SRLE100003928     Remove null checks on source navigates and
--                                              calls to log.
--
--    DNS     20/05/15        CR 10265          For Navigate procedures returning a list,
--                                              the Return is now an "in" parameter
--
-- **************************************************************************************

with Application_Types;

with Root_Object;
use type Root_Object.Object_Access;
use type Root_Object.Object_List.Node_Access_Type;

with Ada.Tags;
use type Ada.Tags.Tag;

with Ada.Unchecked_Deallocation;

package body One_To_Many_Associative is
------------------------------------------------------------------------
   --
   -- 'Minor' element
   --
   type Relationship_Pair_Type;

   type Relationship_Pair_Access_Type is access all Relationship_Pair_Type;

   type Relationship_Pair_Type is record
      Multiple    : Root_Object.Object_Access;
      Associative : Root_Object.Object_Access;
      Next        : Relationship_Pair_Access_Type;
      Previous    : Relationship_Pair_Access_Type;
   end record;

   procedure Remove_Pair is new Ada.Unchecked_Deallocation (
       Relationship_Pair_Type, Relationship_Pair_Access_Type);

   --
   -- 'Major' element
   --
   type Relationship_Entry_Type;
   type Relationship_Entry_Access_Type is access all Relationship_Entry_Type;

   type Relationship_Entry_Type is record
      Single          : Root_Object.Object_Access;
      Completion_List : Relationship_Pair_Access_Type;
      Next            : Relationship_Entry_Access_Type;
      Previous        : Relationship_Entry_Access_Type;
   end record;

   procedure Remove_Entry is new Ada.Unchecked_Deallocation (
      Relationship_Entry_Type, Relationship_Entry_Access_Type);

   ------------------------------------------------------------------------
   The_Relationship_List: Relationship_Entry_Access_Type;


   subtype Role_Phrase_Type is string (1 .. Application_Types.Maximum_Number_Of_Characters_In_String);

   Multiple_Side             : Ada.Tags.Tag;
   Multiple_Side_Role        : Role_Phrase_Type;
   Multiple_Side_Role_Length : Natural;

   Single_Side             : Ada.Tags.Tag;
   Single_Side_Role        : Role_Phrase_Type;
   Single_Side_Role_Length : Natural;

   Associative_Side             : Ada.Tags.Tag;
   Associative_Side_Role        : Role_Phrase_Type;
   Associative_Side_Role_Length : Natural;
   --
   -- A = LEFT  = MULTIPLE
   -- B = RIGHT = SINGLE
   --
   ------------------------------------------------------------------------
   procedure Check_List_For_Multiple (
      Multiple_Instance       : in     Root_Object.Object_Access;
      Associative_Instance    :    out Root_Object.Object_Access;
      Single_Instance         :    out Root_Object.Object_Access;
      Multiple_Instance_Found :    out Boolean) is

      Temp_Minor_Pointer   : Relationship_Pair_Access_Type;
      Temp_Major_Pointer   : Relationship_Entry_Access_Type;

   begin


      Multiple_Instance_Found := False;
      Temp_Major_Pointer := The_Relationship_List;

      Major_Loop:
      while (not Multiple_Instance_Found) and then Temp_Major_Pointer /= null loop

         Temp_Minor_Pointer := Temp_Major_Pointer.Completion_List;

         Minor_Loop:
         while (not Multiple_Instance_Found) and then Temp_Minor_Pointer /= null loop

            Multiple_Instance_Found := (Temp_Minor_Pointer.Multiple = Multiple_Instance);

            if Multiple_Instance_Found then
               Associative_Instance    := Temp_Minor_Pointer.Associative;
               Single_Instance         := Temp_Major_Pointer.Single;
            else
               -- Prevent access if we have got what we are after
               -- Bailing out of the search loop is a neater solution, but test team defects
               -- have been raised against this sort of thing.
               Temp_Minor_Pointer := Temp_Minor_Pointer.Next;
            end if;

         end loop Minor_Loop;

         -- Prevent the possibility that the next entry in the major queue is null causing an access error
         if not Multiple_Instance_Found then
            Temp_Major_Pointer := Temp_Major_Pointer.Next;
         end if;

      end loop Major_Loop;

   end Check_List_For_Multiple;

   ------------------------------------------------------------------------
   procedure Check_List_For_Associative (
      Associative_Instance       : in     Root_Object.Object_Access;
      Multiple_Instance          :    out Root_Object.Object_Access;
      Single_Instance            :    out Root_Object.Object_Access;
      Associative_Instance_Found :    out Boolean) is

      Temp_Minor_Pointer   : Relationship_Pair_Access_Type;
      Temp_Major_Pointer   : Relationship_Entry_Access_Type;

   begin

      Associative_Instance_Found := False;
      Temp_Major_Pointer := The_Relationship_List;

      Major_Loop:
      while (not Associative_Instance_Found) and then Temp_Major_Pointer /= null loop

         Temp_Minor_Pointer := Temp_Major_Pointer.Completion_List;

         Minor_Loop:
         while (not Associative_Instance_Found) and then Temp_Minor_Pointer /= null loop

            Associative_Instance_Found := (Temp_Minor_Pointer.Associative = Associative_Instance);

            if Associative_Instance_Found then
               Multiple_Instance          := Temp_Minor_Pointer.Multiple;
               Single_Instance            := Temp_Major_Pointer.Single;
            else
               -- Prevent access if we have got what we are after
               -- Bailing out of the search loop is a neater solution, but test team defects
               -- have been raised against this sort of thing.
               Temp_Minor_Pointer := Temp_Minor_Pointer.Next;
            end if;

         end loop Minor_Loop;

         -- Prevent the possibility that the next entry in the major queue is null causing an access error
         if not Associative_Instance_Found then
            Temp_Major_Pointer := Temp_Major_Pointer.Next;
         end if;

      end loop Major_Loop;

   end Check_List_For_Associative;

   -----------------------------------------------------------------------

   procedure Do_Link (
      Multiple_Instance    : in Root_Object.Object_Access;
      Single_Instance      : in Root_Object.Object_Access;
      Associative_Instance : in Root_Object.Object_Access) is

      Temp_Minor_Pointer   : Relationship_Pair_Access_Type;
      Temp_Major_Pointer   : Relationship_Entry_Access_Type;
      Found                : Boolean := False;

   begin
      Temp_Major_Pointer := The_Relationship_List;

      while (not Found) and then Temp_Major_Pointer /= null loop

         Found := (Temp_Major_Pointer.Single = Single_Instance);

         if not Found then -- grab the next item
            Temp_Major_Pointer := Temp_Major_Pointer.Next;
         end if;

      end loop;

      if not Found then
         Temp_Major_Pointer                 := new Relationship_Entry_Type;
         Temp_Major_Pointer.Single          := Single_Instance;
         Temp_Major_Pointer.Completion_List := null;
         Temp_Major_Pointer.Previous        := null;
         Temp_Major_Pointer.Next            := The_Relationship_List;

         if The_Relationship_List /= null then
           The_Relationship_List.Previous := Temp_Major_Pointer;
         end if;

         The_Relationship_List       := Temp_Major_Pointer;

      end if;

      Temp_Minor_Pointer             := new Relationship_Pair_Type;
      Temp_Minor_Pointer.Multiple    := Multiple_Instance;
      Temp_Minor_Pointer.Associative := Associative_Instance;
      Temp_Minor_Pointer.Previous    := null;
      Temp_Minor_Pointer.Next        := Temp_Major_Pointer.Completion_List;

      if Temp_Major_Pointer.Completion_List /= null then
         Temp_Major_Pointer.Completion_List.Previous := Temp_Minor_Pointer;
      end if;

      Temp_Major_Pointer.Completion_List := Temp_Minor_Pointer;

   end Do_Link;

   -----------------------------------------------------------------------

   procedure Do_Unlink (
      Left_Instance  : in Root_Object.Object_Access;
      Right_Instance : in Root_Object.Object_Access) is

      Temp_Minor_Pointer   : Relationship_Pair_Access_Type;
      Temp_Major_Pointer   : Relationship_Entry_Access_Type;
      Delete_List          : Boolean := False;

   begin

      Temp_Major_Pointer := The_Relationship_List;

      Major_Loop:
      while Temp_Major_Pointer /= null loop

         if Temp_Major_Pointer.Single = Left_Instance then
            Temp_Minor_Pointer := Temp_Major_Pointer.Completion_List;

            Minor_Loop:
            while Temp_Minor_Pointer /= null loop
               if Temp_Minor_Pointer.Multiple = Right_Instance then
                  if Temp_Minor_Pointer.Previous = null then
                     --
                     -- first instance in list
                     --
                     Temp_Major_Pointer.Completion_List := Temp_Minor_Pointer.Next;
                     --
                     -- it's also the last and only instance in list
                     -- So we're going to delete the whole relationship instance
                     -- (but not just yet)
                     --
                     Delete_List := (Temp_Minor_Pointer.Next = null);

                  end if;

                  if Temp_Minor_Pointer.Next /= null then
                     --
                     -- there are more instances following in the list
                     --
                     Temp_Minor_Pointer.Next.Previous := Temp_Minor_Pointer.Previous;
                  end if;

                  if Temp_Minor_Pointer.Previous /= null then
                     --
                     -- there are more instances previous in the list
                     --
                     Temp_Minor_Pointer.Previous.Next := Temp_Minor_Pointer.Next;
                  end if;

                  Remove_Pair (Temp_Minor_Pointer);
                  exit Major_Loop;

               end if;

              Temp_Minor_Pointer := Temp_Minor_Pointer.Next;

           end loop Minor_Loop;

         end if;

         Temp_Major_Pointer := Temp_Major_Pointer.Next;

      end loop Major_Loop;
      --
      -- if needed, now delete the list
      -- the same logic applies
      --
      if Delete_List then

         if Temp_Major_Pointer.Previous = null then
            --
            -- first instance in list
            --
            The_Relationship_List := Temp_Major_Pointer.Next;
         end if;

         if Temp_Major_Pointer.Next /= null then
            --
            -- there are more instances following in the list
            --
            Temp_Major_Pointer.Next.Previous := Temp_Major_Pointer.Previous;
         end if;

         if Temp_Major_Pointer.Previous /= null then
            --
            -- there are more instances previous in the list
            --
            Temp_Major_Pointer.Previous.Next := Temp_Major_Pointer.Next;
         end if;

         Remove_Entry (Temp_Major_Pointer);

      end if;

   end Do_Unlink;

   -------------------------------------------------------------------------
   procedure Register_Multiple_End_Class (Multiple_Instance : in Ada.Tags.Tag) is
   begin
      Multiple_Side := Multiple_Instance;
   end Register_Multiple_End_Class;

   ---------------------------------------------------------------------
   procedure Register_Multiple_End_Role (Multiple_Role : in String) is
   begin
      Multiple_Side_Role (1 .. Multiple_Role'Length) := Multiple_Role;
      Multiple_Side_Role_Length                      := Multiple_Role'Length;
   end Register_Multiple_End_Role;

   ---------------------------------------------------------------------

   procedure Register_Single_End_Class (Single_Instance : in Ada.Tags.Tag) is
   begin
      Single_Side := Single_Instance;
   end Register_Single_End_Class;

   ---------------------------------------------------------------------

   procedure Register_Single_End_Role (Single_Role : in String) is
   begin

      Single_Side_Role (1..Single_Role'Length) := Single_Role;
      Single_Side_Role_Length                  := Single_Role'Length;
   end Register_Single_End_Role;

   ---------------------------------------------------------------------

   procedure Register_Associative_End_Class (Associative_Instance : in Ada.Tags.Tag) is
   begin
      Associative_Side := Associative_Instance;
   end Register_Associative_End_Class;

   ---------------------------------------------------------------------

   procedure Register_Associative_End_Role (Associative_Role : in String) is
   begin
      Associative_Side_Role (1 .. Associative_Role'Length) := Associative_Role;
      Associative_Side_Role_Length                         := Associative_Role'Length;
   end Register_Associative_End_Role;

   ---------------------------------------------------------------------

   procedure Link (
      A_Instance : in Root_Object.Object_Access;
      B_Instance : in Root_Object.Object_Access;
      Using      : in Root_Object.Object_Access) is

   begin

      if Using.all'Tag = Associative_Side then

         if A_Instance.all'Tag = Multiple_Side then

            Do_Link (
               Multiple_Instance    => A_Instance,
               Single_Instance      => B_Instance,
               Associative_Instance => Using);
            --
            -- PILOT_0000_0423   Include diagnostic references.
            --
            Application_Types.Count_Of_Relationships := Application_Types.Count_Of_Relationships + 1;

         elsif A_Instance.all'Tag = Single_Side then

            Do_Link (
               Multiple_Instance    => B_Instance,
               Single_Instance      => A_Instance,
               Associative_Instance => Using);
            --
            -- PILOT_0000_0423   Include diagnostic references.
            --
            Application_Types.Count_Of_Relationships := Application_Types.Count_Of_Relationships + 1;

         end if;
      end if; -- Using.all'tag /= Associative_Side

   end Link;

   -----------------------------------------------------------------------

   procedure Unassociate (
      A_Instance : in Root_Object.Object_Access;
      B_Instance : in Root_Object.Object_Access;
      From       : in Root_Object.Object_Access) is
   begin
      null;
   end Unassociate;

   -----------------------------------------------------------------------

   procedure Unlink (
      A_Instance : in Root_Object.Object_Access;
      B_Instance : in Root_Object.Object_Access) is

   begin

      if A_Instance.all'Tag = Multiple_Side then

         Do_Unlink (
            Left_Instance  => B_Instance,
            Right_Instance => A_Instance);
         --
         -- PILOT_0000_0423   Include diagnostic references.
         --
         Application_Types.Count_Of_Relationships := Application_Types.Count_Of_Relationships - 1;

      elsif A_Instance.all'Tag = Single_Side then
         --
         Do_Unlink (
            Left_Instance  => A_Instance,
            Right_Instance => B_Instance);
         --
         -- PILOT_0000_0423   Include diagnostic references.
         --
         Application_Types.Count_Of_Relationships := Application_Types.Count_Of_Relationships - 1;

      end if;

   end Unlink;

   -----------------------------------------------------------------------

   procedure Navigate (
      From  : in     Root_Object.Object_List.List_Header_Access_Type;
      Class : in     Ada.Tags.Tag;
      To    : in     Root_Object.Object_List.List_Header_Access_Type) is

      Source_Instance: Root_Object.Object_Access;
      Temp_Node: Root_Object.Object_List.Node_Access_Type;
      Temp_Instance:    Root_Object.Object_Access;
      --Temp_Single:      Root_Object.Object_Access;
      --Temp_Associative: Root_Object.Object_Access;
      --Temp_Multiple:    Root_Object.Object_Access;

   begin

      Temp_Node := Root_Object.Object_List.First_Entry_Of (From);

      while Temp_Node /= null loop

         Source_Instance := Temp_Node.Item;

         if Source_Instance.all'Tag = Multiple_Side then

            Navigate (
               From  => Source_Instance,
               Class => Class,
               To    => Temp_Instance);

            if Temp_Instance /= null then

                 Root_Object.Object_List.Insert (
                    New_Item => Temp_Instance,
                    On_To    => To );

            end if;
            --
         elsif Source_Instance.all'Tag = Single_Side then

            Navigate (
               From  => Source_Instance,
               Class => Class,
               To    => To);
            --

         elsif Source_Instance.all'Tag = Associative_Side then

            Navigate (
               From  => Source_Instance,
               Class => Class,
               To    => Temp_Instance);

            if Temp_Instance /= null then

               Root_Object.Object_List.Insert (
                  New_Item => Temp_Instance,
                  On_To =>    To );

            end if;
            --

         end if;

         Temp_Node := Root_Object.Object_List.Next_Entry_Of (From);

      end loop;

   end Navigate;

   -----------------------------------------------------------------------

   procedure Navigate (
      From  : in     Root_Object.Object_Access;
      Class : in     Ada.Tags.Tag;
      To    :    out Root_Object.Object_Access) is

      --
      -- navigate from a single to a single
      -- valid for:
      --   A -> M
      --   A -> S
      --   M -> S
      --   M -> A
      --
      Temp_Single:      Root_Object.Object_Access;
      Temp_Associative: Root_Object.Object_Access;
      Temp_Multiple:    Root_Object.Object_Access;
      Found:            Boolean;

   begin

      -- PILOT_0000_1422
      -- Defaulting the return parameter ensures that if an attempt
      -- is made to navigate this type of one to many associative
      -- without having linked it, the correct null parameter is
      -- returned. This relationship mechanism relies on the link
      -- operation to sort out all the tags. We can't rely on that
      -- happening in all cases.
      To := null;

      if From.all'Tag = Multiple_Side then
         --

         Check_List_For_Multiple (
            Multiple_Instance       => From,
            Associative_Instance    => Temp_Associative,
            Single_Instance         => Temp_Single,
            Multiple_Instance_Found => Found);

         if Found then
            --
            if Class = Single_Side then

               To := Temp_Single;


            elsif Class = Associative_Side then

               To := Temp_Associative;

            end if;
         --

         end if;
         --

      elsif From.all'Tag = Associative_Side then


         Check_List_For_Associative (
            Associative_Instance       => From,
            Multiple_Instance          => Temp_Multiple,
            Single_Instance            => Temp_Single,
            Associative_Instance_Found => Found);

         if Found then
            --
            if Class = Single_Side then

               To := Temp_Single;

            elsif Class = Multiple_Side then

               To := Temp_Multiple;

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
      --   S -> M
      --   S -> A
      --

      Temp_Minor_Pointer: Relationship_Pair_Access_Type;
      Temp_Major_Pointer: Relationship_Entry_Access_Type;

   begin

      if From.all'Tag = Single_Side then

         Temp_Major_Pointer := The_Relationship_List;

         Major_Loop:

         while Temp_Major_Pointer /= null loop

            if Temp_Major_Pointer.Single = From then

               Temp_Minor_Pointer := Temp_Major_Pointer.Completion_List;

               Minor_Loop:

               while Temp_Minor_Pointer /= null loop

                  if Class = Multiple_Side then

                     Root_Object.Object_List.Insert (
                        New_Item => Temp_Minor_Pointer.Multiple,
                        On_To =>    To);

                  elsif Class = Associative_Side then

                     Root_Object.Object_List.Insert (
                        New_Item => Temp_Minor_Pointer.Associative,
                        On_To =>    To);

                  end if;

                  Temp_Minor_Pointer := Temp_Minor_Pointer.Next;

               end loop Minor_Loop;

               exit Major_Loop;

            end if;

            Temp_Major_Pointer := Temp_Major_Pointer.Next;

         end loop Major_Loop;
         --
      end if;

   end Navigate;


------------------------------------------------------------------------


   -- associative correlated navigation
   procedure Navigate (
      From  : in     Root_Object.Object_Access;
      Also  : in     Root_Object.Object_Access;
      Class : in     Ada.Tags.Tag;
      To    :    out Root_Object.Object_Access) is


      -- navigate from two singles to a single
      -- valid for:
      --   M and S -> A
      --   S and M -> A

      Temp_Single,
      Single_Side_Source ,
      Multiple_Side_Source,
      Temp_Associative_Multiple,
      Temp_Associative_Single    : Root_Object.Object_Access := null;

      Assoc_Set : Root_Object.Object_List.List_Header_Access_Type := Root_Object.Object_List.Initialise;

      Found,
      Tags_Correct : Boolean := FALSE;

   begin

      -- Reset the output pointer to null so that if we don't find anything
      -- useful, the caller can check for it.
      To := null;

      Tags_Correct := ((( From.all'Tag = Multiple_Side) and then
                        ( Also.all'Tag = Single_Side))
              or else ((( From.all'Tag = Single_Side) and then
                        ( Also.all'Tag = Multiple_Side)))) ;

      if Tags_Correct then

         if From.all'Tag = Multiple_Side then

           Multiple_Side_Source := From;
           Single_Side_Source   := Also;
         else
            Multiple_Side_Source := Also;
            Single_Side_Source   := From;
         end if;

         -- Do the navigations now, all is correct.

         -- Navigate from multiple side to associative side.
         Check_List_For_Multiple (
            Multiple_Instance       => Multiple_Side_Source,
            Associative_Instance    => Temp_Associative_Multiple,
            Single_Instance         => Temp_Single,
            Multiple_Instance_Found => Found);


         -- Navigate from single side to associative side.
         if Found then

            -- do the navigation

            declare
               Input_List : Root_Object.Object_List.List_Header_Access_Type;
            begin
               Input_List := Root_Object.Object_List.Initialise;

               Root_Object.Object_List.Clear(Assoc_Set);

               Root_Object.Object_List.Insert (
                  New_Item => Single_Side_Source,
                  On_To    => Input_List);

               Navigate(
                  From  => Input_List,
                  Class => Class,
                  To    => Assoc_Set);

               Root_Object.Object_List.Destroy_List(Input_List);

            end;

            -- Extract out the instance from the set by looping through the
            -- set and looking for a match with the instance found from the
            -- multiple side navigation.

            declare
               use type Root_Object.Object_List.Node_Access_Type;
               Temp_Entry : Root_Object.Object_List.Node_Access_Type;

            begin

               -- Grab the first entry of the set
               Temp_Entry := Root_Object.Object_List.First_Entry_Of(Assoc_Set);

               -- While the set is not empty, and the entry does not match the
               -- assoc instance already found, loop
               while (Temp_Entry              /= null) and then
                     (Temp_Associative_Single /= Temp_Associative_Multiple) loop

                  Temp_Associative_Single := Temp_Entry.Item;
                  Temp_Entry              := Root_Object.Object_List.Next_Entry_Of(Assoc_Set);

               end loop;

            end;

            if Temp_Associative_Single = Temp_Associative_Multiple then
               To := Temp_Associative_Single;
            end if;

         end if;

      end if;

   end Navigate;

-----------------------------------------------------------------------


end One_To_Many_Associative;
