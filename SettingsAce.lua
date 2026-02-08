CDMSlashCommand = LibStub("AceAddon-3.0"):NewAddon("CDMSlashCommand", "AceConsole-3.0")

local defaults = {
    "cdm",
    "wa",
    "pepito"
}

CDMSlashCommandDB = CDMSlashCommandDB or CopyTable(defaults)

local function wrapName(name)
    return "|cffffd100" .. name .. "|r"
end

local options = {
    type = "group",
    name = "CDM Slash Command",
    args = {
        header = {
            order = 1,
            name = "Manage CDM Slash Command(s)",
            type = "header",
        },
        addCommand = {
            order = 2,
            type = "input",
            name = "Add Slash Command",
            usage = "slashCommandWithoutSpaces",
            width = "full",
            set = function(_, value)
                table.insert(CDMSlashCommandDB, value)
            end,
        },
        spacing1 = {
            order = 3,
            type = "description",
            name = "\nYou may also erase commands from the list:\n"
        },
        eraseCommand = {
            order = 4,
            type = "select",
            style = "dropdown",
            name = "",
            width = "full",
            values = function()
                local tempTable = {}
                if not next(CDMSlashCommandDB) then
                    return { [''] = 'No CDM Slash Commands Found!' }
                end
                for i, v in pairs(CDMSlashCommandDB) do
                    if type(v) == "string" then
                        tempTable[i] = v
                    end
                end
                return tempTable
            end,
            get = function(_, _) return false end,
            set = function(_, index, ...)
                CDMSlashCommandDB[index] = nil
            end,
        },
        spacing2 = {
            order = 5,
            type = "description",
            name = "\n"
        },
        listOfTexts = {
            order = 6,
            type = "description",
            fontSize = "medium",
            name = function()
                local text = wrapName("Slash Commands Added:") .. "\n\n"
                for k, v in pairs(CDMSlashCommandDB) do
                    if type(v) == "string" then
                        text = text .. " - " .. v .. "\n"
                    else
                        print(type(v))
                    end
                end
                return text
            end,
        },
        spacing3 = {
            order = 7,
            type = "description",
            name = "\n"
        },
        saveChanges = {
            order = 8,
            type = "execute",
            name = "Save Changes & Reload To Take Effect",
            width = "double",
            func = function(_, value)
                for key, _ in pairs(SlashCmdList) do
                    local i = 1
                    repeat
                        local slash = _G["SLASH_" .. key .. i]
                        if not slash then break end
                        if key == "CDMSC" then
                            print(key, i, slash)
                            print(string.sub(slash, 2))
                        end
                        i = i + 1
                    until not slash
                end
                ReloadUI()
            end,
        },
    },
}

function CDMSlashCommand:OnInitialize()
    self:InitializeOptions()
    self:InitializeSlashCommands()
end

function CDMSlashCommand:InitializeOptions()
    LibStub("AceConfig-3.0"):RegisterOptionsTable("CDMSlashCommand", options)
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("CDMSlashCommand")
    self:RegisterChatCommand("CDMSC", "SlashCommand")
    self.message = ""
end

function CDMSlashCommand:SlashCommand(msg)
    if not msg or msg:trim() == "" then
        Settings.OpenToCategory(self.optionsFrame.name)
    end
end

function CDMSlashCommand:GetMessage(info)
    return self.message
end

function CDMSlashCommand:SetMessage(info, value)
    self.message = value
end
