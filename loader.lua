if getgenv then if getgenv().BC____ then return end else if shared.BC____ then return end end
if getgenv and getgenv() ~= nil then
	getgenv().BC____=true
else shared.BC____=true end

--Pre-References:

local oloadstring=loadstring
local loadstring=function(contents:string,chunkname:string)
	local callback,response=pcall(function()
		return {oloadstring(contents,chunkname)}
	end)
	return unpack(response),callback
end

--Services:

local runservice=game:GetService("RunService")
local uis=game:GetService("UserInputService")
local isstudio=runservice:IsStudio()
local lplr=game.Players.LocalPlayer
local char=lplr.Character
local UIHolder=isstudio and lplr:FindFirstChildWhichIsA("PlayerGui") or (gethui and gethui() or game:GetService("CoreGui"))
local cmd_env
local ts=game:GetService("TweenService")
local ti1=TweenInfo.new(0.5,Enum.EasingStyle.Quint,Enum.EasingDirection.Out,0,false,0)
local connections={}

--HTML Services:

local HTML={
	Services={
		__UI="https://raw.githubusercontent.com/LuaULord/CPI/refs/heads/main/ulo.lua",
		__COMMANDS="https://raw.githubusercontent.com/LuaULord/CPI/refs/heads/main/DDTS.luau"
	},
}

local ui=not isstudio and loadstring(game:HttpGet(HTML.Services.__UI) )() or nil
local enviroment=not isstudio and loadstring(game:HttpGet(HTML.Services.__COMMANDS) )() or nil

--assert(not ui and not isstudio, "failed to load ui.")

--Instances:

ui=isstudio and script.Parent :: ScreenGui
local back=ui.back :: Frame
local storage=ui.d :: Folder
local lay=back.lay ::Frame
local messag=back.messaging.text :: TextBox
local scroll=back.scroll :: ScrollingFrame
local x=lay.X :: TextButton
local head=lay.head :: ImageLabel
local headtext=lay.headtext :: TextLabel
local sendMSG=back.sendmsg.button :: TextButton

--Tasks:

ui.Parent=UIHolder
ui.Enabled=false
if protect_gui then protect_gui(ui) end
if storage then storage.Parent=nil end

--Properties:

local properties={
	ToggleUIKey=Enum.KeyCode.RightAlt
}

--Functionality:

local function clearLines()
	for _, s in pairs(scroll:GetChildren()) do
		if not s:IsA("Frame") then continue end
		s:Destroy()
	end
end

local function sendLine(Info:string,Text:string,InfoColor:Color3)
	local msg=storage:FindFirstChild("message")
	if not msg then return end
	msg=msg:Clone()
	msg.text.Text=Text or "";
	msg.info.Text=Info..":" or "";
	msg.Parent=scroll
	msg.Visible=true
	msg.info.TextColor3=InfoColor or msg.info.TextColor3
end

local function runCommand(Name:string,args:{any})
	if not cmd_env then return end
	local cmd
	for name, p in pairs(cmd_env) do
		if cmd then continue end
		if tostring(name:lower())==Name:lower() then
			cmd=p::any
		end end
	return pcall(function()cmd(args) end)
end

local function closeGUI()
	if not ui then return end
	ui:Destroy()
	if getgenv then if getgenv().BC____ then  getgenv().BC____ = false end else if shared.BC____ then shared.BC____ = false end end
	for _, c in pairs(connections) do
		if c then c:Disconnect() end
	end
end

local function getPlayerOffData(data:any)

end

local function getargs(text:string)
	local args=text:split(" ")
	local commandname=args[1]
	table.remove(args,1)
	return commandname,args
end

local function setup_services()
	headtext.Text=lplr.DisplayName
	head.Image=game.Players:GetUserThumbnailAsync(lplr.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size420x420)
	if not enviroment and not isstudio then sendLine("system.commands","Failed to load all commands for cheat.",Color3.fromRGB(201, 75, 53)) end
	if getgenv and getgenv() then
		getgenv().__DDTS=enviroment
	else
		shared.__DDTS=enviroment
	end
end

--UI Functionality:

table.insert(connections,messag.FocusLost:Connect(function(isenter)
	local currentextbox=messag
	if isenter then
		local c,a=getargs(currentextbox.Text)
		if c:gsub(" ","") == "" then return end
		currentextbox.Text=""
		if not c then return end
		if not (function() for name,_ in pairs(cmd_env) do if tostring(name):lower()==c:lower() then return name end end end)() then sendLine("system.commands","Did not find command with name '"..c.."'",Color3.fromRGB(255, 255, 112)) return end
		local callback,response=runCommand(c,a)
		if callback ~= true then sendLine(c or "command",callback,Color3.fromRGB(255, 101, 87))end
	end
	return
end))

table.insert(connections,uis.InputBegan:Connect(function(input)
	local currentextbox=uis:GetFocusedTextBox()
	if input.KeyCode==properties.ToggleUIKey then
		back.Visible=not back.Visible
	end end))

table.insert(connections,x.MouseEnter:Connect(function()
	ts:Create(x,ti1,{
		BackgroundColor3=Color3.fromRGB(201, 75, 53),
		BackgroundTransparency=0.5,
		TextColor3=Color3.fromRGB(201, 75, 53)
	}):Play()
end))

table.insert(connections,x.MouseLeave:Connect(function()
	ts:Create(x,ti1,{
		BackgroundColor3=Color3.fromRGB(197, 200, 201),
		BackgroundTransparency=1,
		TextColor3=Color3.fromRGB(197, 200, 201)
	}):Play()
end))
table.insert(connections,x.MouseButton1Click:Connect(closeGUI))
table.insert(connections,sendMSG.MouseButton1Click:Connect(function()
	local currentextbox=messag
		local c,a=getargs(currentextbox.Text)
		if c:gsub(" ","") == "" then return end
		currentextbox.Text=""
		if not c then return end
		if not (function() for name,_ in pairs(cmd_env) do if tostring(name):lower()==c:lower() then return name end end end)() then sendLine("system.commands","Did not find command with name '"..c.."'",Color3.fromRGB(255, 255, 112)) return end
		local callback,response=runCommand(c,a)
		if callback ~= true then sendLine(c or "command",callback,Color3.fromRGB(255, 101, 87))end
end))

--End:

sendLine("system.startup",`The Cheat Is Started; Welcome {lplr.Name}.`)
ui.Enabled=true
setup_services()

--HTML INTERUPTION:

local fromUI={
	clear=clearLines,
}

if getgenv and getgenv() ~= nil then 
	if not getgenv().__DDTS then cmd_env=fromUI return end
	cmd_env=getgenv().__DDTS
	for m,iv in pairs(fromUI) do
		cmd_env[m]=iv
	end
else 
	if not shared.__DDTS then cmd_env=fromUI return end
	cmd_env=shared.__DDTS
	for m,iv in pairs(fromUI) do
		cmd_env[m]=iv
	end
end

return true
