return function(tab, ui)
  local autoClickEnabled = false
  local autoClickConnection = nil
  
  local autoWinEnabled = false
  local autoWinConnection = nil
  
  local Event = nil
  local success, err = pcall(function()
    Event = game:GetService("ReplicatedStorage").Packages._Index["sleitnick_knit@1.7.0"].knit.Services.KickService.RF.AddKick
  end)
  
  if not success or not Event then
    warn("[BrainrotPolice] Failed to find AddKick remote: " .. tostring(err))
  end
  
  local winCFrame = CFrame.new(201.790634, 15.3777494, -4861.59863, -1, 0, 0, 0, 1, 0, 0, 0, -1)
  
  local function toggleAutoClick(enabled)
    if autoClickConnection then
      autoClickConnection:Disconnect()
      autoClickConnection = nil
    end
    
    if enabled then
      if not Event then
        warn("[BrainrotPolice] Auto-click cannot start - remote not found")
        return
      end
      autoClickConnection = game:GetService("RunService").Heartbeat:Connect(function()
        pcall(function()
          Event:InvokeServer(nil)
        end)
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
  
  ui:CreateLabel(tab, "+1 Ammo Per Click")
  ui:CreateLabel(tab, "Auto Click")
  
  local autoClickToggle = ui:CreateToggle(tab, "Auto Click", false, function(state)
    autoClickEnabled = state
    toggleAutoClick(state)
  end)
  
  ui:CreateLabel(tab, "Auto Win")
  
  local autoWinToggle = ui:CreateToggle(tab, "Auto Win", false, function(state)
    autoWinEnabled = state
    toggleAutoWin(state)
  end)
end
