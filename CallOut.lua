local CreateFrame = CreateFrame
local pairs = pairs
local print = print
local tinsert = table.insert

CallOut = {}

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
  print(spellID, CallOut.Media[spellID])
end

local function HandleUnitSpellcastChannelStart(self, event, unit, castGUID, spellID)
  print(spellID, CallOut.Media[spellID])
end

local function HandleUnitSpellcastSucceeded(self, event, unit, castGUID, spellID)
  print(spellID, CallOut.Media[spellID])
end

CallOut.Events = {
  PLAYER_LOGIN = {Units = nil, Handle = HandleLogin},
  UNIT_SPELLCAST_START = {Units = nil, Handle = HandleUnitSpellcastStart},  -- handles spell cast starts
  UNIT_SPELLCAST_CHANNEL_START = {Units = nil, Handle = HandleUnitSpellcastChannelStart}, -- handles spell channel starts
  UNIT_SPELLCAST_SUCCEEDED = {Units = nil, Handle = HandleUnitSpellcastSucceeded} -- handles instant non-cast spells
}

CallOut.RegisteredEventUpdateFrame = CreateFrame("Frame", nil, UIParent)
CallOut.RegisteredEventUpdateFrame:RegisterEvent("PLAYER_LOGIN")
CallOut.RegisteredEventUpdateFrame:SetScript("OnEvent", HandleEvent)
