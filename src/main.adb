with train; use train;
with Ada.Text_IO; use Ada.Text_IO;

procedure Main is

   choice : String (1..1);
   second_choice : String (1..1);

   procedure Print_Menu is begin
      Put_Line("");
      Put_Line("Reactor State: " & locomotive.Reactor'Image);
      Put_Line("Rods Inserted: " & locomotive.Rod_No'Image);
      Put_Line("Water Level: " & locomotive.Water'Image & "%");
      Put_Line("Current Electricity: " & Integer(locomotive.Electricity)'Image);
      Put_Line("Maximum Electricity: " & Integer(locomotive.MaxElectricity)'Image);
      Put_Line("Reactor Temperature: " & Integer(locomotive.Temperature)'Image);
      Put_Line("Overheating Temperature: " & Integer(OverheatTemp)'Image);
      Put_Line("Current Speed: " & locomotive.Speed'Image & " kph");
      Put_Line("Max Train Speed: " & locomotive.MaxSpeed'Image & " kph");
      Put_Line("Speed Limit: " & SpeedLimit'Image & " kph");
      Put_Line("Carriages Attached: " & locomotive.Carriage_No'Image);
      Put_Line("");
   end Print_Menu;


   procedure Select_Initial is begin
      Put_Line("c - Check Carriages");
      Put_Line("e - Check Electricity");
      Put_Line("r - Check Reactor");
      Put_Line("s - Check Speed");
      Put_Line("w - Check Water");
      Put_Line("q - Quit");
      Put_Line("");
   end Select_Initial;

   procedure Select_Carriage is begin
      Put_Line("You have " & locomotive.Carriage_No'Image & " carriage(s) attached from a possible total of 5. You must be stationary to attach or remove a carriage.");
      Put_Line("a - Add Carriage");
      Put_Line("r - Remove Carriage");
      Put_Line("e - exit to menu");
      Put_Line("");
   end Select_Carriage;

   procedure Select_Reactor is begin
      Put_Line("You have " & locomotive.Rod_No'Image & " rod(s) inserted from a possible total of 5. You must be stationary to insert or remove a rod.");
      Put_Line("a - Add Rod");
      Put_Line("r - Remove Rod");
      Put_Line("t - Activate/Deactivate Reactor");
      Put_Line("e - exit to menu");
      Put_Line("");
   end Select_Reactor;

   procedure Select_Water is begin
      Put_Line("The water capacity is at" & locomotive.Water'Image & "%. The reactor must be off to add water.");
      Put_Line("a - Add Water");
      Put_Line("r - Remove Water");
      Put_Line("e - exit to menu");
      Put_Line("");
   end Select_Water;

   procedure Select_Speed is begin
      Put_Line("You are travelling at " & locomotive.Speed'Image & " kph.");
      Put_Line("Your reactor is " & locomotive.Reactor'Image);
      Put_Line("q - Increase Speed by 10");
      Put_Line("a - Decrease Speed by 10");
      Put_Line("w - Increase Speed");
      Put_Line("s - Decrease Speed");
      Put_Line("e - exit to menu");
      Put_Line("");
   end Select_Speed;

   procedure Select_Electricity is begin
      Put_Line("Maximum available electricity: " & locomotive.MaxElectricity'Image);
      Put_Line("Current electricity: " & locomotive.Electricity'Image);
      Put_Line("e - exit to menu");
      Put_Line("");
   end Select_Electricity;


begin
   choice := "z";
   while (choice /= "q") loop
      second_choice := "z";
      Update_Max_Electricity(locomotive => locomotive);
      Update_Max_Speed(locomotive => locomotive);
      Print_Menu;
      Select_Initial;
      Get(choice);

      if (choice = "c") then
         while (second_choice /= "e") loop
            Select_Carriage;
            Get(second_choice);
            if (locomotive.Speed > 0) then
               Put_Line("Carriages can't be attached or removed while moving");
            elsif (second_choice = "a") then
               if (locomotive.Carriage_No = MaxCarriages) then
                  Put_Line("We'd add more carriages, but I'm afraid we've run out. Sorry!");
               else
                  Carriage_Add(locomotive => locomotive);
                  Update_Max_Speed(locomotive => locomotive);
               end if;

            elsif (second_choice = "r") then
               if (locomotive.Carriage_No > 0) then
                  Carriage_Rem(locomotive => locomotive);
                  Update_Max_Speed(locomotive => locomotive);
               else
                  Put_Line("There are no more carriages to be removed");
               end if;
               --elsif (second_choice = "e") then
               --   Break;
            end if;
         end loop;
      elsif (choice = "e") then
         Select_Electricity;
         Get(second_choice);

      elsif (choice = "r") then
         while (second_choice /= "e") loop
            Select_Reactor;
            Get(second_choice);
            if (locomotive.Speed > 0) then
               Put_Line("Rods can't be added or removed while moving");

            elsif (second_choice = "t" and locomotive.Reactor = Online) then
               locomotive.Reactor := Offline;
               Put_Line("Reactor Offline!");
            elsif (second_choice = "t" and locomotive.Reactor = Offline) then
               locomotive.Reactor := Online;
               Put_Line("Reactor Online!");
            elsif (second_choice = "a") then
               if (locomotive.Reactor = Online) then
                  Put_Line("Can't add rods if the reactor is on");
               elsif (locomotive.Rod_No = MaxRods) then
                  Put_Line("We've no more space for rods");
               else
                  Rod_In(locomotive => locomotive);
                  Update_Max_Electricity(locomotive => locomotive);
                  Update_Max_Speed(locomotive => locomotive);
               end if;
            elsif (second_choice = "r") then
               if (locomotive.Reactor = Online) then
                  Put_Line("Can't remove rods if the reactor is on");
               elsif (locomotive.Rod_No > 1) then
                  Rod_Out(locomotive => locomotive);
                  Update_Max_Electricity(locomotive => locomotive);
                  Update_Max_Speed(locomotive => locomotive);
               else
                  Put_Line("There are no more rods to be removed");
               end if;
            end if;
         end loop;

      elsif (choice = "s") then
         while (second_choice /= "e") loop
            Select_Speed;
            Get(second_choice);
            if (locomotive.Reactor = Offline) then
               Put_Line("The reactor must be on to to move");
            elsif (second_choice = "q") then
               if (locomotive.Speed = locomotive.MaxSpeed or locomotive.Speed = SpeedLimit) then
                  Put_Line("I hope you're not trying to speed");
               elsif ((locomotive.Speed + 10) > locomotive.MaxSpeed) then
                  while (locomotive.Speed < locomotive.MaxSpeed) loop
                     Accelerate(locomotive => locomotive);
                  end loop;
               elsif ((locomotive.Speed + 10) > SpeedLimit) then
                  while (locomotive.Speed < SpeedLimit) loop
                     Accelerate(locomotive => locomotive);
                  end loop;
               else
                  for J in 0..9 loop
                     Accelerate(locomotive => locomotive);
                  end loop;
               end if;
            elsif (second_choice = "a") then
               if (locomotive.Speed = 0) then
                  Put_Line("You can't break if you're still");
               elsif ((locomotive.Speed - 10) < 0) then
                  while (locomotive.Speed < 0) loop
                     Brake(locomotive => locomotive);
                  end loop;
               else
                  for J in 0..9 loop
                     Brake(locomotive => locomotive);
                  end loop;
               end if;
            elsif (second_choice = "w") then
               if (locomotive.Speed = locomotive.MaxSpeed or locomotive.Speed = SpeedLimit) then
                  Put_Line("I hope you're not trying to speed");
               else
                  Accelerate(locomotive => locomotive);
                  Update_Current_Electricity(locomotive => locomotive);
                  Update_Temp(locomotive => locomotive, OverheatTemp => OverheatTemp);
               end if;
            elsif (second_choice = "s") then
               if (locomotive.Speed > 0) then
                  Brake(locomotive => locomotive);
                  Update_Current_Electricity(locomotive => locomotive);
                  Update_Temp(locomotive => locomotive, OverheatTemp => OverheatTemp);
               else
                  Put_Line("You can't break if you're still");
               end if;
            end if;
         end loop;

      elsif (choice = "w") then
         while (second_choice /= "e") loop
            Select_Water;
            Get(second_choice);
            if (locomotive.Reactor = Online) then
               Put_Line("Reactor must be off to add water");
            elsif (locomotive.Speed > 0) then
               Put_Line("Water can't be attached or removed while moving");
            elsif (second_choice = "a") then
               if (locomotive.Water = 100) then
                  Put_Line("After adding a dozen buckets of water, you've reached the top. You can't add any more");
               else
                  Water_Add(locomotive => locomotive);
               end if;
            elsif (second_choice = "r") then
               if (locomotive.Water > 0) then
                  Water_Rem(locomotive => locomotive);
               else
                  Put_Line("Water you doing? There's no more water to be removed");
               end if;
            end if;
         end loop;

      elsif (choice = "q") then
         Put_Line("Quitting... Thanks for using the Borst Atomic Train.");
         exit;
      end if;
   end loop;

end Main;


