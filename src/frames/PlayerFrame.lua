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

  self:CreateDividers()
  self:CreateMP6()
  self:CreateCastbar()
end

function VHPlayerFrame:CreateDividers()
  local dividerLeftFrame = CreateFrame("Frame", VH_FRAMES.PLAYER_FRAME .. "_DIVIDER_LEFT", UIParent)
  dividerLeftFrame:SetPoint("TOPRIGHT", VH_FRAMES.PLAYER_FRAME, "TOP", -32, 0)
  dividerLeftFrame:SetSize(4, 60)
  local textureLeft = dividerLeftFrame:CreateTexture(nil, "BACKGROUND")
  textureLeft:SetAllPoints()
  textureLeft:SetColorTexture(1,1,1,1)

  local dividerRightFrame = CreateFrame("Frame", VH_FRAMES.PLAYER_FRAME .. "_DIVIDER_RIGHT", UIParent)
  dividerRightFrame:SetPoint("TOPLEFT", VH_FRAMES.PLAYER_FRAME, "TOP", 32, 0)
  dividerRightFrame:SetSize(4, 60)
  local textureRight = dividerRightFrame:CreateTexture(nil, "BACKGROUND")
  textureRight:SetAllPoints()
  textureRight:SetColorTexture(1,1,1,1)
end

function VHPlayerFrame:CreateContainer() 
  local playerFrame = CreateFrame("Frame", VH_FRAMES.PLAYER_FRAME, nil)
  playerFrame:SetPoint("TOP", UIParent, "BOTTOM", 0, 200)
  playerFrame:SetSize(900, 30)

  local playerFrameController = CreateFrame("Button", VH_FRAMES.PLAYER_FRAME .. "_CONTROLLER", nil, "SecureActionButtonTemplate")
  playerFrameController:SetPoint("TOP", VH_FRAMES.PLAYER_FRAME, "TOP", 0, 0)
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
-- Cast Bar
-- TODO: MOVE THIS
--
function VHPlayerFrame:CreateCastbar()
  local frameName = "VH_CAST_FRAME"
  local castFrame = CreateFrame("Frame", frameName, UIParent)
  castFrame:SetSize(1, 1)
  castFrame:SetPoint("TOPRIGHT", self.frame, "TOP", -18, 0)

   -- bar
  castFrame.bar = CreateFrame('StatusBar', "VH_CAST_BAR", castFrame)
  castFrame.bar:SetPoint("TOPRIGHT", frameName, "TOPRIGHT", 0, 0)
  
  -- Style it
  castFrame.bar:SetSize(10, 60)
  castFrame.bar:SetStatusBarTexture(VH_TEXTURES.SOLID)
  castFrame.bar:SetBackdrop({ bgFile = VH_TEXTURES.SOLID })
  castFrame.bar:SetBackdropColor(ParseColor(VH_COLORS.BG, 0.6))
  castFrame.bar:SetStatusBarColor(ParseColor(VH_COLORS.YELLOW, 1))
  
  castFrame.bar:SetOrientation('VERTICAL')
  castFrame.bar:SetMinMaxValues(0, 1)

  castFrame.text = castFrame:CreateFontString("VH_CAST_TEXT")
  castFrame.text:SetFont(VH_FONTS.FORCED_SQUARE, 20)
  castFrame.text:SetJustifyH("CENTER")
  castFrame.text:SetPoint("TOP", self.frame, "BOTTOM", 0, -4)
  castFrame.text:SetText(12345)

  CFT = castFrame.text

  castFrame.nameText = castFrame:CreateFontString("VH_CAST_NAME_TEXT")
  castFrame.nameText:SetFont(VH_FONTS.FORCED_SQUARE, 32)
  castFrame.nameText:SetJustifyH("CENTER")
  castFrame.nameText:SetPoint("TOP", self.frame, "BOTTOM", 0, -30)
  castFrame.nameText:SetText(12345)

  CNFT = castFrame.nameText

  castFrame:Hide()
  castFrame.bar:Hide()

  castFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START", "player")
  castFrame:RegisterEvent("UNIT_SPELLCAST_START", "player")
  castFrame:RegisterEvent("UNIT_SPELLCAST_STOP", "player")
  castFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP", "player")
  castFrame:SetScript("OnEvent", function(self, event, arg2, arg, spellID)
    local channeling = (event == "UNIT_SPELLCAST_CHANNEL_START")

    if (event == "UNIT_SPELLCAST_START" or channeling) then
      local info = (channeling) and ChannelInfo or CastingInfo
      local name, _, _, startTimeMS, endTimeMS = info("player")
      local duration = (endTimeMS - startTimeMS) / 1000
      self.bar:SetMinMaxValues(0, duration)
      self:Show()
      self.nameText:SetText(name)

      -- Animations
      AnimateGroup("CAST_BAR_ALPHA", {self.bar}, 'alpha', self.bar:GetAlpha(), 1, 0.15)
      AnimateGroup("CAST_BAR_VALUE", {self.bar}, 'value',
        channeling and duration or 0,
        channeling and 0 or duration,
        duration
      )
      AnimateGroup("CAST_BAR_TEXT_VALUE", {self.text}, 'timetext',
        channeling and duration or 0,
        channeling and 0 or duration,
        duration
      )
      AnimateGroup("CAST_BAR_TEXT_ALPHA", {self.text, self.nameText}, 'alpha', self.bar:GetAlpha(), 1, 0.15)
      AnimateGroup("CAST_BAR_TEXT_Y", {self.text}, 'y', -14, -4, 0.1)
      AnimateGroup("CAST_BAR_NAME_TEXT_Y", {self.nameText}, 'y', -25, -30, 0.15)
      AnimateGroup("CAST_BAR_NAME_TEXT_HEIGHT", {self.nameText}, 'scale', 0.7, 1, 0.05)

    elseif (event == "UNIT_SPELLCAST_STOP" or "UNIT_SPELLCAST_CHANNEL_STOP") then
      AnimateGroup("CAST_BAR_ALPHA", {self.bar}, 'alpha', self.bar:GetAlpha(), 0, 0.25)
      AnimateGroup("CAST_BAR_TEXT_ALPHA", {self.text, self.nameText}, 'alpha', self.bar:GetAlpha(), 0, 0.25)
    end
  end)
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
  mp6Frame:SetPoint("TOPLEFT", self.frame, "TOP", 18, 0)

   -- bar
  mp6Frame.bar = CreateFrame('StatusBar', "VH_MP6_BAR", mp6Frame)
  mp6Frame.bar:SetPoint("TOPLEFT", frameName, "TOPLEFT", 0, 0)
  
  -- Style it
  mp6Frame.bar:SetSize(10, 60)
  mp6Frame.bar:SetStatusBarTexture(VH_TEXTURES.SOLID)
  mp6Frame.bar:SetBackdrop({ bgFile = VH_TEXTURES.SOLID })
  mp6Frame.bar:SetBackdropColor(ParseColor(VH_COLORS.BG, 0.6))
  mp6Frame.bar:SetStatusBarColor(ParseColor(VH_COLORS.YELLOW, 1))
  
  mp6Frame.bar:SetOrientation('VERTICAL')
  mp6Frame.bar:SetMinMaxValues(0, 1)

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
        AnimateGroup("MP6_BAR", {self.bar}, 'alpha', 1, 0, 0.15, function()
          self.bar:Hide()
          self:Hide()
        end)
      end)
      AnimateGroup("MP6_BAR", {self.bar}, 'alpha', 0, 1, 0.25)

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