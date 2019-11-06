Vikinghug = LibStub("AceAddon-3.0"):NewAddon("Vikinghug", "AceConsole-3.0")
Vikinghug.callbacks = Vikinghug.callbacks or LibStub("CallbackHandler-1.0"):New(Vikinghug)

local defaults = {}

function Vikinghug:OnInitialize()
  self:Print("=========== VIKINGHUG INITIALIZE ==========")
  self.db = LibStub("AceDB-3.0"):New("VikinghugDB", defaults, true)

  self.PlayerFrame:init()

  self.TargetFrame:create():init()
end