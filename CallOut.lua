local CreateFrame = CreateFrame
local PlaySoundFile = PlaySoundFile

local pairs = pairs
local print = print
local sfind = string.find
local tinsert = table.insert

CallOut = {}
CallOut.Version = "0.1.1"
CallOut.Release = 202012310734

SLASH_CALLOUT1 = "/callout"
SLASH_CALLOUT2 = "/co"

local function HandleEvent(self, event, ...)
	CallOut.Events[event](self, event, ...)
end

local function HandleLogin(self, event, ...)
	for event in pairs(CallOut.Events) do
    CallOut.RegisteredEventUpdateFrame:RegisterEvent(event)
	end
end

local function HandleSlashCommand(msg, ...)
  local _, _, cmd, args = sfind(msg, "%s?(%w+)%s?(.*)")
  if cmd == "version" then
    print("CallOut - Version: "..CallOut.Version)
    print("CallOut - Release: "..CallOut.Release)
  elseif cmd == "toggle" then 
    CallOutSettings.Enabled = not CallOutSettings.Enabled
  else
    print("CallOut - Usage: /callout (toggle|version)")
  end
end

local function ShouldPlayCallOut(event, unitTarget, spellID)
  if not CallOutSettings.Enabled then return false end
  if not CallOutSettings.Targets[unitTarget] then return false end
  if not CallOutSettings.SpellIDs[spellID].Enabled then return false end
  if not CallOutSettings.SpellIDs[spellID].InstantCast and event == "UNIT_SPELLCAST_SUCCEEDED" then return false end
  return true
end

local function HandleUnitSpellcast(self, event, unitTarget, castGUID, spellID)
  if ShouldPlayCallOut(event, unitTarget, spellID) then
    PlaySoundFile(CallOut.Sounds[spellID].File, CallOutSettings.SoundChannel)
  end
end

CallOut.Events = {
  PLAYER_LOGIN = HandleLogin,
  UNIT_SPELLCAST_START = HandleUnitSpellcast,  -- regular spell casts
  UNIT_SPELLCAST_CHANNEL_START = HandleUnitSpellcast, -- channeling spells
  UNIT_SPELLCAST_SUCCEEDED = HandleUnitSpellcast -- instant spell casts
}

CallOut.RegisteredEventUpdateFrame = CreateFrame("Frame", nil, UIParent)
CallOut.RegisteredEventUpdateFrame:RegisterEvent("PLAYER_LOGIN")
CallOut.RegisteredEventUpdateFrame:SetScript("OnEvent", HandleEvent)


SlashCmdList["CALLOUT"] = HandleSlashCommand
