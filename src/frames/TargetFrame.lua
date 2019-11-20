VHTargetFrame = {}
VHTargetFrame_mt = { __index = VHTargetFrame }

function VHTargetFrame:create()
  local newInstance = {}
  setmetatable(newInstance, VHTargetFrame_mt)
  return newInstance
end

-- target frames
function VHTargetFrame:init()
  TargetFrame:SetScript("OnEvent", nil);
  TargetFrame:Hide();

  self.frame, self.controller = self:CreateContainer()
  self:CreateBars()
  self:CreateEvents(self.frame)
  self:CreateText()
  self:CreateClassIcon(self.textFrame)
end


function VHTargetFrame:CreateContainer()
  local targetFrame = CreateFrame("Frame", VH_FRAMES.TARGET_FRAME, nil)
  targetFrame:SetPoint("BOTTOM", VH_FRAMES.PLAYER_FRAME, "TOP", 0, 5)
  targetFrame:SetSize(900, 30)

  local targetFrameController = CreateFrame("Button", VH_FRAMES.TARGET_FRAME .. "_CONTROLLER", nil, "SecureActionButtonTemplate")
  targetFrameController:SetPoint("BOTTOM", VH_FRAMES.TARGET_FRAME, "BOTTOM", 0, 0)
  targetFrameController:SetSize(420, 30)

  targetFrameController:SetAttribute("unit", "target")
  targetFrameController:EnableMouse(true)
  targetFrameController:RegisterForClicks("LeftButtonUp", "RightButtonUp")
  targetFrameController:SetAttribute("type1", "target")
  targetFrameController:SetAttribute("type2", "togglemenu")

  -- remove this start
  -- local texture = targetFrameController:CreateTexture(nil, "BACKGROUND")
  -- texture:SetAllPoints()
  -- texture:SetColorTexture(1,1,1,.2)
  -- remove this end

  return targetFrame, targetFrameController
end

function VHTargetFrame:CreateBars()
  local targetHP = Vikinghug.HealthBar:create()
  targetHP:init("target", "VH_TARGET_HEALTH", "HEALTH", VH_COLORS.RED, VH_BAR_POSITIONS.TARGET_HEALTH)

  local targetMP = Vikinghug.ManaBar:create()
  targetMP:init("target", "VH_TARGET_MANA", "MANA", VH_COLORS.BLUE, VH_BAR_POSITIONS.TARGET_MANA)

  local targetEP = Vikinghug.EnergyBar:create()
  targetEP:init("target", "VH_TARGET_ENERGY", "ENERGY", VH_COLORS.YELLOW, VH_BAR_POSITIONS.TARGET_ENERGY)

  local targetRP = Vikinghug.RageBar:create()
  targetRP:init("target", "VH_TARGET_RAGE", "RAGE", VH_COLORS.ORANGE, VH_BAR_POSITIONS.TARGET_RAGE)
end

-- TargetFrame.lua
local function HandleTargetEvents(self, event, ...)
  if (event == "PLAYER_TARGET_CHANGED") then
    Reducer(VH_TARGET, { type ="SET_POWER_TYPE" })
    Reducer(VH_TARGET, { type = 'SET_HEALTH' })
    Reducer(VH_TARGET, { type = 'SET_MANA' })
    Reducer(VH_TARGET, { type = 'SET_ENERGY' })
    Reducer(VH_TARGET, { type = 'SET_RAGE' })
    Reducer(VH_TARGET, { type = 'SET_TARGET' })

  elseif (event == "UPDATE_SHAPESHIFT_FORM") then
    -- 1 = Bear Form
    -- 3 = Cat Form
    -- 4 = Travel Form / Aquatic Form
    Reducer(VH_TARGET, { type = 'SET_POWER_TYPE' })

  elseif (event == "UNIT_HEALTH") then
    Reducer(VH_TARGET, { type = 'SET_HEALTH' })

  elseif (event == "PLAYER_ENTERING_WORLD") then
    Reducer(VH_TARGET, { type ="SET_POWER_TYPE" })
    Reducer(VH_TARGET, { type = 'SET_HEALTH' })
    Reducer(VH_TARGET, { type = 'SET_POWER' })

  elseif (event == "UNIT_POWER_UPDATE") then
    Reducer(VH_TARGET, { type ="SET_POWER_TYPE" })
    Reducer(VH_TARGET, { type = 'SET_POWER' })
  end
end

function VHTargetFrame:CreateEvents(frame)
  frame:SetScript("OnEvent", HandleTargetEvents)
  frame:RegisterEvent("UPDATE_SHAPESHIFT_FORM", "target")
  frame:RegisterEvent("PLAYER_TARGET_CHANGED")
  frame:RegisterEvent('PLAYER_ENTERING_WORLD')
  frame:RegisterUnitEvent("UNIT_HEALTH", "target")
  frame:RegisterUnitEvent("UNIT_POWER_UPDATE", "target")
end

-------------------------------------------------------------------------
--
-- TEXT TEXT

function VHTargetFrame:CreateText()
  local textFrame = CreateFrame("Frame", "VH_TARGET_TEXT_FRAME", UIParent)
  textFrame:SetSize(240, 15)
  textFrame:SetPoint("BOTTOMRIGHT", VH_FRAMES.TARGET_FRAME, "BOTTOM", -40, 15)

  textFrame.text = textFrame:CreateFontString("VH_TARGET_TEXT_FRAME")
  textFrame.text:SetFont(VH_FONTS.STAATLICHES, 20)
  textFrame.text:SetJustifyH("RIGHT")
  textFrame.text:SetPoint("BOTTOMRIGHT", "VH_TARGET_TEXT_FRAME", 0, 5)

  -- local frameTexture = textFrame:CreateTexture(nil, "BACKGROUND")
  -- frameTexture:SetAllPoints()
  -- frameTexture:SetColorTexture(1,0,1, .5)

  -- self:UpdateTargetText("", VH_TARGET, textFrame)
  self.textFrame = textFrame
  self:ClearTarget()
  Vikinghug.RegisterCallback(self, VH_ACTIONS["target"].updateTargetText, self.UpdateTargetText, self)
  Vikinghug.RegisterCallback(self, VH_ACTIONS["target"].clearTarget, self.ClearTarget, self)
end

function VHTargetFrame:UpdateTargetText(event, state, this)
  if (self.textFrame:IsShown() ~= true) then
    self.textFrame:Show()
  end

  local _, classId = UnitClass("target")
  if (UnitIsPlayer("target") and classId ~= nil) then
    self.classIconFrame.texture:Show()
    self.classIconFrame.texture:SetTexture(VH_TEXTURES[classId .. "_ICON"])
    self.classIconFrame.bgTexture:SetTexture(VH_TEXTURES[classId .. "_ICON"])
    -- self.classIconFrame.texture:SetTexture(VH_TEXTURES["SHAMAN_ICON"])
  else
    self.classIconFrame.texture:Hide()
    self.classIconFrame.bgTexture:Hide()
  end

  self.textFrame.text:SetText(state.text)
end

function VHTargetFrame:ClearTarget(event, state)
  self.textFrame:Hide()
end

-- TEXT TEXT
--
-------------------------------------------------------------------------

-------------------------------------------------------------------------
--
-- CLASS ICON
function VHTargetFrame:CreateClassIcon(parent)
  local classIconFrame = CreateFrame("Frame", "VH_TARGET_CLASS_ICON", parent)
  classIconFrame:SetPoint("BOTTOM", "VH_TARGET_FRAME", "BOTTOM", 0, 0)
  classIconFrame:SetSize(52, 52)

  local bgTexture = classIconFrame:CreateTexture(nil, "BACKGROUND")
  -- bgTexture:SetAllPoints()
  bgTexture:SetSize(54, 54)
  bgTexture:SetTexture(VH_TEXTURES.DRUID_ICON)
  bgTexture:SetVertexColor(ParseColor(VH_COLORS.BG, 0.5))
  bgTexture:SetPoint("TOP", "VH_TARGET_CLASS_ICON", "TOP", 0, -1)

  local texture = classIconFrame:CreateTexture(nil, "BACKGROUND")
  texture:SetAllPoints()
  texture:SetTexture(VH_TEXTURES.DRUID_ICON)


  classIconFrame.texture = texture
  classIconFrame.bgTexture = bgTexture
  self.classIconFrame = classIconFrame
end

-- CLASS ICON END
--
-------------------------------------------------------------------------

--
--
-- Cast Bar
-- TODO: MOVE THIS
--
function VHTargetFrame:CreateCastbar()
  local baseFrameName = "VH_TARGET_CAST_"
  local frameName = baseFrameName .. "FRAME"
  local barName = baseFrameName .. "BAR"
  local castFrame = CreateFrame("Frame", frameName, UIParent)
  castFrame:SetSize(1, 1)
  castFrame:SetPoint("BOTTOMLEFT", self.frame, "BOTTOM", 40, 19)

   -- bar
  castFrame.bar = CreateFrame('StatusBar', barName, castFrame)
  castFrame.bar:SetPoint("TOPLEFT", frameName, "BOTTOMLEFT", 0, 0)

  -- Style it
  castFrame.bar:SetSize(240, 4)
  castFrame.bar:SetStatusBarTexture(VH_TEXTURES.SOLID)
  castFrame.bar:SetBackdrop({ bgFile = VH_TEXTURES.SOLID })
  castFrame.bar:SetBackdropColor(ParseColor(VH_COLORS.BG, 0.6))
  castFrame.bar:SetStatusBarColor(ParseColor(VH_COLORS.YELLOW, 1))

  castFrame.bar:SetOrientation("HORIZONTAL")
  castFrame.bar:SetMinMaxValues(0, 1)

  castFrame.text = castFrame:CreateFontString(baseFrameName .. "TEXT")
  castFrame.text:SetFont(VH_FONTS.STAATLICHES, 12)
  castFrame.text:SetJustifyH("LEFT")
  castFrame.text:SetPoint("TOPRIGHT", barName, "TOPRIGHT", -10, -6)
  castFrame.text:SetText("10.9")

  CFT = castFrame.text

  castFrame.nameText = castFrame:CreateFontString(baseFrameName .. "NAME_TEXT")
  castFrame.nameText:SetFont(VH_FONTS.STAATLICHES, 12)
  castFrame.nameText:SetJustifyH("LEFT")
  castFrame.nameText:SetPoint("TOPLEFT", barName, "TOPLEFT", 10, -6)
  castFrame.nameText:SetText("Spell Name Here")

  CNFT = castFrame.nameText
  castFrame:Hide()
  castFrame.bar:Hide()

  castFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START", "target")
  castFrame:RegisterEvent("UNIT_SPELLCAST_START", "target")
  castFrame:RegisterEvent("UNIT_SPELLCAST_DELAYED", "target")
  castFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE", "target")
  castFrame:RegisterEvent("UNIT_SPELLCAST_STOP", "target")
  castFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP", "target")
  castFrame:SetScript("OnEvent", function(self, event, target, _, spellID)
    if (target ~= "target") then return nil end

    local channelUpdate = (event == "UNIT_SPELLCAST_CHANNEL_UPDATE")
    local channelStart = (event == "UNIT_SPELLCAST_CHANNEL_START")
    local delayed = (event == "UNIT_SPELLCAST_DELAYED")

      -- Animations
    if (delayed == true or channelUpdate == true) then
      local info = (channelUpdate) and ChannelInfo or CastingInfo
      local _, _, _, startTimeMS, endTimeMS = info("target")
      local duration = (endTimeMS - startTimeMS) / 1000
      local startValue = channelUpdate and (endTimeMS / 1000) - GetTime() or GetTime() - (startTimeMS / 1000)
      local endValue = channelUpdate and 0 or duration

      AnimateGroup("CAST_BAR_VALUE", {self.bar}, 'value',
        startValue,
        endValue,
        channelUpdate and startValue or duration - startValue
      )
      AnimateGroup("CAST_BAR_TEXT_VALUE", {self.text}, 'timetext',
        channelUpdate and endValue or endValue,
        channelUpdate and endValue or startValue,
        channelUpdate and startValue or duration - startValue
      )

    elseif (event == "UNIT_SPELLCAST_START" or channelStart) then
      local info = (channelStart) and ChannelInfo or CastingInfo
      local name, _, _, startTimeMS, endTimeMS = info("target")
      local duration = (endTimeMS - startTimeMS) / 1000
      local startValue = channelStart and duration or 0
      local endValue = channelStart and 0 or duration

      self.bar:SetMinMaxValues(0, duration)
      self:Show()
      self.nameText:SetText(name)

      AnimateGroup("TARGET_CAST_BAR_ALPHA", {self.bar}, 'alpha', self.bar:GetAlpha(), 1, 0.15)
      AnimateGroup("TARGET_CAST_BAR_VALUE", {self.bar}, 'value',
        startValue,
        endValue,
        duration
      )
      AnimateGroup("TARGET_CAST_BAR_TEXT_VALUE", {self.text}, 'timetext',
        channelUpdate and startValue or endValue,
        channelUpdate and endValue or startValue,
        duration
      )
      AnimateGroup("TARGET_CAST_BAR_TEXT_ALPHA", {self.text, self.nameText}, 'alpha', self.bar:GetAlpha(), 1, 0.15)

      AnimateGroup("TARGET_CAST_BAR_TEXT_X", {self.text}, 'x', -10, -5, 0.2)
      AnimateGroup("TARGET_CAST_BAR_NAME_TEXT_X", {self.nameText}, 'x', 10, 5, 0.2)

    elseif (event == "UNIT_SPELLCAST_STOP" or "UNIT_SPELLCAST_CHANNEL_STOP") then
      AnimateGroup("TARGET_CAST_BAR_ALPHA", {self.bar}, 'alpha', self.bar:GetAlpha(), 0, 0.25)
      AnimateGroup("TARGET_CAST_BAR_TEXT_ALPHA", {self.text, self.nameText}, 'alpha', self.bar:GetAlpha(), 0, 0.25)
    end
  end)
end

Vikinghug.TargetFrame = VHTargetFrame
