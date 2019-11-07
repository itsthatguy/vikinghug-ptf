local VHPlayerFrame = {}

-- target frames
function VHPlayerFrame:init()
  self.frame, self.controller = self:CreateContainer()
  self:CreateBars()
  self:CreateEvents(self.frame)

  self.playerHealthTextFrame = self.PlayerHealthText:create()
  self.playerHealthTextFrame:init()

  self.playerPowerTextFrame = self.PlayerPowerText:create()
  self.playerPowerTextFrame:init()

  self:CreateMP6()
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


--
--
-- MP6 Bar
-- TODO: MOVE THIS
--
function VHPlayerFrame:CreateMP6()
  local frameName = "VH_MP6_FRAME"
  local mp6Frame = CreateFrame("Frame", frameName, UIParent)
  mp6Frame:SetSize(1, 1)
  mp6Frame:SetPoint("TOPLEFT", self.frame, "TOP", 20, 0)

   -- bar
  mp6Frame.bar = CreateFrame('StatusBar', "VH_MP6_BAR", mp6Frame)
  mp6Frame.bar:SetPoint("TOPLEFT", frameName, "TOPLEFT", 0, 0)
  
  -- Style it
  mp6Frame.bar:SetSize(8, 60)
  mp6Frame.bar:SetStatusBarTexture(VH_TEXTURES.SOLID)
  mp6Frame.bar:SetBackdrop({ bgFile = VH_TEXTURES.SOLID })
  mp6Frame.bar:SetBackdropColor(ParseColor(VH_COLORS.BG, 0.6))
  mp6Frame.bar:SetStatusBarColor(ParseColor(VH_COLORS.YELLOW, 1))
  
  mp6Frame.bar:SetOrientation('VERTICAL')
  mp6Frame.bar:SetMinMaxValues(0, 1)


  mp6Frame.running = false
  mp6Frame.limit = 0.05
  mp6Frame.endTime = 0

  mp6Frame:Hide()
  mp6Frame.bar:Hide()

  mp6Frame:RegisterEvent("CURRENT_SPELL_CAST_CHANGED")
  mp6Frame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
  mp6Frame:SetScript("OnEvent", function(self, event, arg2, ...)
    if (event == "UNIT_SPELLCAST_SUCCEEDED") then
      self.endTime = GetTime() + 6
      self:Show()

      AnimateGroup("MP6_BAR_VALUE", {self.bar}, 'value', 1, 0, 6, function()
        -- Reuse the same animation group name, as to kill the old animation
        AnimateGroup("MP6_BAR", {self.bar}, 'alpha', 1, 0, 0.5, function()
          self.bar:Hide()
          self:Hide()
        end)
      end)
      AnimateGroup("MP6_BAR", {self.bar}, 'alpha', 0, 1, 0.5)

    -- NOTE: Why did I have this?
    -- elseif (event == "CURRENT_SPELL_CAST_CHANGED") then
    --   self.castChangeCount = self.castChangeCount + 1
    --   if (self.castChangeCount > 2) then
    --     self.castChangeCount = 0
    --   end
    end
  end)
end

Vikinghug.PlayerFrame = VHPlayerFrame