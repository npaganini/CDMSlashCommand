-- API cache
local IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local InCombatLockdown = InCombatLockdown

-- Global environment
local _G = _G
local CooldownViewerSettings = _G.CooldownViewerSettings

-- Don't register /wa if WeakAuras is loaded
local waLoaded = IsAddOnLoaded('WeakAuras')
if waLoaded then
	print('CDM Slash Command: WeakAuras AddOn detected, only registering /cdm and skipping /wa')
end

local function ShowCooldownViewerSettings()
	if InCombatLockdown() or not CooldownViewerSettings then return end

	if not CooldownViewerSettings:IsShown() then
		CooldownViewerSettings:Show()
	else
		CooldownViewerSettings:Hide()
	end
end

function CDMSlashCommand:InitializeSlashCommands()
	for _, cmd in ipairs(CDMSlashCommandDB) do
		if cmd == "wa" then
			if not waLoaded then
				self:RegisterChatCommand(cmd, function(_, input)
					ShowCooldownViewerSettings()
				end)
			end
		else
			self:RegisterChatCommand(cmd, function(_, input)
				ShowCooldownViewerSettings()
			end)
		end
	end
end
