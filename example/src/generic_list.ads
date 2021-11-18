with Application_Types;

generic
	type Element_Type is private;

package Generic_List is

	type Node_Type;
	type Node_Access_Type is access Node_Type;
	type Node_Type is 
		record
			Item : Element_Type;
			Next : Node_Access_Type;
    end record;
--
-- The node is the basic element of the list.
-- Component 'Item' is the 'useful' information and component 'Next' maintains the list 
-- structure
--
--
-- The List_Header_Type is the entry element into the list. A number of the components are made
-- visible for diagnostic purposes and care should be taken when using them 
--
	type List_Header_Type is
		record
			Count :            Application_Types.Base_Integer_Type := 0;
			Max_Count :        Application_Types.Base_Integer_Type := 0;
			First_Entry :      Node_Access_Type := null;
			Stepping_Pointer : Node_Access_Type := null;
			Free_List_Count :  Application_Types.Base_Integer_Type := 0;
			Free_List :        Node_Access_Type := null;
		end record;
	type List_Header_Access_Type is access List_Header_Type;
--
-- The access type to the header is the most commonly-met item     
--
---------------------------------------------------------------
--
	function  Initialise return List_Header_Access_Type;
  --
  -- Initialise must be done before any accesses are attempted on the list.
  -- A sign that it has been missed is Constraint_Error/Access_Error
  --
	procedure Insert (New_Item : in Element_Type;
	                  On_To :    in List_Header_Access_Type );

	procedure Delete (Item : in     Node_Access_Type;
	                  From : in out List_Header_Access_Type);
--
-- Insert and delete act on single items. Note that the 'item' parameter
-- is different in the two cases
--
-- PILOT_0000_0452  Add additional operation to remove entries without destroying list.
--
	procedure Clear (From : in out List_Header_Access_Type);
--
-- Clear will remove all item entries from the list, but new items can be added as the list structure
-- will not be destroyed.
--
	function  Count_Of (Target_List : List_Header_Access_Type) return Application_Types.Base_Integer_Type;
--
-- Count_Of returns the number of items on the list.
-- 
  function Max_Count_Of (Target_List : List_Header_Access_Type) return Application_Types.Base_Integer_Type;
--
-- Max_Count_Of returns the maximum number of items on the list jusqu'ici.
-- 
	function  First_Entry_Of (Target_List : List_Header_Access_Type) return Node_Access_Type;
	function  Next_Entry_Of  (Target_List : List_Header_Access_Type) return Node_Access_Type;
--
-- These enable iteration over the list. First_Entry_Of always sets the pointer to the start,
-- and Next_Entry_Of always steps just one on. Note that these operations share a temporary
-- pointer with the Free list iterators below, and therefore should never be intermingled.
-- 
	procedure Destroy_List   (Target_List : in out List_Header_Access_Type);
--
-- This operation wipes out and deallocates the memory space of the items and the list
-- header. There is no way back after this one.
--
---------------------------------------------------------------------
	function First_Entry_Of_Free_List (Target_List : List_Header_Access_Type) return Node_Access_Type;
	function Next_Entry_Of_Free_List (Target_List : List_Header_Access_Type) return Node_Access_Type;
--
-- These enable iteration over the free list. They are the analogues of the list iterators above.
-- As noted, they must not be intermingled, but as these are essentially for diagnostic
-- purposes, this should not be a problem.
-- 
	function  Count_Of_Free_List (Target_List : List_Header_Access_Type) return Application_Types.Base_Integer_Type;
---------------------------------------------------------------------
--
     List_Underflow_Error, 
     List_Storage_Error, 
     List_Access_Error: exception;

   end Generic_List;

