local VHPlayerCastFrame = {}

-- target frames
function VHPlayerCastFrame:init()
  self.frame = self:CreateContainer()
  self:CreateBars()
  self:CreateText()
  self:CreateEvents(self.frame)
end

function VHPlayerCastFrame:CreateContainer()
  local castFrame = CreateFrame("Frame", VH_FRAME_POSITIONS.PLAYER_CAST_FRAME.name, UIParent)
  castFrame:SetPoint("TOP", VH_FRAME_POSITIONS.PLAYER_CAST_FRAME.relativeFrame, "TOP", VH_FRAME_POSITIONS.PLAYER_CAST_FRAME.x, VH_FRAME_POSITIONS.PLAYER_CAST_FRAME.y)
  castFrame:SetSize(VH_FRAME_POSITIONS.PLAYER_CAST_FRAME.width, VH_FRAME_POSITIONS.PLAYER_CAST_FRAME.height)

    -- remove this start
  -- local texture = castFrame:CreateTexture(nil, "BACKGROUND")
  -- texture:SetAllPoints()
  -- texture:SetColorTexture(1,1,1,.8)
  -- remove this end

  return castFrame
end

function VHPlayerCastFrame:CreateBars()
  self.playerCastBar = Vikinghug.CastBar:create()
  self.playerCastBar:init(
    "player",
    VH_FRAME_POSITIONS.PLAYER_CAST_FRAME.children.bar.name,
    "CAST_BAR",
    VH_COLORS.YELLOW,
    VH_FRAME_POSITIONS.PLAYER_CAST_FRAME.children.bar
  )

  self.mp5Bar = Vikinghug.MP5Bar:create()
  self.mp5Bar:init(
    "player",
    "VH_PLAYER_MP5_BAR",
    "MP5_BAR",
    VH_COLORS.YELLOW,
    VH_FRAME_POSITIONS.PLAYER_MP5_FRAME
  )
end

function VHPlayerCastFrame:CreateText()
  local text = VH_FRAME_POSITIONS.PLAYER_CAST_FRAME.children.text
  local nameText = VH_FRAME_POSITIONS.PLAYER_CAST_FRAME.children.nameText

  self.text = self.frame:CreateFontString("VH_PLAYER_CAST_TEXT")
  self.text:SetFont(VH_FONTS.STAATLICHES, text.textSize)
  self.text:SetJustifyH("CENTER")
  self.text:SetPoint(text.point, text.relativeFrame, text.relativePoint, text.x, text.y)
  self.text:SetText(12345)

  self.nameText = self.frame:CreateFontString("VH_PLAYER_CAST_NAME_TEXT")
  self.nameText:SetFont(VH_FONTS.STAATLICHES, nameText.textSize)
  self.nameText:SetJustifyH("CENTER")
  self.nameText:SetPoint(nameText.point, nameText.relativeFrame, nameText.relativePoint, nameText.x, nameText.y)
  self.nameText:SetText(12345)

  self:Hide()

  Vikinghug.RegisterCallback(self, VH_ACTIONS.player.updateCast, self.UpdateCast, self)
  Vikinghug.RegisterCallback(self, VH_ACTIONS.player.startCast, self.StartCast, self)
  Vikinghug.RegisterCallback(self, VH_ACTIONS.player.stopCast, self.StopCast, self)
end

function VHPlayerCastFrame:StartCast(event, state)
  self.nameText:SetText(state.castName)
  self:Show()

  AnimateGroup("PLAYER_CAST_TEXT_VALUE", {self.text}, 'timetext',
    state.castStart,
    state.castEnd,
    state.castDuration
  )
end

function VHPlayerCastFrame:StopCast(event, state)
  self:Hide()
end

function VHPlayerCastFrame:UpdateCast(event, state)
  AnimateGroup("PLAYER_CAST_TEXT_VALUE", {self.text}, 'timetext',
    state.castStart,
    state.castEnd,
    state.castDuration
  )
end

function VHPlayerCastFrame:Show()
  local text = VH_FRAME_POSITIONS.PLAYER_CAST_FRAME.children.text
  local nameText = VH_FRAME_POSITIONS.PLAYER_CAST_FRAME.children.nameText

  self.text:Show()
  self.nameText:Show()

  AnimateGroup("PLAYER_CAST_BAR_TEXT_Y", {self.text}, 'y', text.y - 5, text.y, 0.15)
  AnimateGroup("PLAYER_CAST_BAR_NAME_TEXT_Y", {self.nameText}, 'y', nameText.y + 5, nameText.y, 0.15)
  AnimateGroup("PLAYER_CAST_TEXT_ALPHA", {self.text}, 'alpha', self.text:GetAlpha(), 1, 0.25)
  AnimateGroup("PLAYER_CAST_NAME_TEXT_ALPHA", {self.nameText}, 'alpha', self.nameText:GetAlpha(), 1, 0.25)
end

function VHPlayerCastFrame:Hide()
  AnimateGroup("PLAYER_CAST_NAME_TEXT_ALPHA", {self.nameText}, 'alpha', self.nameText:GetAlpha(), 0, 0.25)
  AnimateGroup("PLAYER_CAST_FRAME_ALPHA", {self.text}, 'alpha', self.frame:GetAlpha(), 0, 0.25, function()
    self.text:Hide()
    self.nameText:Hide()
  end)
end

local function HandleEvents(self, event, target)
  local channelUpdate = (event == "UNIT_SPELLCAST_CHANNEL_UPDATE")
  if (target ~= "player") then return end
  local channelStart = (event == "UNIT_SPELLCAST_CHANNEL_START")
  local delayed = (event == "UNIT_SPELLCAST_DELAYED")
  if (delayed == true or channelUpdate) then
    local castType = (channelUpdate) and "CHANNELING" or "CASTING"
    Reducer(VH_PLAYER, { type = 'SET_CAST_FROM_INTERRUPT', value = { castType = castType }  })

  elseif (event == "UNIT_SPELLCAST_START" or channelStart) then
    local castType = (channelStart) and "CHANNELING" or "CASTING"
    Reducer(VH_PLAYER, { type = 'START_CAST', value = { castType = castType }  })

  elseif (event == "UNIT_SPELLCAST_STOP" or "UNIT_SPELLCAST_CHANNEL_STOP") then
    Reducer(VH_PLAYER, { type = 'STOP_CAST' })
  end
end

function VHPlayerCastFrame:CreateEvents(frame)
  frame:SetScript("OnEvent", HandleEvents)
  frame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START", "player")
  frame:RegisterEvent("UNIT_SPELLCAST_START", "player")
  frame:RegisterEvent("UNIT_SPELLCAST_DELAYED", "player")
  frame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE", "player")
  frame:RegisterEvent("UNIT_SPELLCAST_STOP", "player")
  frame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP", "player")
end

Vikinghug.PlayerCastFrame = VHPlayerCastFrame