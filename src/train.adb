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
      temp : Float;
   begin
      temp := (locomotive.Electricity / 2.0) + (2500.0 / (Float(locomotive.Water) + 1.0));
      if (temp >= OverheatTemp) then
         locomotive.Emergency_Stopped := Stopped;
         Emergency_Stop(locomotive => locomotive);
         locomotive.Temperature := 20.0;
      elsif (temp < 5.0) then
         locomotive.Temperature := 5.0;
      else
        locomotive.Temperature := temp;
      end if;
   end Update_Temp;

   procedure Update_Current_Electricity (locomotive : in out Trains) is
      temp : Float;
   begin

      temp := Float((locomotive.Speed - 50) * (locomotive.Carriage_No + 4)) / 4.0;
      if (locomotive.Speed > 50) then
         if (temp > locomotive.MaxElectricity) then
            locomotive.Electricity := locomotive.MaxElectricity;
         end if;
      elsif (temp < 20.0) then
         locomotive.Electricity := 20.0;
      else
         locomotive.Electricity := Float(50 * (locomotive.Carriage_No + 4)) / 4.0;
      end if;
   end Update_Current_Electricity;

   procedure Update_Max_Electricity (locomotive : in out Trains) is
   begin
      locomotive.MaxElectricity := 1200.0 / Float(locomotive.Rod_No + 4);
   end Update_Max_Electricity;

   procedure Update_Max_Speed (locomotive : in out Trains) is
   begin
      locomotive.MaxSpeed := ((Integer(locomotive.MaxElectricity) * 4) / (locomotive.Carriage_No + 4)) + 50;
   end Update_Max_Speed;



   procedure Reactor_Offline (locomotive : in out Trains) is
   begin
      locomotive.Reactor := Offline;
   end Reactor_Offline;

   procedure Reactor_Online (locomotive : in out Trains) is
   begin
      locomotive.Reactor := Online;
   end Reactor_Online;



   procedure Accelerate (locomotive : in out Trains) is
   begin
      locomotive.Speed := (locomotive.Speed +1);
   end Accelerate;

   procedure Brake (locomotive : in out Trains) is
   begin
      locomotive.Speed := (locomotive.Speed -1);
   end Brake;

   procedure Emergency_Stop (locomotive : in out Trains) is
   begin
      locomotive.Reactor := Offline;
      while locomotive.Speed > 0 loop
         locomotive.Speed := locomotive.Speed -1;
      end loop;
   end Emergency_Stop;



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
