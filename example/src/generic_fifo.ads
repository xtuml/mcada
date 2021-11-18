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
-- File Name:                Generic_FIFO.ads
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
--    jmm     10/05/00        ecr 008996        Cosmetic changes to source code, but no change to code content.
--                                              Changes can be identified by comparison
--                                              with previous version. 
--
-- **************************************************************************************
generic
type Element_Type is private;
--
package Generic_FIFO is
   --
   -- exceptions provided as per name. Underflow can be avoided by checking Queue_Length before 'pop'ping.
   -- Overflow is raised if a Storage Error results when trying to allocate space for a new instance.
   --    
   FIFO_Underflow_Error, 
   FIFO_Overflow_Error: exception;

   type FIFO_Cell_Type;
   --
   -- cell type is the actual storage element with one 'useful' item and pointers to
   -- the previous and next entries
   --
   type FIFO_Access_Type is access FIFO_Cell_Type;

   type FIFO_Cell_Type is
   record
      Element_Pointer : Element_Type;
      Next_Cell       : FIFO_Access_Type;
      Previous_Cell   : FIFO_Access_Type;
   end record;
   --
   -- FIFO_Type is the actual queue with pointers to the first and last entries, and a size count
   --
   type FIFO_Type is
   record
      Size        : Natural := 0;
      Max_Count   : Natural := 0;
      First_Entry : FIFO_Access_Type;
      Last_Entry  : FIFO_Access_Type;
   end record;

   procedure Push (
      Item        : in     Element_Type;
      Target_FIFO : in out FIFO_Type;
      Top         : in     boolean := false);

   procedure Pop (
     Item        :    out Element_Type;
     Target_FIFO : in out FIFO_Type);

   function Queue_Length (Queue: FIFO_Type) return Natural;

   function Max_Count_Of (Queue: FIFO_Type) return Natural;
 
end Generic_FIFO;

