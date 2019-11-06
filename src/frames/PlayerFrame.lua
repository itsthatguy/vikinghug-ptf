local VHPlayerFrame = {}

-- target frames
function VHPlayerFrame:init()
  self.frame, self.controller = self:CreateContainer()
  FOOBAR = self
  self:CreateBars()
  self:CreateEvents(self.frame)

  self.playerHealthTextFrame = self.PlayerHealthText:create()
  self.playerHealthTextFrame:init()

  self.playerPowerTextFrame = self.PlayerPowerText:create()
  self.playerPowerTextFrame:init()
  -- self.playerHealthTextFrame = self.PlayerHealthText:create()
end

function VHPlayerFrame:CreateContainer() 
  local playerFrame = CreateFrame("Frame", VH_FRAMES.PLAYER_FRAME, nil)
  playerFrame:SetPoint("TOP", UIParent, "BOTTOM", 0, 240)
  playerFrame:SetSize(900, 30)

  local playerFrameController = CreateFrame("Button", VH_FRAMES.PLAYER_FRAME .. "_CONTROLLER", nil, "SecureActionButtonTemplate")
  playerFrameController:SetPoint("TOP", UIParent, "BOTTOM", 0, 240)
  playerFrameController:SetSize(500, 30)

  playerFrameController:SetAttribute("unit", "player")
  playerFrameController:EnableMouse(true)
  playerFrameController:RegisterForClicks("LeftButtonUp", "RightButtonUp")
  playerFrameController:SetAttribute("type1", "target")
  playerFrameController:SetAttribute("type2", "togglemenu")

  -- remove this start
  -- local texture = playerFrame:CreateTexture(nil, "BACKGROUND")
  -- texture:SetAllPoints()
  -- texture:SetColorTexture(1,1,1,.02)
  -- remove this end

  return playerFrame, playerFrameController
end

function VHPlayerFrame:CreateBars()
  self.playerHP = Vikinghug.HealthBar:create()
  self.playerHP:init("player", "VH_PLAYER_HEALTH", "HEALTH", VH_COLORS.RED, VH_BAR_POSITIONS.PLAYER_HEALTH)

  self.playerMP = Vikinghug.ManaBar:create()
  self.playerMP:init("player", "VH_PLAYER_MANA", "MANA", VH_COLORS.BLUE, VH_BAR_POSITIONS.PLAYER_MANA)

  self.playerEP = Vikinghug.EnergyBar:create()
  self.playerEP:init("player", "VH_PLAYER_ENERGY", "ENERGY", VH_COLORS.YELLOW, VH_BAR_POSITIONS.PLAYER_ENERGY)

  self.playerRP = Vikinghug.RageBar:create()
  self.playerRP:init("player", "VH_PLAYER_RAGE", "RAGE", VH_COLORS.ORANGE, VH_BAR_POSITIONS.PLAYER_RAGE)    
end

function VHPlayerFrame:CreateText()
  self:CreatePowerText()
end



-- function VHPlayerFrame:UpdatePowerText(event, state, this)
--   local _self = this ~= nil and this or self

--   _self.textCurrent:SetText("|cffffffff" .. tostring(state.power))
--   _self.textMax:SetText("|cffffffff" .. tostring(state.powerMax))
  
--   _self.textDivider:SetPoint("BOTTOMRIGHT", "VH_PLAYER_POWER_TEXT_MAX", 10, 6, "BOTTOMLEFT")
-- end

local function HandleEvents(self, event, ...)
  if (event == "UPDATE_SHAPESHIFT_FORM") then
    -- 1 = Bear Form
    -- 3 = Cat Form
    -- 4 = Travel Form / Aquatic Form
    return Reducer(VH_PLAYER, { type = 'SET_POWER_TYPE', value = { powerType = UnitPowerType("player") } })

  elseif (event == "UNIT_HEALTH") then
    return Reducer(VH_PLAYER, { type = 'SET_HEALTH' })


  elseif (event == "PLAYER_ENTERING_WORLD") then
    Reducer(VH_PLAYER, { type = 'SET_POWER_TYPE', value = { powerType = UnitPowerType("player") }  })
    Reducer(VH_PLAYER, { type = 'SET_HEALTH' })
    return Reducer(VH_PLAYER, { type = 'SET_MANA' })


  elseif (event == "UNIT_POWER_UPDATE") then
    return Reducer(VH_PLAYER, { type = 'SET_POWER' })
  end
end

function VHPlayerFrame:CreateEvents(frame) 
  frame:SetScript("OnEvent", HandleEvents)
  frame:RegisterEvent("UPDATE_SHAPESHIFT_FORM", "player")

  frame:RegisterEvent("UNIT_HEALTH", "player")
  frame:RegisterEvent("UNIT_POWER_UPDATE", "player")
  frame:RegisterEvent('PLAYER_ENTERING_WORLD')
end

Vikinghug.PlayerFrame = VHPlayerFrame