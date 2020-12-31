local CreateFrame = CreateFrame
local pairs = pairs
local print = print

CallOut = {}

local function HandleEvent(self, event, ...)
	CallOut.Events[event](self, event, ...)
end

local function HandleLogin(self, event, ...)
	for event in pairs(CallOut.Events) do
		CallOut.RegisteredEventUpdateFrame:RegisterEvent(event)
	end
end

local function HandleUnitSpellcastSent(self, event, caster, spellName, target)
  print(event, caster, spellName, target)
end

CallOut.Events = {
  PLAYER_LOGIN = HandleLogin,
  UNIT_SPELLCAST_SENT = HandleUnitSpellcastSent
}

CallOut.RegisteredEventUpdateFrame = CreateFrame("Frame", nil, UIParent)
CallOut.RegisteredEventUpdateFrame:RegisterEvent("PLAYER_LOGIN")
CallOut.RegisteredEventUpdateFrame:SetScript("OnEvent", HandleEvent
)