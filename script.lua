local P=game:GetService("Players"); local RS=game:GetService("RunService"); local UIS=game:GetService("UserInputService"); local LP=P.LocalPlayer
local char=LP.Character or LP.CharacterAdded:Wait(); local hum=char:WaitForChild("Humanoid",5); local hrp=char:WaitForChild("HumanoidRootPart",5)
local cam=workspace.CurrentCamera
local flying=false; local flySpeed=80; local flyBV; local flyBG; local flyDir=Vector3.zero
local noclip=false; local god=false; local speedOn=false; local aimOn=false
local function applyGod() if god then hum.MaxHealth=math.huge; hum.Health=math.huge end end
local function applySpeed() if speedOn then hum.WalkSpeed=100 else hum.WalkSpeed=16 end end
LP.CharacterAdded:Connect(function(c) task.wait(1); char=c; hum=c:WaitForChild("Humanoid",5); hrp=c:WaitForChild("HumanoidRootPart",5); applyGod(); applySpeed() end)
local g=Instance.new("ScreenGui"); g.Name="VeloxMenu"; g.ResetOnSpawn=false; g.IgnoreGuiInset=true
pcall(function() g.Parent=gethui and gethui() or game:GetService("CoreGui") end); if not g.Parent then g.Parent=LP:WaitForChild("PlayerGui",5) end
local icon=Instance.new("TextButton"); icon.Parent=g; icon.Size=UDim2.new(0,50,0,50); icon.Position=UDim2.new(0,20,0.5,-25); icon.BackgroundColor3=Color3.fromRGB(200,30,30); icon.Text=""; icon.Draggable=true; icon.Active=true
local ic=Instance.new("UICorner"); ic.Parent=icon; ic.CornerRadius=UDim.new(1,0)
local frame=Instance.new("Frame"); frame.Parent=g; frame.Size=UDim2.new(0,280,0,380); frame.Position=UDim2.new(0.5,-140,0.5,-190); frame.BackgroundColor3=Color3.fromRGB(15,15,15); frame.BackgroundTransparency=0.15; frame.Visible=false; frame.Active=true; frame.Draggable=true
local fc=Instance.new("UICorner"); fc.Parent=frame; fc.CornerRadius=UDim.new(0,12)
local fs=Instance.new("UIStroke"); fs.Parent=frame; fs.Color=Color3.fromRGB(200,30,30); fs.Thickness=2
local title=Instance.new("TextLabel"); title.Parent=frame; title.Size=UDim2.new(1,0,0,50); title.BackgroundTransparency=1; title.Text="VELOX MENU"; title.TextColor3=Color3.fromRGB(200,30,30); title.TextSize=22; title.Font=Enum.Font.GothamBold
local function makeBtn(txt,y)
 local b=Instance.new("TextButton"); b.Parent=frame; b.Size=UDim2.new(1,-30,0,45); b.Position=UDim2.new(0,15,0,y); b.BackgroundColor3=Color3.fromRGB(30,30,30); b.Text=txt; b.TextColor3=Color3.fromRGB(255,255,255); b.TextSize=16; b.Font=Enum.Font.GothamBold
 local bc=Instance.new("UICorner"); bc.Parent=b; bc.CornerRadius=UDim.new(0,8)
 local bs=Instance.new("UIStroke"); bs.Parent=b; bs.Color=Color3.fromRGB(200,30,30); bs.Thickness=1
 return b
end
local btnFly=makeBtn("🛫 FLY [OFF]",60)
local btnSpd=makeBtn("⚡ SPEED [OFF]",115)
local btnNc=makeBtn("👻 NOCLIP [OFF]",170)
local btnGod=makeBtn("🛡️ GOD [OFF]",225)
local btnAim=makeBtn("🎯 AIMBOT [OFF]",280)
icon.MouseButton1Click:Connect(function() frame.Visible=not frame.Visible end)
local function flash(b) b.BackgroundColor3=Color3.fromRGB(200,30,30); task.delay(0.15,function() b.BackgroundColor3=Color3.fromRGB(30,30,30) end) end
btnFly.MouseButton1Click:Connect(function()
 flash(btnFly)
 if flying then flying=false; if flyBV then flyBV:Destroy() end; if flyBG then flyBG:Destroy() end; hum.PlatformStand=false; btnFly.Text="🛫 FLY [OFF]"
 else flying=true; btnFly.Text="🛫 FLY [ON]"
 flyBV=Instance.new("BodyVelocity"); flyBV.Parent=hrp; flyBV.MaxForce=Vector3.new(9e9,9e9,9e9); flyBV.Velocity=Vector3.zero
 flyBG=Instance.new("BodyGyro"); flyBG.Parent=hrp; flyBG.MaxTorque=Vector3.new(9e9,9e9,9e9); flyBG.P=9e4; flyBG.CFrame=cam.CFrame
 end
end)
btnSpd.MouseButton1Click:Connect(function() flash(btnSpd); speedOn=not speedOn; applySpeed(); btnSpd.Text=speedOn and "⚡ SPEED [ON]" or "⚡ SPEED [OFF]" end)
btnNc.MouseButton1Click:Connect(function() flash(btnNc); noclip=not noclip; btnNc.Text=noclip and "👻 NOCLIP [ON]" or "👻 NOCLIP [OFF]" end)
btnGod.MouseButton1Click:Connect(function() flash(btnGod); god=not god; applyGod(); btnGod.Text=god and "🛡️ GOD [ON]" or "🛡️ GOD [OFF]" end)
btnAim.MouseButton1Click:Connect(function() flash(btnAim); aimOn=not aimOn; btnAim.Text=aimOn and "🎯 AIMBOT [ON]" or "🎯 AIMBOT [OFF]" end)
UIS.InputBegan:Connect(function(k,gp)
 if gp then return end
 if k.KeyCode==Enum.KeyCode.W then flyDir=Vector3.new(0,0,-1)
 elseif k.KeyCode==Enum.KeyCode.S then flyDir=Vector3.new(0,0,1)
 elseif k.KeyCode==Enum.KeyCode.A then flyDir=Vector3.new(-1,0,0)
 elseif k.KeyCode==Enum.KeyCode.D then flyDir=Vector3.new(1,0,0)
 elseif k.KeyCode==Enum.KeyCode.Space then flyDir=Vector3.new(0,1,0)
 elseif k.KeyCode==Enum.KeyCode.LeftShift then flyDir=Vector3.new(0,-1,0) end
end)
RS.RenderStepped:Connect(function()
 if flying and flyBV and flyBG then
  local d=cam.CFrame:VectorToWorldSpace(flyDir)
  if flyDir==Vector3.zero then flyBV.Velocity=Vector3.zero else flyBV.Velocity=d*flySpeed end
  flyBG.CFrame=cam.CFrame
 end
 if aimOn then
  local best; local bestD=math.huge
  for _,plr in ipairs(P:GetPlayers()) do
   if plr~=LP and plr.Character and plr.Character:FindFirstChild("Head") then
    if (LP.Team==nil) or (plr.Team~=LP.Team) then
     local h=plr.Character.Head; local d=(h.Position-cam.CFrame.Position).Magnitude
     if d<bestD then bestD=d; best=h end
    end
   end
  end
  if best then cam.CFrame=CFrame.new(cam.CFrame.Position,best.Position) end
 end
end)
RS.Stepped:Connect(function()
 if noclip and char then for _,v in ipairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide=false end end end
end)