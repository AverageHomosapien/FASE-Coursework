package train with SPARK_Mode is



   type rod is (Present, Missing);
   type Rod_Rng is range 0..4;
   type Rod_Arr is array (Rod_Rng) of rod;

   type carriage_capacity is new Integer;
   type carriage is (Attatched, Unattatched);
   type Carriage_Rng is range 0..4;
   type Carriage_Arr is array(Carriage_Rng) of carriage;

   type water_volume is new Integer; -- 0 to 100 (as % of total water capacity)
   type train_speed is new Integer; -- -10 to 100 (as % of speed limit)

   type Emerg_Stop is (Running, Stopped);
   type reactor_state is (Online, Offline);

   type overheat is (Overheating, Normal);

   type Dist_Travelled is new Integer;

   Rods : Rod_Arr := (Present, Missing, Missing, Missing, Missing); -- 5 rods
   Carriages : Carriage_Arr := (Unattatched, Unattatched, Unattatched, Unattatched, Unattatched);

   SpeedLimit : constant := 160;
   OverheatTemp : constant := 200.0;

   type Trains is record
      Rods : Rod_Arr;
      Rod_No : Integer range 1 .. 5;
      Reactor : reactor_state;
      Water : Integer;
      Speed : Integer range -20 .. 200;
      MaxSpeed : Integer range 100 .. 250;
      Carriages : Carriage_Arr;
      Carriage_No : Integer range 0 .. 5;
      Temperature : Float range 0.0 .. 300.0;
      Emergency_Stopped : Emerg_Stop;
      Overheating : overheat;
   end record;

   locomotive : Trains := (Rods => (Present, Missing, Missing, Missing, Missing),
                             Rod_No => 1, Reactor => Online,
                             Water => 100, Speed => 0, MaxSpeed => 200,
                             Carriages => (Unattatched, Unattatched, Unattatched, Unattatched, Unattatched),
                             Carriage_No => 0, Temperature => 0.0, Emergency_Stopped => Running,
                             Overheating => Normal);


   procedure Rod_Out (locomotive : in out Trains) with
     Pre => locomotive.Speed = 0 and locomotive.Rod_No > 1 and locomotive.Reactor = Offline,
     Post => locomotive.Rod_No = locomotive.Rod_No'Old -1 and locomotive.Rod_No >= 1;

   procedure Rod_In (locomotive : in out Trains) with
     Pre => locomotive.Speed = 0 and locomotive.Rod_No < 5 and locomotive.Reactor = Offline,
     Post => locomotive.Rod_No = locomotive.Rod_No'Old +1 and locomotive.Rod_No <= 5;

   procedure Water_Add (locomotive : in out Trains) with
     Pre => locomotive.Speed = 0 and locomotive.Water < 100 and locomotive.Reactor = Offline,
     Post => locomotive.Water <= 100;


   procedure Water_Rem (locomotive : in out Trains) with
     Pre => locomotive.Speed = 0 and locomotive.Water >= 1 and locomotive.Reactor = Offline,
     Post => locomotive.Water >= 0;

   procedure Update_Temp (locomotive : in out Trains; OverheatTemp : in Float) with -- Updates for reverse too
     Pre => locomotive.Rod_No > 0;

   procedure Accelerate (locomotive : in out Trains) with
     Pre => locomotive.Speed < locomotive.MaxSpeed and locomotive.Speed < SpeedLimit and locomotive.Reactor = Online,
     Post => locomotive.Speed <= locomotive.MaxSpeed and locomotive.Speed <= SpeedLimit;

   procedure Brake (locomotive : in out Trains) with
     Pre => locomotive.Speed > 0 and locomotive.Reactor = Online,
     Post => locomotive.Speed >= 0;

   procedure Backward_Accelerate (locomotive : in out Trains) with
     Pre => locomotive.Speed <= 0 and locomotive.Speed > -20 and locomotive.Reactor = Online,
     Post => locomotive.Speed >= -20;

   procedure Emergency_Stop (locomotive : in out Trains) with
     Pre => locomotive.Speed > 0 and locomotive.Reactor = Offline,
     Post => locomotive.Speed = 0;

   procedure Reactor_Offline (locomotive : in out Trains) with
     Pre => locomotive.Speed = 0 and locomotive.Reactor = Online,
     Post => locomotive.Speed = 0;

   procedure Reactor_Online (locomotive : in out Trains) with
     Pre => locomotive.Speed = 0 and locomotive.Reactor = Offline,
     Post => locomotive.Speed = 0;

   procedure Carriage_Rem (locomotive : in out Trains) with
     Pre => locomotive.Speed = 0 and locomotive.Carriage_No > 0,
     Post => locomotive.Speed = 0 and locomotive.Carriage_No = locomotive.Carriage_No'Old - 1 and locomotive.Carriage_No >= 0;

   procedure Carriage_Add (locomotive : in out Trains) with
     Pre => locomotive.Speed = 0 and locomotive.Carriage_No < 5,
     Post => locomotive.Speed = 0 and locomotive.Carriage_No = locomotive.Carriage_No'Old + 1 and locomotive.Carriage_No <= 5;

end train;
