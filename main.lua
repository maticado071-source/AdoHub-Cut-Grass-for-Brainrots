local a=game:GetService"HttpService"

local b="https://work.ink/2oqz/ado-hub-cut-grass-for-brainrots"
local c="https://work.ink/_api/v2/token/isValid/%s"

local function doRequest(d)
if syn and syn.request then
return syn.request(d)
elseif http and http.request then
return http.request(d)
elseif http_request then
return http_request(d)
elseif request then
return request(d)
else
error"executor does not support http requests"
end
end

local function validateWorkInkToken(d)
local e,f=pcall(function()
local e=doRequest{
Url=string.format(c,d),
Method="GET",
Headers={accept=
"application/json"
}
}

if not e or not e.Body then
return false,"no response"
end

local f=a:JSONDecode(e.Body)

if f and f.valid==true then
return true,f
end

return false,f
end)

if not e then
return false,f
end

return f
end

local d=loadstring(game:HttpGet'https://sirius.menu/rayfield')()

local e=game:GetService"Players"
local f=e.LocalPlayer
local g=game:GetService"ReplicatedStorage"
local h=game:GetService"RunService"
local i=game:GetService"PathfindingService"

local j=g:WaitForChild"Packages":WaitForChild"_Index":WaitForChild"acecateer_knit@1.7.2":WaitForChild"knit":WaitForChild"Services"
local k=j:WaitForChild"AttackService":WaitForChild"RE":WaitForChild"AttackRequested"
local l=j:WaitForChild"UpgradesService":WaitForChild"RE"
local m=j:WaitForChild"CuttersShopService":WaitForChild"RF":WaitForChild"BuyCutter"

local n=j:WaitForChild"DataService":WaitForChild"RF"
local o=n:WaitForChild"GetIsCarryingBrainrot"
local p=n:WaitForChild"GetEquippedInventoryKey"

local q=workspace:WaitForChild"Bases":WaitForChild(f.Name)

local r={
AutoSwing=false,
AutoCollect=false,
CollectInterval=5,
AutoHealth1=false,
AutoHealth10=false,
AutoCarry=false,
AutoSpeed=false,
AutoBuyCutter=false,
AutoBrainrot=false,
SelectedZone="Base_Zone",
WalkSpeed=16,
Noclip=false,
AntiAFK=true
}

local s=false
local t=0
local u=""

local function resetEverything()
r.AutoSwing=false
r.AutoCollect=false
r.AutoHealth1=false
r.AutoHealth10=false
r.AutoCarry=false
r.AutoSpeed=false
r.AutoBuyCutter=false
r.AutoBrainrot=false
r.Noclip=false
r.WalkSpeed=16

local v=f.Character
if v and v:FindFirstChild"Humanoid"then
v.Humanoid.WalkSpeed=16
end
end

local function revokeAccess(v)
if not s then return end
s=false
t=0
resetEverything()

d:Notify{
Title="Key Expired",
Content=v or"your key expired please verify again",
Duration=3,
Image=4483362458
}

task.wait(1.5)
f:Kick(v or"Your key expired. Run the script again and get a new key.")
end

local function requireAccess()
if not s then
d:Notify{
Title="No Access",
Content="verify your key first",
Duration=3,
Image=4483362458
}
return false
end
return true
end

f.Idled:Connect(function()
if r.AntiAFK then
game:GetService"VirtualUser":Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
task.wait(1)
game:GetService"VirtualUser":Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end
end)

local v=d:CreateWindow{
Name="⚡ Ado Hub | V2",
LoadingTitle="Initializing Ado Hub...",
LoadingSubtitle="By Ado",
ConfigurationSaving={Enabled=true,Folder="AdoHubConfig"}
}

local w=v:CreateTab("Key System",4483362458)

w:CreateInput{
Name="Enter Key",
PlaceholderText="paste your work.ink token here",
RemoveTextAfterFocusLost=false,
Callback=function(x)
u=x
end
}

w:CreateButton{
Name="Copy Get Key Link",
Callback=function()
if setclipboard then
setclipboard(b)
d:Notify{
Title="Copied",
Content="your get key link was copied",
Duration=4,
Image=4483362458
}
else
d:Notify{
Title="Error",
Content="setclipboard is not supported by your executor",
Duration=4,
Image=4483362458
}
end
end
}

w:CreateButton{
Name="Validate Key",
Callback=function()
if not u or u==""then
d:Notify{
Title="Error",
Content="enter a key first",
Duration=4,
Image=4483362458
}
return
end

local x,y=validateWorkInkToken(u)

if x and y and y.info and y.info.expiresAfter then
s=true
t=tonumber(y.info.expiresAfter)or 0

d:Notify{
Title="Success",
Content="key accepted",
Duration=4,
Image=4483362458
}
else
s=false
t=0

d:Notify{
Title="Invalid Key",
Content="token is invalid or expired",
Duration=4,
Image=4483362458
}
end
end
}

task.spawn(function()
while true do
task.wait(1)
if s and t>0 then
if DateTime.now().UnixTimestampMillis>=t then
revokeAccess"Your key expired. Get a new one from Work.ink."
break
end
end
end
end)

repeat task.wait()until s

local x=v:CreateTab("Main",4483362458)
local y=v:CreateTab("Upgrades & Cutters",4483362458)
local z=v:CreateTab("Teleports",4483362458)
local A=v:CreateTab("Player",4483362458)

local function getPromptPosition(B)
if not B or not B.Parent then return nil end
if B.Parent:IsA"BasePart"then
return B.Parent.Position
elseif B.Parent:IsA"Attachment"then
return B.Parent.WorldPosition
elseif B.Parent:IsA"Model"then
return B.Parent:GetPivot().Position
end
return nil
end

local function isHoldingBrainrot()
local B,C=pcall(function()
return o:InvokeServer()
end)
return B and C
end

local function isBrainrotEquipped()
local B,C=pcall(function()
return p:InvokeServer()
end)
if B and C then
return true
end

local D=f.Character
if D and g:FindFirstChild"Models"and g.Models:FindFirstChild"Brainrots"then
for E,F in pairs(D:GetChildren())do
if F:IsA"Model"and g.Models.Brainrots:FindFirstChild(F.Name)then
return true
end
end
end

return false
end

local function unequipBrainrot()
local B=f.Character
if B and B:FindFirstChildOfClass"Humanoid"then
B:FindFirstChildOfClass"Humanoid":UnequipTools()
end
end

local function walkTo(B)
local C=f.Character
if not C or not C:FindFirstChild"Humanoid"or not C:FindFirstChild"HumanoidRootPart"then return false end
local D=C.Humanoid
local E=C.HumanoidRootPart

D.WalkSpeed=r.WalkSpeed

local F
if typeof(B)=="Vector3"then
F=B
elseif typeof(B)=="Instance"then
F=B:GetPivot().Position
else
return false
end

if(E.Position-F).Magnitude<5 then return true end

local G=i:CreatePath{AgentCanJump=true,AgentRadius=2,AgentHeight=5}
local H=pcall(function()
G:ComputeAsync(E.Position,F)
end)

if H and G.Status==Enum.PathStatus.Success then
local I=G:GetWaypoints()
for J,K in ipairs(I)do
if not r.AutoBrainrot and not r.AutoCollect then return false end
D:MoveTo(K.Position)
if K.Action==Enum.PathWaypointAction.Jump then
D.Jump=true
end
D.MoveToFinished:Wait(0.5)
if(E.Position-F).Magnitude<4 then return true end
end
return true
else
D:MoveTo(F)
D.MoveToFinished:Wait(3)
return true
end
end

local function firePrompt(B)
if not B or not B:IsA"ProximityPrompt"then return end
local C=f.Character
if not C or not C:FindFirstChild"HumanoidRootPart"then return end

local D=C.HumanoidRootPart
local E=getPromptPosition(B)
if not E then return end

local F=(D.Position-E).Magnitude
if F<=(B.MaxActivationDistance+2)then
if fireproximityprompt then
fireproximityprompt(B)
else
B:InputHoldBegin()
task.wait(B.HoldDuration+0.1)
B:InputHoldEnd()
end
end
end

local function isStandOccupied(B)
local C=g:FindFirstChild"Models"and g.Models:FindFirstChild"Brainrots"
if not C then return false end

local D={}
for E,F in pairs(C:GetChildren())do
D[F.Name]=true
end

for E,F in pairs(B:GetChildren())do
if D[F.Name]then
return true
end
end
return false
end

local function getRandomBrainrot(B)
local C=workspace.Zones:FindFirstChild(B)
if not C or not C:FindFirstChild"SpawnZone"then return nil end

local D={}
for E,F in pairs(C.SpawnZone:GetChildren())do
if F:IsA"Model"and F.Parent and F:FindFirstChildWhichIsA("ProximityPrompt",true)then
table.insert(D,F)
end
end

if#D>0 then
return D[math.random(1,#D)]
end
return nil
end

x:CreateToggle{
Name="Auto Swing",
CurrentValue=false,
Callback=function(B)
if not requireAccess()then return end
r.AutoSwing=B
task.spawn(function()
while r.AutoSwing and s do
k:FireServer()
task.wait(0.1)
end
end)
end
}

x:CreateSlider{
Name="Auto Collect Interval (Seconds)",
Range={1,60},
Increment=1,
CurrentValue=5,
Callback=function(B)
r.CollectInterval=B
end,
}

x:CreateToggle{
Name="Auto Collect Money",
CurrentValue=false,
Callback=function(B)
if not requireAccess()then return end
r.AutoCollect=B
task.spawn(function()
while r.AutoCollect and s do
local C=q:FindFirstChild"Flors"and q.Flors:FindFirstChild"1_Floor"
if C then
for D,E in pairs(C:GetChildren())do
if string.match(E.Name,"Brainot_Stand")and isStandOccupied(E)then
local F=E:FindFirstChild"Sell_Button"
if F and F:FindFirstChild"Active_part"then
walkTo(F.Active_part)
task.wait(0.5)
end
end
end
end
task.wait(r.CollectInterval)
end
end)
end
}

local B={}
for C,D in pairs(workspace.Zones:GetChildren())do
if D.Name~="Bases"then
table.insert(B,D.Name)
end
end

x:CreateDropdown{
Name="Select Farm Zone",
Options=B,
CurrentOption={"Base_Zone"},
MultipleOptions=false,
Callback=function(C)
r.SelectedZone=C[1]
end,
}

x:CreateToggle{
Name="Auto Brainrot Collector",
CurrentValue=false,
Callback=function(C)
if not requireAccess()then return end
r.AutoBrainrot=C
task.spawn(function()
while r.AutoBrainrot and s do
if not r.SelectedZone or r.SelectedZone==""then
task.wait(1)
continue
end

if isHoldingBrainrot()then
if isBrainrotEquipped()then
unequipBrainrot()
end

local D=workspace.Zones:FindFirstChild"Base_Zone"
if D then
walkTo(D:GetPivot().Position)

local E=tick()
repeat
unequipBrainrot()
task.wait(0.2)
until not isHoldingBrainrot()or(tick()-E>8)or not r.AutoBrainrot or not s
end
else
local D=getRandomBrainrot(r.SelectedZone)
if D and D.Parent then
local E=D:FindFirstChildWhichIsA("ProximityPrompt",true)
if E and E.Parent then
local F=getPromptPosition(E)
if F then
local G=walkTo(F)
if G and E.Parent and s then
firePrompt(E)
task.wait(0.8)
end
end
end
else
task.wait(1)
end
end
task.wait(0.1)
end
end)
end
}

local function autoUpgradeLoop(C,D)
task.spawn(function()
while r[C]and s do
l:WaitForChild(D):FireServer()
task.wait(0.5)
end
end)
end

y:CreateToggle{
Name="Auto Health (+100)",
CurrentValue=false,
Callback=function(C)
if not requireAccess()then return end
r.AutoHealth1=C
autoUpgradeLoop("AutoHealth1","X1HealthButtonClicked")
end
}

y:CreateToggle{
Name="Auto Health (+1000)",
CurrentValue=false,
Callback=function(C)
if not requireAccess()then return end
r.AutoHealth10=C
autoUpgradeLoop("AutoHealth10","X10HealthButtonClicked")
end
}

y:CreateToggle{
Name="Auto Carry (+1)",
CurrentValue=false,
Callback=function(C)
if not requireAccess()then return end
r.AutoCarry=C
autoUpgradeLoop("AutoCarry","CarryButtonClicked")
end
}

y:CreateToggle{
Name="Auto Speed (+1)",
CurrentValue=false,
Callback=function(C)
if not requireAccess()then return end
r.AutoSpeed=C
autoUpgradeLoop("AutoSpeed","SpeedButtonClicked")
end
}

y:CreateToggle{
Name="Auto Buy Cutters",
CurrentValue=false,
Callback=function(C)
if not requireAccess()then return end
r.AutoBuyCutter=C
task.spawn(function()
while r.AutoBuyCutter and s do
for D,E in pairs(g.Weapons:GetChildren())do
pcall(function()
m:InvokeServer(E.Name)
end)
end
task.wait(5)
end
end)
end
}

for C,D in pairs(B)do
z:CreateButton{
Name="TP to "..D:gsub("_"," "),
Callback=function()
if not requireAccess()then return end
local E=workspace.Zones:FindFirstChild(D)
if E and f.Character and f.Character:FindFirstChild"HumanoidRootPart"then
f.Character.HumanoidRootPart.CFrame=E:GetPivot()*CFrame.new(0,5,0)
end
end,
}
end

z:CreateButton{
Name="TP to My Base",
Callback=function()
if not requireAccess()then return end
if q and f.Character and f.Character:FindFirstChild"HumanoidRootPart"then
f.Character.HumanoidRootPart.CFrame=q:GetPivot()*CFrame.new(0,5,0)
end
end,
}

A:CreateToggle{
Name="Anti-AFK",
CurrentValue=true,
Callback=function(C)
r.AntiAFK=C
end
}

A:CreateSlider{
Name="WalkSpeed",
Range={16,250},
Increment=1,
CurrentValue=16,
Callback=function(C)
if not requireAccess()then return end
r.WalkSpeed=C
if f.Character and f.Character:FindFirstChild"Humanoid"then
f.Character.Humanoid.WalkSpeed=C
end
end,
}

A:CreateToggle{
Name="Noclip",
CurrentValue=false,
Callback=function(C)
if not requireAccess()then return end
r.Noclip=C
end
}

h.Stepped:Connect(function()
if r.Noclip and s and f.Character then
for C,D in pairs(f.Character:GetDescendants())do
if D:IsA"BasePart"and D.CanCollide then
D.CanCollide=false
end
end
end
end)

d:LoadConfiguration()
