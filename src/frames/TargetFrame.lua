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
  self.targetCastFrame = Vikinghug.TargetCastFrame:init()
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

Vikinghug.TargetFrame = VHTargetFrame
