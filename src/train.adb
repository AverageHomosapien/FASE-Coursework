package body train with SPARK_Mode is

   -- Removing a Control Rod from the Reactor (POP)
   procedure Rod_Out (locomotive : in out Trains) is
      a : Rod_Rng := locomotive.Rods'First;
      b : Rod_Rng := (locomotive.Rods'Last -1);
   begin
      for x in a..b loop
         locomotive.Rods(x) := locomotive.Rods((x + 1));
      end loop;
      locomotive.Rods(locomotive.Rods'Last) := Missing; -- Add 'Missing' at the end
      locomotive.Rod_No := locomotive.Rod_No - 1;
   end Rod_out;

   -- Inserting a Control Rod to the Reactor (PUSH)
   procedure Rod_In (locomotive : in out Trains) is
      a : Rod_Rng := (locomotive.Rods'First +1);
      b : Rod_Rng := locomotive.Rods'Last;
   begin
      for x in b..a loop
         locomotive.Rods(x) := locomotive.Rods((x - 1));
      end loop;
      locomotive.Rods(locomotive.Rods'First) := Present; -- Add 'Present' at the start
      locomotive.Rod_No := locomotive.Rod_No + 1;
   end Rod_In;



   procedure Water_Add (locomotive : in out Trains) is
   begin
      locomotive.Water := (locomotive.Water + 1);
      -- delay 0.1
   end Water_Add;

   procedure Water_Rem (locomotive : in out Trains) is
   begin
      locomotive.Water := (locomotive.Water - 1);
   end Water_Rem;

   procedure Update_Temp (locomotive : in out Trains; OverheatTemp : in Float) is
   begin
      locomotive.Temperature := abs (Float(locomotive.Speed) * 3.0) / (Float(locomotive.Rod_No) + 1.0);
      if (locomotive.Temperature > OverheatTemp and locomotive.Speed > 0) then
         locomotive.Emergency_Stopped := Stopped;
         locomotive.Reactor := Offline;
         Emergency_Stop(locomotive => locomotive);
      end if;
   end Update_Temp;



   procedure Accelerate (locomotive : in out Trains) is
   begin
      locomotive.Speed := (locomotive.Speed +1);
   end Accelerate;

   procedure Brake (locomotive : in out Trains) is
   begin
      locomotive.Speed := (locomotive.Speed -1);
   end Brake;

   procedure Backward_Accelerate (locomotive : in out Trains) is
   begin
      locomotive.Speed := (locomotive.Speed -1); --
   end Backward_Accelerate;

   procedure Emergency_Stop (locomotive : in out Trains) is
   begin
      locomotive.Reactor := Offline;
      while locomotive.Speed > 0 loop
         locomotive.Speed := locomotive.Speed -1;
      end loop;
   end Emergency_Stop;



   procedure Reactor_Offline (locomotive : in out Trains) is
   begin
      locomotive.Reactor := Offline;
   end Reactor_Offline;

   procedure Reactor_Online (locomotive : in out Trains) is
   begin
      locomotive.Reactor := Online;
   end Reactor_Online;



   -- Removing a Control Rod from the Reactor (POP)
   procedure Carriage_Rem (locomotive : in out Trains) is
      a : Carriage_Rng := locomotive.Carriages'First;
      b : Carriage_Rng := (locomotive.Carriages'Last -1);
   begin
      for x in a..b loop
         locomotive.Carriages(x) := locomotive.Carriages((x + 1));
      end loop;
      locomotive.Carriages(locomotive.Carriages'Last) := Unattatched; -- Add 'Unattatched' at the end
      locomotive.Carriage_No := locomotive.Carriage_No - 1;
   end Carriage_Rem;

   -- Inserting a Control Rod to the Reactor (PUSH)
   procedure Carriage_Add (locomotive : in out Trains) is
      a : Carriage_Rng := (locomotive.Carriages'First +1);
      b : Carriage_Rng := locomotive.Carriages'Last;
   begin
      for x in b..a loop
         locomotive.Carriages(x) := locomotive.Carriages((x - 1));
      end loop;
      locomotive.Carriages(locomotive.Carriages'First) := Attatched; -- Add 'Attatched' at the start
      locomotive.Carriage_No := locomotive.Carriage_No + 1;
   end Carriage_Add;

end train;
