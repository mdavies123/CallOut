local CreateFrame = CreateFrame
local pairs = pairs
local print = print
local tinsert = table.insert

local SpellcastStarts = {}
local SpellcastSucceeds = {}

CallOut = {}

local function PlayCallOut(sound)
  if CallOut.Settings.Enabled then
    print(sound)
  end
end

local function HandleEvent(self, event, ...)
	CallOut.Events[event].Handle(self, event, ...)
end

local function HandleLogin(self, event, ...)
	for event, eventInfo in pairs(CallOut.Events) do
    if eventInfo.Units == nil then
      CallOut.RegisteredEventUpdateFrame:RegisterEvent(event)
    else
      CallOut.RegisteredEventUpdateFrame:RegisterUnitEvent(event, eventInfo.Units[1], eventInfo.Units[2])
    end
	end
end

local function HandleUnitSpellcastStart(self, event, unitTarget, castGUID, spellID)
  if CallOut.Settings.Targets[unitTarget] and CallOut.Settings.SpellIDs[spellID] then
    PlayCallOut(CallOut.Sounds[spellID].Name)
  end  
end

local function HandleUnitSpellcastChannelStart(self, event, unit, castGUID, spellID)
  if CallOut.Settings.Targets[unitTarget] and CallOut.Settings.SpellIDs[spellID] then
    PlayCallOut(CallOut.Sounds[spellID].Name)
  end  
end

local function HandleUnitSpellcastSucceeded(self, event, unit, castGUID, spellID)
  if CallOut.Settings.Targets[unitTarget] and CallOut.Settings.SpellIDs[spellID] then
    PlayCallOut(CallOut.Sounds[spellID].Name)
  end  
end

CallOut.Events = {
  PLAYER_LOGIN = {Units = nil, Handle = HandleLogin},
  UNIT_SPELLCAST_START = {Units = nil, Handle = HandleUnitSpellcastStart},  -- regular spell casts
  UNIT_SPELLCAST_CHANNEL_START = {Units = nil, Handle = HandleUnitSpellcastChannelStart}, -- channeling spells
  UNIT_SPELLCAST_SUCCEEDED = {Units = nil, Handle = HandleUnitSpellcastSucceeded} -- instant spell casts
}

CallOut.RegisteredEventUpdateFrame = CreateFrame("Frame", nil, UIParent)
CallOut.RegisteredEventUpdateFrame:RegisterEvent("PLAYER_LOGIN")
CallOut.RegisteredEventUpdateFrame:SetScript("OnEvent", HandleEvent)
