-- with Exception_Handler;
with Ada.Strings.Unbounded;

package body Application_Types is
   Error_Message: Ada.Strings.Unbounded.Unbounded_String := Ada.Strings.Unbounded.To_Unbounded_String("No additional information provided");
   Overflow_Error: exception;

   function "+" (A: Base_Float_Type; B: Base_Float_Type) return Base_Float_Type is

      result : Base_Float_Type;

   begin
      -- A conversion to float and back is required to avoid recursion
      result := Base_Float_Type(Float(A) + Float(B));

      -- Check result for +/-Inf since no overflow exception for Float
      if result > Base_Float_Type'last or else result < Base_Float_Type'first then
         
         raise Overflow_Error;
      else
         
         return result;
      end if;

   exception
      when E: others =>
         
         Error_Message := Ada.Strings.Unbounded.To_Unbounded_String("Overflow, Application_Types, Base_Float_Type, + ");
         -- Exception_Handler.output_exception_table_to_recorder(eventtext_rec => E,
         --                                                     bonus         => Error_Message);
         if A > 0.0 then
            -- An overflow can only have occurred > MAXINT
            return Base_Float_Type'Last;
         else
            -- An overflow can only have occurred < MININT
            return Base_Float_Type'First;
         end if;
         
   end "+";  -- for Base_Float_Type

  --
  ----------------------------------------------------------------------------------------------
  --

   function "-" (A: Base_Float_Type; B: Base_Float_Type) return Base_Float_Type is

      result : Base_Float_Type;

   begin
      -- A conversion to float and back is required to avoid recursion
      result := Base_Float_Type(Float(A) - Float(B));

      -- Check result for +/-Inf since no overflow exception for Float
      if result > Base_Float_Type'last or else result < Base_Float_Type'first then
         
         raise Overflow_Error;
      else
         
         return result;
      end if;

   exception
      when E: others =>
         
         Error_Message := Ada.Strings.Unbounded.To_Unbounded_String("Overflow, Application_Types, Base_Float_Type, - ");
         -- TBD Exception_Handler.output_exception_table_to_recorder(eventtext_rec => E,
         --                                                      bonus         => Error_Message);
         if A > 0.0 then
            -- An overflow can only have occurred > MAXINT
            return Base_Float_Type'Last;
         else
            -- An overflow can only have occurred < MININT
            return Base_Float_Type'First;
         end if;
         
   end "-";  -- for Base_Float_Type

  --
  ----------------------------------------------------------------------------------------------
  --

   function "*" (A: Base_Float_Type; B: Base_Float_Type) return Base_Float_Type is

      result : Base_Float_Type;

   begin
      -- A conversion to float and back is required to avoid recursion
      result := Base_Float_Type(Float(A) * Float(B));

      -- Check result for +/-Inf since no overflow exception for Float
      if result > Base_Float_Type'last or else result < Base_Float_Type'first then
         
         raise Overflow_Error;
      else
         
         return result;
      end if;

   exception
      when E: others =>
         
         Error_Message := Ada.Strings.Unbounded.To_Unbounded_String("Overflow, Application_Types, Base_Float_Type, * ");
         -- TBD Exception_Handler.output_exception_table_to_recorder(eventtext_rec => E,
         --                                                     bonus         => Error_Message);
         if (A > 0.0 and B > 0.0) or (A < 0.0 and B < 0.0) then
            -- An overflow can only have occurred > MAXINT
            return Base_Float_Type'Last;
         else
            -- An overflow can only have occurred < MININT
            return Base_Float_Type'First;
         end if;
         
   end "*";  -- for Base_Float_Type

  --
  ----------------------------------------------------------------------------------------------
  --

  function "/" (Numerator: Base_Float_Type; Denominator: Base_Float_Type) return Base_Float_Type is
    return_value: Base_Float_Type := 1.0;
  begin
    if Denominator > -1.0 and then Denominator < 1.0 then -- need further checks
      if Numerator > 0.0 then -- Numerator is positive
        if Denominator >= 0.0 then
          if Numerator > (Denominator * Base_Float_Type'last) then
            return_value := Base_Float_Type'last;
          else
            return_value := Base_Float_Type(float (Numerator)/float(Denominator));
          end if;
        else
          if -Numerator < (-Denominator * Base_Float_Type'first) then
            return_value := Base_Float_Type'first;
          else
            return_value := Base_Float_Type(float (Numerator)/float(Denominator));
          end if;
        end if; -- Numerator >= 0.0
      elsif Numerator < 0.0 then -- Numerator is negative
        if Denominator >= 0.0 then
          if Numerator < (Denominator * Base_Float_Type'first) then
            return_value := Base_Float_Type'first;
          else
            return_value := Base_Float_Type(float (Numerator)/float(Denominator));
          end if;
        else
          if -Numerator > (-Denominator * Base_Float_Type'last) then
            return_value := Base_Float_Type'last;
          else
            return_value := Base_Float_Type(float (Numerator)/float(Denominator));
          end if;
        end if; -- Denominator >= 0.0
      else -- Numerator = 0.0
        return_value := 0.0;
      end if; -- Numerator > 0.0

    else -- all is OK, carry on
      return_value := Base_Float_Type(float (Numerator)/float(Denominator));
    end if; -- Denominator > -1.0 and then Denominator < 1.0

    return return_value;

  end "/";    -- for Base_Float_Type

  --
  ----------------------------------------------------------------------------------------------
  --

   function "**" (A: Base_Float_Type; B: Integer) return Base_Float_Type is

      result : Base_Float_Type;

   begin
      -- A conversion to float and back is required to avoid recursion
      result := Base_Float_Type(Float(A) ** B);

      -- Check result for +/-Inf since no overflow exception for Float
      if result > Base_Float_Type'last or else result < Base_Float_Type'first then
         
         raise Overflow_Error;
      else
         
         return result;
      end if;
      
   exception
      when E: others =>
         
         Error_Message := Ada.Strings.Unbounded.To_Unbounded_String("Overflow, Application_Types, Base_Float_Type, * ");
         -- TBD Exception_Handler.output_exception_table_to_recorder(eventtext_rec => E,
         --                                                     bonus         => Error_Message);
         if A > 0.0 then
            -- An overflow can only have occurred > MAXINT
            return Base_Float_Type'Last;
         else
            -- An overflow can only have occurred < MININT
            return Base_Float_Type'First;
         end if;
         
   end "**";  -- for Base_Float_Type

  --
  ----------------------------------------------------------------------------------------------
  --

   function "+" (A: Base_Integer_Type; B: Base_Integer_Type) return Base_Integer_Type is

   begin
      -- A conversion to integer and back is required to avoid recursion
      return Base_Integer_Type(Integer(A) + Integer(B));

   exception
      when E: others =>
         
         Error_Message := Ada.Strings.Unbounded.To_Unbounded_String("Overflow, Application_Types, Base_Integer_Type, + ");
         -- TBD Exception_Handler.output_exception_table_to_recorder(eventtext_rec => E,
         --                                                     bonus         => Error_Message);
         if A > 0 then
            -- An overflow can only have occurred > MAXINT
            return Base_Integer_Type'Last;
         else
            -- An overflow can only have occurred < MININT
            return Base_Integer_Type'First;
         end if;
         
   end "+";  -- for Base_Integer_Type

  --
  ----------------------------------------------------------------------------------------------
  --

   function "-" (A: Base_Integer_Type; B: Base_Integer_Type) return Base_Integer_Type is

   begin
      -- A conversion to integer and back is required to avoid recursion
      return Base_Integer_Type(Integer(A) - Integer(B));

   exception
      when E: others =>
         
         Error_Message := Ada.Strings.Unbounded.To_Unbounded_String("Overflow, Application_Types, Base_Integer_Type, - ");
         -- TBD Exception_Handler.output_exception_table_to_recorder(eventtext_rec => E,
         --                                                   bonus         => Error_Message);
         if A > 0 then
            -- An overflow can only have occurred > MAXINT
            return Base_Integer_Type'Last;
         else
            -- An overflow can only have occurred < MININT
            return Base_Integer_Type'First;
         end if;
         
   end "-";  -- for Base_Integer_Type

  --
  ----------------------------------------------------------------------------------------------
  --

   function "*" (A: Base_Integer_Type; B: Base_Integer_Type) return Base_Integer_Type is

   begin
      -- A conversion to integer and back is required to avoid recursion
      return Base_Integer_Type(Integer(A) * Integer(B));

   exception
      when E: others =>
         
         Error_Message := Ada.Strings.Unbounded.To_Unbounded_String("Overflow, Application_Types, Base_Integer_Type, * ");
         -- TBD Exception_Handler.output_exception_table_to_recorder(eventtext_rec => E,
         --                                                     bonus         => Error_Message);
         if (A > 0 and B > 0) or (A < 0 and B < 0) then
            -- An overflow can only have occurred > MAXINT
            return Base_Integer_Type'Last;
         else
            -- An overflow can only have occurred < MININT
            return Base_Integer_Type'First;
         end if;
         
   end "*";  -- for Base_Integer_Type

  --
  ----------------------------------------------------------------------------------------------
  --

  function "/" (Numerator: Base_Integer_Type; Denominator: Base_Integer_Type) return Base_Integer_Type is
  --
  -- THIS VERSION OF Integer divide DOES need to consider overflow conditions because it currently
  -- uses the full Integer range which is assymetric and causes problems when dividing by -1.
  --
    return_value: Base_Integer_Type := 1;
  begin
    if Denominator <= 0 and then Denominator >= -1 then -- need further checks
      if Numerator > 0 then
        if Denominator = 0 then
          return_value := Base_Integer_Type'last;
        else -- Denominator = -1
          if float(Numerator) >= - float (Base_Integer_Type'first) then
            return_value := Base_Integer_Type'first;
          else
            return_value := Base_Integer_Type(Integer (Numerator)/Integer(Denominator));
          end if;
        end if; -- Numerator >= 0
      elsif Numerator < 0 then -- Numerator is negative
        if Denominator = 0 then
          return_value := Base_Integer_Type'first;
        else
          if float(Numerator) <= - float (Base_Integer_Type'last) then
            return_value := Base_Integer_Type'last;
          else
            return_value := Base_Integer_Type(Integer (Numerator)/Integer(Denominator));
          end if;
        end if;
      else -- Numerator is zero
        return_value := 0;
      end if; -- Numerator >= 0.0

    else -- all is OK, carry on
      return_value := Base_Integer_Type(Integer (Numerator)/Integer(Denominator));
    end if; -- Denominator > -1.0 and then Denominator < 1.0

    return return_value;

  end "/";  -- for Base_Integer_Type
  --
   -- Non Debug build
  --
  ----------------------------------------------------------------------------------------------
  --
end Application_Types;


