local VHTargetCastFrame = {}

-- target frames
function VHTargetCastFrame:init()
  self.frame = self:CreateContainer()
  self.castBar = self:CreateBars()
  self:CreateText()
  self:CreateEvents(self.frame)

  return self.frame
end

function VHTargetCastFrame:CreateContainer()
  local castFrame = CreateFrame("Frame", VH_FRAMES.TARGET_CAST_FRAME, UIParent)
  castFrame:SetPoint(
    VH_FRAME_POSITIONS.TARGET_CAST_FRAME.point,
    VH_FRAME_POSITIONS.TARGET_CAST_FRAME.relativeFrame,
    VH_FRAME_POSITIONS.TARGET_CAST_FRAME.relativePoint,
    VH_FRAME_POSITIONS.TARGET_CAST_FRAME.x,
    VH_FRAME_POSITIONS.TARGET_CAST_FRAME.y
  )
  castFrame:SetSize(
    VH_FRAME_POSITIONS.TARGET_CAST_FRAME.width,
    VH_FRAME_POSITIONS.TARGET_CAST_FRAME.height
  )

  -- remove this start
  -- local texture = castFrame:CreateTexture(nil, "BACKGROUND")
  -- texture:SetAllPoints()
  -- texture:SetColorTexture(1,0,1,.8)
  -- remove this end

  return castFrame
end

function VHTargetCastFrame:CreateBars()
  local castBar = Vikinghug.CastBar:create()
  castBar:init(
    "target",
    VH_FRAME_POSITIONS.TARGET_CAST_FRAME.children.bar.name,
    "CAST_BAR",
    VH_COLORS.YELLOW,
    VH_FRAME_POSITIONS.TARGET_CAST_FRAME.children.bar
  )

  return castBar
end

function VHTargetCastFrame:CreateText()
  local text = VH_FRAME_POSITIONS.TARGET_CAST_FRAME.children.text
  local nameText = VH_FRAME_POSITIONS.TARGET_CAST_FRAME.children.nameText

  self.text = self.frame:CreateFontString(text.name)
  self.text:SetFont(
    VH_FONTS.STAATLICHES,
    text.textSize
  )
  self.text:SetJustifyH(text.justifyH)
  self.text:SetPoint(
    text.point,
    text.relativeFrame,
    text.relativePoint,
    text.x,
    text.y
  )
  self.text:SetText(12345)

  self.nameText = self.frame:CreateFontString(nameText.name)
  self.nameText:SetFont(
    VH_FONTS.STAATLICHES,
    nameText.textSize
  )
  self.nameText:SetJustifyH(nameText.justifyH)
  self.nameText:SetPoint(
    nameText.point,
    nameText.relativeFrame,
    nameText.relativePoint,
    nameText.x,
    nameText.y
  )
  self.nameText:SetText(12345)

  self:Hide()

  Vikinghug.RegisterCallback(self, VH_ACTIONS.target.updateCast, self.UpdateCast, self)
  Vikinghug.RegisterCallback(self, VH_ACTIONS.target.startCast, self.StartCast, self)
  Vikinghug.RegisterCallback(self, VH_ACTIONS.target.stopCast, self.StopCast, self)
  Vikinghug.RegisterCallback(self, VH_ACTIONS.target.clearTarget, self.ClearTarget, self)
end

function VHTargetCastFrame:StartCast(event, state)
  self.nameText:SetText(state.castName)
  self:Show()

  AnimateGroup("TARGET_CAST_TEXT_VALUE", {self.text}, 'timetext',
    state.castStart,
    state.castEnd,
    state.castDuration
  )
end

function VHTargetCastFrame:StopCast(event, state)
  self:Hide()
end

function VHTargetCastFrame:UpdateCast(event, state)
  AnimateGroup("TARGET_CAST_TEXT_VALUE", {self.text}, 'timetext',
    state.castStart,
    state.castEnd,
    state.castDuration
  )
end

function VHTargetCastFrame:ClearTarget(event, state)
  self:Hide()
  self.castBar:Hide()
end

function VHTargetCastFrame:Show()
  local text = VH_FRAME_POSITIONS.TARGET_CAST_FRAME.children.text
  local nameText = VH_FRAME_POSITIONS.TARGET_CAST_FRAME.children.nameText

  self.text:Show()
  self.nameText:Show()

  AnimateGroup("TARGET_CAST_BAR_TEXT_X", {self.text}, 'x', text.x - 10, text.x, 0.15)
  AnimateGroup("TARGET_CAST_BAR_NAME_TEXT_X", {self.nameText}, 'x', nameText.x + 10, nameText.x, 0.15)
  AnimateGroup("TARGET_CAST_TEXT_ALPHA", {self.text}, 'alpha', self.text:GetAlpha(), 1, 0.25)
  AnimateGroup("TARGET_CAST_NAME_TEXT_ALPHA", {self.nameText}, 'alpha', self.nameText:GetAlpha(), 1, 0.25)
end

function VHTargetCastFrame:Hide()
  AnimateGroup("TARGET_CAST_NAME_TEXT_ALPHA", {self.nameText}, 'alpha', self.nameText:GetAlpha(), 0, 0.25)
  AnimateGroup("TARGET_CAST_FRAME_ALPHA", {self.text}, 'alpha', self.frame:GetAlpha(), 0, 0.25, function()
    self.text:Hide()
    self.nameText:Hide()
  end)
end

local function HandleEvents(self, event, target, ...)
  if (target ~= "target") then return end

  local channelUpdate = (event == "UNIT_SPELLCAST_CHANNEL_UPDATE")
  local channelStart = (event == "UNIT_SPELLCAST_CHANNEL_START")
  local delayed = (event == "UNIT_SPELLCAST_DELAYED")

  if (delayed == true or channelUpdate) then
    local castType = (channelUpdate) and "CHANNELING" or "CASTING"
    Reducer(VH_TARGET, { type = 'SET_CAST_FROM_INTERRUPT', value = { castType = castType }  })

  elseif (event == "UNIT_SPELLCAST_START" or channelStart) then
    local castType = (channelStart) and "CHANNELING" or "CASTING"
    Reducer(VH_TARGET, { type = 'START_CAST', value = { castType = castType }  })

  elseif (event == "UNIT_SPELLCAST_STOP" or "UNIT_SPELLCAST_CHANNEL_STOP") then
    Reducer(VH_TARGET, { type = 'STOP_CAST' })
  end
end

function VHTargetCastFrame:CreateEvents(frame)
  frame:SetScript("OnEvent", HandleEvents)
  frame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START", "target")
  frame:RegisterEvent("UNIT_SPELLCAST_START", "target")
  frame:RegisterEvent("UNIT_SPELLCAST_DELAYED", "target")
  frame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE", "target")
  frame:RegisterEvent("UNIT_SPELLCAST_STOP", "target")
  frame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP", "target")
end

Vikinghug.TargetCastFrame = VHTargetCastFrame