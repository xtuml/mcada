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
-- File Name:                Generic_List.adb
-- Version:                  As detailed by ClearCase
-- Version Date:             As detailed by ClearCase
-- Creation Date:            03-11-99
-- Security Classification:  Unclassified
-- Project:                  SRLE (Sting Ray Life Extension)
-- Author:                   J Mann
-- Section:                  Tactical Software/ Software Architecture
-- Division:                 Underwater Systems Division
-- Description:              Implementation of application-wide list type
-- Comments:                 
--
--  MODIFICATION RECORD
--  --------------------
--     NAME     DATE             ECR No            MODIFICATION
--
--    jmm     29/06/99        QAR beatd40       
--
--    jmm     10/05/00        ecr 008996        Cosmetic changes to source code, but no change to code content.
--                                              Changes can be identified by comparison with previous version. 
--
--    jmm     11/07/00        PILOT_0000_0452   Add additional operation to remove entries without destroying
--                                              list.
--
--    db      04/07/01        PILOT_0000_0262   Set Stepping_Pointer to null
--                            PILOT_0000_0230   Remove use clause as per coding standards.
--  
--    db      08/02/02        SRLE100001619     Prevent de-referencing an empty queue when clearing.
--
--    db      17/04/02        SRLE100003005     Removal of loitering legacy code.
--
-- **************************************************************************************
with Ada.Unchecked_Deallocation;

with Application_Types;
use type Application_Types.Base_Integer_Type;

package body Generic_List is
  --
  -- Provide two removal procedures
   procedure Remove_Node is new Ada.Unchecked_Deallocation (Node_Type, Node_Access_Type);
   procedure Remove_List is new Ada.Unchecked_Deallocation (List_Header_Type, List_Header_Access_Type);

---------------------------------------------------------------------
   function Initialise return List_Header_Access_Type is

     Temp_Entry: List_Header_Access_Type;

   begin
      --
      -- allocate new memory for the header information
      --
      Temp_Entry := new List_Header_Type;
      --
      -- and set the fields up. These could be replaced by default values in the
      -- record declaration.
      --
      Temp_Entry.First_Entry      := null;
      Temp_Entry.Count            := 0;
      Temp_Entry.Free_List        := null;
      Temp_Entry.Free_List_Count  := 0;

      -- DEFECT 262 set Stepping_Pointer to null.
      Temp_Entry.Stepping_Pointer := null;

      return Temp_Entry; 

   end Initialise;

   ---------------------------------------------------------------------

   function Count_Of (Target_List : List_Header_Access_Type) return Application_Types.Base_Integer_Type is
   begin
      return Target_List.Count;
   end Count_Of;

   ---------------------------------------------------------------------

   function Count_Of_Free_List (Target_List : List_Header_Access_Type) return Application_Types.Base_Integer_Type is
   begin
      return Target_List.Free_List_Count;
   end Count_Of_Free_List;

   ---------------------------------------------------------------------

   function Max_Count_Of (Target_List : List_Header_Access_Type) return Application_Types.Base_Integer_Type is
   begin
      return Target_List.Max_Count;
   end Max_Count_Of;

   ---------------------------------------------------------------------

   function First_Entry_Of (Target_List : List_Header_Access_Type) return Node_Access_Type is
   begin
      Target_List.Stepping_Pointer := Target_List.First_Entry;
      return Target_List.Stepping_Pointer;
   end First_Entry_Of;

   ---------------------------------------------------------------------

   function Next_Entry_Of (Target_List : List_Header_Access_Type) return Node_Access_Type is
   begin
      Target_List.Stepping_Pointer := Target_List.Stepping_Pointer.Next;
      return Target_List.Stepping_Pointer;
   end Next_Entry_Of;

   ---------------------------------------------------------------------

   procedure Insert (New_Item : in Element_Type;
                     On_To :    in List_Header_Access_Type) is

      New_Cell: Node_Access_Type;

   begin

      if On_To.Free_List = null then
         -- 
         -- there are no 'old' entries available for reuse
         --
         begin
            New_Cell:= new Node_Type;
         
         exception
            when Storage_Error => raise List_Storage_Error ;
         end;
         --
         -- this has been placed in a block to limit the scope of the exception handler
         --
      else -- Free_List /= null
          -- 
          -- there is an 'old' entry available for reuse, so grab it
          --
          New_Cell              := On_To.Free_List;
          On_To.Free_List       := On_To.Free_List.Next;
          On_To.Free_List_Count := On_To.Free_List_Count - 1;
      end if; -- Free_List = null
      --
      -- The new call has been identified, so set it up
      --
      New_Cell.all := (
          Item => New_Item, 
          Next  => On_To.First_Entry);

      On_To.First_Entry := New_Cell;
      --
      -- and increment the list size
      --
      On_To.Count := On_To.Count + 1;
      if On_To.Count > On_To.Max_Count then
         On_To.Max_Count := On_To.Count;
      end if;
     
   end Insert;

   ---------------------------------------------------------------------

   procedure Delete (Item : in     Node_Access_Type;
                     From : in out List_Header_Access_Type) is

      Temp_Node         : Node_Type;
      Temp_Node_Pointer : Node_Access_Type;

   begin

      -- If item to delete and list to delete from are both valid
      if (From /= null) and then (Item /= null) then

         Temp_Node_Pointer := From.First_Entry;

         if (Temp_Node_Pointer /= null) then
            -- 
            -- a request to delete an item from an empty queue 
            --
            -- 
            -- queue is not empty, find the requested item
            --
            if Temp_Node_Pointer = Item then
               --
               -- it's the first in the list to be deleted
               --
               Temp_Node.Next        := Temp_Node_Pointer.Next;
               From.First_Entry.Next := From.Free_List;
               From.Free_List        := Temp_Node_Pointer;
               From.First_Entry      := Temp_Node.Next;
               From.Count            := From.Count - 1;
               From.Free_List_Count  := From.Free_List_Count + 1;
            else -- Temp_Node_Pointer /= Item
               -- 
               -- step through the list and find it
               --
               loop
                  exit when Temp_Node_Pointer.next = null;
                  --
                  -- or if the end is reached without finding it
                  --
                  if Temp_Node_Pointer.next = Item then
                     --
                     -- Found it. So remove it to the free list and remake the queue links
                     --
                     Temp_Node.Next              := Temp_Node_Pointer.Next.Next;
                     Temp_Node_Pointer.Next.Next := From.Free_List;
                     From.Free_List              := Temp_Node_Pointer.Next;
                     Temp_Node_Pointer.Next      := Temp_Node.Next;
                     From.Count                  := From.Count - 1;
                     From.Free_List_Count        := From.Free_List_Count + 1;
                     exit;
                  end if; --Temp_Node_Pointer.next = Item
                  Temp_Node_Pointer := Temp_Node_Pointer.Next;
                  --
                  -- Or not found, so let's look at the next in the list
                  --
               end loop;

            end if; -- Temp_Node_Pointer = Item
          
         end if; -- Temp_Node_Pointer /= null

      end if; -- Item or list /= null

      --
      -- there is no indication here:
      -- a) if an item was deleted
      -- b) if the requested item was not found in the list
      -- c) if the list was empty
      -- However, there is not yet any facility to act on this error information, so watch this space.
      --
   end Delete;

   ---------------------------------------------------------------------
   --
   -- PILOT_0000_0452  Add additional operation to remove entries without destroying list.
   ---------------------------------------------------------------------

   procedure Clear (From : in out List_Header_Access_Type) is

      Old_Cell : Node_Access_Type;
     
   begin
      -- SRLE100001619 Prevent de-referencing an empty queue
      if From /= null then

         while From.First_Entry /= null loop
            -- 
            -- don't try to clear an already-empty queue
            --
            Old_Cell             := From.First_Entry;
            From.First_Entry     := From.First_Entry.Next;
            --
            -- Got one. So remove it to the free list
            --
            Old_Cell.Next        := From.Free_List;
            From.Free_List       := Old_Cell;
            --
            From.Count           := From.Count - 1;
            From.Free_List_Count := From.Free_List_Count + 1;
            --
            -- Try again.
            --
         end loop; -- while From.First_Entry /= null

      end if;

   end Clear;

   ---------------------------------------------------------------------

   procedure Destroy_List (Target_List : in out List_Header_Access_Type) is

     Temp_Node_Pointer : Node_Access_Type;
     Counter           : Natural;

   begin
      --
      -- qar beatd40
      -- incorporate a null test into Destroy_List as changes to other components can result in the
      -- attempted destruction of non-initialised lists
      --
      if Target_List /= null then
         --
         -- iterate over the free list and remove each individual item
         --
         Counter := 0;
         while Target_List.Free_List /= null loop
            Temp_Node_Pointer     := Target_List.Free_List;
            Target_List.Free_List := Target_List.Free_List.Next;
            Remove_Node (Temp_Node_Pointer);
            Counter               := Counter + 1;
         end loop;
         --
         -- iterate over the active list and remove each individual item
         --
         Counter := 0;
         while Target_List.First_Entry /= null loop
            Temp_Node_Pointer       := Target_List.First_Entry;
            Target_List.First_Entry := Target_List.First_Entry.Next;
            Remove_Node (Temp_Node_Pointer);
            Counter                 := Counter + 1;
         end loop;
         --
         -- and finally remove the header information
         --
         Remove_List (Target_List);

      end if;
      
   end Destroy_List;

   ---------------------------------------------------------------------

   function First_Entry_Of_Free_List (Target_List : List_Header_Access_Type) return Node_Access_Type is
   begin
      Target_List.Stepping_Pointer := Target_List.Free_List;
      return Target_List.Stepping_Pointer;
   end First_Entry_Of_Free_List;

   ---------------------------------------------------------------------

   function Next_Entry_Of_Free_List (Target_List : List_Header_Access_Type) return Node_Access_Type is
   begin
      Target_List.Stepping_Pointer := Target_List.Stepping_Pointer.Next;
      return Target_List.Stepping_Pointer;
   end Next_Entry_Of_Free_List;

   ---------------------------------------------------------------------
end Generic_List;


