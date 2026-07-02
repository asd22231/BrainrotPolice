return function(section, data)
  local elements = import("rbxassetid://113037265185555")
  local stuff = loadstring(game:HttpGet(getgitpath("src").."elements.lua"))()
  
  local autoClickEnabled = false
  local autoClickConnection = nil
  
  local autoWinEnabled = false
  local autoWinConnection = nil
  
  local Event = game:GetService("ReplicatedStorage").Packages._Index["sleitnick_knit@1.7.0"].knit.Services.KickService.RF.AddKick
  local winCFrame = CFrame.new(201.790634, 15.3777494, -4861.59863, -1, 0, 0, 0, 1, 0, 0, 0, -1)
  
  local function toggleAutoClick(enabled)
    if autoClickConnection then
      autoClickConnection:Disconnect()
      autoClickConnection = nil
    end
    
    if enabled then
      autoClickConnection = game:GetService("RunService").Heartbeat:Connect(function()
        Event:InvokeServer(nil)
      end)
    end
  end
  
  local function toggleAutoWin(enabled)
    if autoWinConnection then
      autoWinConnection:Disconnect()
      autoWinConnection = nil
    end
    
    if enabled then
      local player = game:GetService("Players").LocalPlayer
      autoWinConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
          player.Character.HumanoidRootPart.CFrame = winCFrame
        end
      end)
    end
  end
  
  stuff:Label("+1 Ammo Per Click", section)
  stuff:Label("Auto Click", section)
  
  stuff:Toggle("Auto Click", section, false, function(state)
    autoClickEnabled = state
    toggleAutoClick(state)
  end)
  
  stuff:Label("Auto Win", section)
  
  stuff:Toggle("Auto Win", section, false, function(state)
    autoWinEnabled = state
    toggleAutoWin(state)
  end)
end
