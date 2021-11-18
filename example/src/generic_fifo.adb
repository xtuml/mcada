-- *************************************************************************************
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
-- File Name:                Generic_FIFO.adb
-- Version:                  As detailed by ClearCase
-- Version Date:             As detailed by ClearCase
-- Creation Date:            03-11-99
-- Security Classification:  Unclassified
-- Project:                  SRLE (Sting Ray Life Extension)
-- Author:                   J Mann
-- Section:                  Tactical Software/ Software Architecture
-- Division:                 Underwater Systems Division
-- Description:              Specification and implementation of application-wide FIFO type
-- Comments:                 
--
--  MODIFICATION RECORD
--  --------------------
--     NAME     DATE             ECR No            MODIFICATION
--
-- **************************************************************************************
package body Generic_FIFO is
   -- 
   -- The free list retains the memory space of deleted items. If it results in unacceptable sizes
   -- at run time, the option of deallocating excesses will be addressed
   --
   Free_List: FIFO_Access_Type;
   --
------------------------------------------------------------------------------------------------
   --
   -- The FIFO is less used than the list structure, so does not as yet have the same diagnostic
   -- operations. If they prove desirable, their inclusion will be considered.
   --
   procedure Push (
      Item        : in     Element_Type;
      Target_FIFO : in out FIFO_Type;
      Top         : in     boolean := false) is
                     
      New_Cell: FIFO_Access_Type;

   begin
      --  Log.Put_Line ("Push: 'before' queue size -> "&integer'image (Target_FIFO.Size));
      if Free_List = null then
         -- 
         -- there are no 'old' entries available for reuse
         --
         --    log.put_line ("Push called - no 'old' entries");
         begin
            New_Cell:= new FIFO_Cell_Type;
         exception
            when Storage_Error => raise FIFO_Overflow_Error ;
         end;
      else
         --
         -- there are,.. so take the first one and step on the free list
         New_Cell := Free_List;
         Free_List := Free_List. Next_Cell;
      end if;
      --
      -- the new cell has been identified, so set the fields up
      --

      if Top then
         --
         -- put to FRONT of queue
         --
         New_Cell.all := (
            Element_Pointer => Item, 
            Next_Cell       => null,
            Previous_Cell   => Target_FIFO.Last_Entry);
         --
         -- link the new cell into the FIFO
         --
         if Target_FIFO.First_Entry = null then
            Target_FIFO.First_Entry := New_Cell;
         else
            Target_FIFO.Last_Entry.Next_Cell := New_Cell;
         end if;

         Target_FIFO.Last_Entry := New_Cell;

      else
         --
         -- (normal) put to back of queue
         --
         New_Cell.all := (
            Element_Pointer => Item, 
            Next_Cell       => Target_FIFO.First_Entry,
            Previous_Cell   => null);
         --
         -- link the new cell into the FIFO
         --
         if Target_FIFO.First_Entry = null then
            Target_FIFO.Last_Entry := New_Cell;
         else
            Target_FIFO.First_Entry.Previous_Cell := New_Cell;
         end if;

         Target_FIFO.First_Entry := New_Cell;

      end if;
      --
      -- and increment the size of the store
      --
      Target_FIFO.Size := Target_FIFO. Size + 1;

      if Target_FIFO.Size > Target_FIFO.Max_Count then
         Target_FIFO.Max_Count := Target_FIFO.Size;
      end if;

   end Push;
   --
   ---------------------------------------------------------------------
   --
   procedure Pop  (
      Item        :    out Element_Type;
      Target_FIFO : in out FIFO_Type) is

      Old_Cell: FIFO_Access_Type;

   begin
      Target_FIFO := Target_FIFO;

      if Target_FIFO. Last_Entry = null then raise FIFO_Underflow_Error;
         --
         -- trying to extract from an already-empty queue
         --
      else
         --
         -- set output parameter to be oldest entry (in time)
         --
         Item := Target_FIFO.Last_Entry.Element_Pointer ;
         --
         -- and undo and remake the links from the FIFO list
         --
         Old_Cell := Target_FIFO.Last_Entry;
         Target_FIFO.Last_Entry := Target_FIFO.Last_Entry.Previous_Cell;
         if Target_FIFO.Last_Entry /= null then
            Target_FIFO.Last_Entry.Next_Cell := null;
         else
            Target_FIFO.First_Entry := null;
         end if;
         --
         -- and decrement the size of the store
         --
         Target_FIFO.Size := Target_FIFO.Size - 1;
         --
         -- add deleted cell to the free list available for reuse
         --
         Old_Cell.Next_Cell := Free_List;
         Old_Cell.Previous_Cell := null;
         Free_List := Old_Cell;
      end if;
   end Pop;
   --
   ---------------------------------------------------------------------
   --
   --
   -- This function is provided only as an interface operation
   --
   function Queue_Length (Queue: FIFO_Type) return Natural is
   begin
      return Queue.Size;
   end Queue_Length;
   --
   ---------------------------------------------------------------------
   function Max_Count_Of (Queue: FIFO_Type) return Natural is
   begin
      return Queue.Max_Count;
   end Max_Count_Of;
   ---------------------------------------------------------------------
   --
end Generic_FIFO;

