--*************************************************************************************
--*                               UNCLASSIFIED
--*                            IN STRICT CONFIDENCE                                   *
--*                                                                                   *
--*************************************************************************************
--* This is an unpublished work created on the date(s) shown, any copyright in        *
--* which vests in BAE SYSTEMS.  All rights reserved.                                 *
--*                                                                                   *
--* The information contained in this document/record is proprietary to               *
--* BAE SYSTEMS unless stated otherwise and is made available in confidence; it       *
--* must not be used or disclosed without our express written permission. This        *
--* document/record may not be copied in whole or in part in any form without         *
--* the express written consent of BAE SYSTEMS, which may be given by contract.       *
--* This drawing is a design document for the purposes of the Copyright,              *
--* Designs and Patents Act 1988.                                                     *
--*                                                                                   *
--* Public Access: Freedom Of Information Act 2000, etc.                              *
--*                                                                                   *
--* This document contains commercially-sensitive trade secrets as of the date        *
--* provided to the original recipient by BAE SYSTEMS and is provided in              *
--* confidence. Following a request for this information public authorities           *
--* should consult with BAE SYSTEMS regarding the current releasability of the        *
--* information prior to the decision to release all or part of this document,        *
--* and in any event are to notify BAE SYSTEMS prior to any release. Release of       *
--* this information by a public authority may constitute an actionable breach        *
--* of confidence.                                                                    *
--*                                                                                   *
--*************************************************************************************
--*                                                                                   *
--* Prepared by BAE SYSTEMS under Contract Number TORPC/01119 dated April 2010.       *
--* Restrictions on reproduction and use are subject to the terms of DEFCON 91        *
--* (Edn. 11/06) as applicable, and other terms under the Contract.                   *
--*                                                                                   *
--*************************************************************************************
--*                                                                                   *
--* File Name:               log.adb
--* Drawing Number:          Refer to release documentation                           *
--* Version:                 As detailed by ClearCase                                 *
--* Version Date:            As detailed by ClearCase                                 *
--* Creation Date:           As detailed by ClearCase                                 *
--* Author:                  Tactical Software Team                                   *
--* Maintained by:           Tactical Software Team                                   *
--* Division:                Torpedoes Business Stream                                *
--* Project:                 SFU (Spearfish Upgrade)                                  *
--* ClearCase VOB:           Refer to release documentation                           *
--* Section/Unit:            Refer to release documentation                           *
--* Description:             
--*                          Log package body for debugging purposes
--* Comments:                Header written by header.macro                           *
--*                           
--*                                                                                   *
--*************************************************************************************
--*                            SUPPLEMENTAL INFORMATION                               *
--*                            ------------------------                               *
--*  OVERVIEW                                                                         *
--*  --------                                                                         *
--*  Target specific exception handling 
--*
--*  ERROR HANDLING                                                                   *
--*  --------------                                                                   *
--*                                                                                   *
--*  SAFETY         : None                                                            *
--*  ------                                                                           *
--*                                                                                   *
--*  BUILD INFORMATION                                                                *
--* -----------------                                                                 *
--*                                                                                   *
--*  Build Target       : Dos
--*  Clock Type         : INTERNAL
--*  Debugging is       : Off
--*  Trace is           : Off
--*                                                                                   *
--*  
--*  
--*  
--*  
--*  
--*************************************************************************************
--*  COMPONENTS CONTAINED WITHIN THIS FILE                                            *
--*
--*************************************************************************************
--  MODIFICATION RECORD
--  --------------------
--     NAME     DATE             ECR No            MODIFICATION
--
--     DB       28-03-02         -              Added this file to allow log to be generated
--                                              for single domain builds also.
--
--    ANF     04/07/06        001798 9SR056     Archetype language reformatted
--
--    DNS     15/06/15          CR 10267        Add SBC312 and PPCM2 Targets rather than generic VxWorks
--    DNS     01/12/16          CR 10383        SBC312 target now SBC314
--    DNS     17/05/18       CR 10488 9SU050    DOS support reinstated.
-- **************************************************************************************

-- No log file is produced, nor screen output generated for Win32 or VxWorks target:



package body Log is
-------------------------------------------------------------------------
procedure Initialise (File_Name: in string) is
begin
  null;
end Initialise;
-------------------------------------------------------------------------
procedure New_Line is
begin
  null;
end New_Line;
-------------------------------------------------------------------------
procedure Put_Line (Dump_String: in string) is
begin
  null;
end Put_Line;
-------------------------------------------------------------------------
procedure Put (Dump_String: in string) is
begin
  null;
end Put;
-------------------------------------------------------------------------
procedure Put_Line (Dump_Float: in float) is
begin
  null;
end Put_Line;
-------------------------------------------------------------------------
procedure Put (Dump_Float: in float) is
begin
  null;
end Put;
-------------------------------------------------------------------------
procedure Put (Dump_Duration: in duration) is
begin
  null;
end Put;
-------------------------------------------------------------------------
procedure Put (Dump_Boolean: in boolean) is
begin
  null;
end Put;
-------------------------------------------------------------------------
procedure Put_Line (Dump_Integer: in integer) is
begin
  null;
end Put_Line;
-------------------------------------------------------------------------
procedure Put (Dump_Integer: in integer) is
begin
  null;
end Put;
-------------------------------------------------------------------------
procedure Close is
begin
  null;
end Close;
-------------------------------------------------------------------------
--
-- package elaboration code
--
begin
  null;
end Log;



