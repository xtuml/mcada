-- root package:  ${self.name}

with Ada.Unchecked_Deallocation;
with Generic_List;
with Generic_FIFO;
with Ada.Tags;
with Application_Types;
use type Application_Types.Base_Integer_Type;
use type Application_Types.Base_Float_Type;
use type Application_Types.Base_Text_Type;
use type Application_Types.Time_Unit;

package ${self.name} is
------------------------------------------------------------------------
--*********************  Object Definition *****************************
------------------------------------------------------------------------
   Object_String : String := "${self.name} ";
  
   type Object_Type; 
    
   type Object_Access is access all Object_Type'Class;
    
   type Object_Type is tagged 
   record
      Root_Object_Attribute: Integer;
      Next_Object:           Object_Access := null;
      Previous_Object:       Object_Access := null;
   end record;

   function Get_Next_Root_Object_Attribute return Integer;

------------------------------------------------------------------------
--*********************  Object Management *****************************
------------------------------------------------------------------------
   function Create return Object_Access;

   procedure Description (This_Object: in  Object_Type);

   procedure Delete      (Old_Object:  in out Object_Access);

--------------------------------------------------------------------------
----************************  Event Stuff ********************************
--------------------------------------------------------------------------
   function Get_Root_Event_Attribute return Integer;

   function Get_Next_Root_Event_Attribute return Integer;
  
   procedure Do_Events;
    
   type Root_Event_Type; 
    
   type Root_Event_Access_Type is access Root_Event_Type'Class;
    
   type Root_Event_Type is tagged 
   record
      Root_Event_Attribute: Integer                := Get_Next_Root_Event_Attribute;
      Next_Event:           Root_Event_Access_Type := null;
      Previous_Event:       Root_Event_Access_Type := null;
   end record;
  
   Root_Event_Number: Integer := 0;
    
   procedure Process_Events (This_Event: in Root_Event_Type);
    
   procedure Put_Event (Event:    in Root_Object.Root_Event_Access_Type;
                        To_Class: in Object_Type;
                        Top:      in Boolean := False);
    
  
   procedure Event_Action (Dispatch_Event: in Root_Event_Type;
                           This_Event:     in out Root_Event_Access_Type);
                       
   procedure Polymorphic_Put (This_Object: in out Object_Type; This_Event: in Root_Event_Access_Type);
    
   procedure Free is new Ada.Unchecked_Deallocation (Root_Event_Type'Class, Root_Event_Access_Type );

   package Object_List is new Generic_List (Object_Access);
  
------------------------------------------------------------------------
--*******************  Navigation Utilities ****************************
------------------------------------------------------------------------
   Access_Type_Size: Natural := Object_Access'Size;
	
   function Size_Of_Access return Natural;

   function Size_Of_Boolean return Natural;

   type Formalised_Relationship_Write_Type is access
      procedure (This_Object:  in Object_Access; 
                 Remote_Value: in Object_Access);

   type Formalised_Relationship_Read_Type is access
      function (This_Object: Object_Access) return Object_Access;
    
   type Formalised_Multiple_Relationship_Write_Type is access
      procedure (This_Object:  in Object_Access; 
                 Remote_Value: in Root_Object.Object_List.List_Header_Access_Type);

   type Formalised_Multiple_Relationship_Read_Type is access
      function (This_Object: Object_Access) return Root_Object.Object_List.List_Header_Access_Type;


end ${self.name};
