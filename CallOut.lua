local CreateFrame = CreateFrame
local PlaySoundFile = PlaySoundFile

local pairs = pairs
local print = print
local tinsert = table.insert

CallOut = {}


local function HandleEvent(self, event, ...)
	CallOut.Events[event](self, event, ...)
end

local function HandleLogin(self, event, ...)
	for event in pairs(CallOut.Events) do
    CallOut.RegisteredEventUpdateFrame:RegisterEvent(event)
	end
end

local function ShouldPlayCallOut(event, unitTarget, spellID)
  if not CallOut.Settings.Enabled then return false end
  if not CallOut.Settings.Targets[unitTarget] then return false end
  if not CallOut.Settings.SpellIDs[spellID].Enabled then return false end
  if not CallOut.Settings.SpellIDs[spellID].InstantCast and event == "UNIT_SPELLCAST_SUCCEEDED" then return false end
  return true
end

local function HandleUnitSpellcast(self, event, unitTarget, castGUID, spellID)
  if ShouldPlayCallOut(event, unitTarget, spellID) then
    PlaySoundFile(CallOut.Sounds[spellID].File, CallOut.Settings.SoundChannel)
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
