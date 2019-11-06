VHBasePlayerFrameText = {}
VHBasePlayerFrameText_mt = { __index = VHBasePlayerFrameText }

function VHBasePlayerFrameText:create()
  local newInstance = {}
  setmetatable(newInstance, VHBasePlayerFrameText_mt)
  return newInstance
end

-- options: name, type, direction
function VHBasePlayerFrameText:CreateTextFrame(options)
  -- TEXT FRAME
  local frameName = options.name .. "_FRAME"
  local textFrame = CreateFrame("Frame", frameName, UIParent)
  local direction = options.direction
  local reverseDirection = (direction == "LEFT") and "RIGHT" or "LEFT"
  local dirMod = (direction == "RIGHT") and 1 or -1

  textFrame:SetSize(240, 20)
  textFrame:SetPoint("TOP" .. reverseDirection, "VH_PLAYER_FRAME", "TOP", dirMod * 40, 0)

  --
  -- TEXT MAX
  textFrame.textMax = textFrame:CreateFontString(frameName .. "_MAX")
  textFrame.textMax:SetFont(VH_FONTS.FORCED_SQUARE, 38.1)
  textFrame.textMax:SetJustifyH(reverseDirection)
  textFrame.textMax:SetText("0000")
  textFrame.textMax:SetPoint("BOTTOM" .. reverseDirection, frameName, "BOTTOM" .. direction, dirMod * 10, -8)

  -- local frameTexture = textFrame:CreateTexture(nil, "BACKGROUND")
  -- frameTexture:SetAllPoints()
  -- frameTexture:SetColorTexture(1,0,1,.5)
  
  --
  -- TEXT DIVIDER
  textFrame.textDivider = CreateFrame("Frame", frameName .."_DIVIDER", UIParent)
  textFrame.textDivider:SetSize(3, 20)
  textFrame.textDivider:SetPoint("BOTTOM" .. reverseDirection, frameName .. "_MAX", "BOTTOM" .. direction, dirMod * 10, 8)

  local texture = textFrame.textDivider:CreateTexture(nil, "BACKGROUND")
  texture:SetAllPoints()
  texture:SetColorTexture(ParseColor(VH_COLORS.YELLOW, 1))

  --
  -- TEXT CURRENT
  textFrame.textCurrent = textFrame:CreateFontString(frameName .. "_CURRENT")
  textFrame.textCurrent:SetFont(VH_FONTS.FORCED_SQUARE, 55)
  textFrame.textCurrent:SetJustifyH(reverseDirection)
  textFrame.textCurrent:SetText("0")
  textFrame.textCurrent:SetPoint("BOTTOM" .. reverseDirection, frameName .. "_DIVIDER", "BOTTOM" .. direction, dirMod * 10, -11)

  self.textFrame = textFrame
  self.type = options.type

  local actionName = "update" .. self.type:lower():gsub("^%l", string.upper)

  Vikinghug.RegisterCallback(self, VH_ACTIONS["player"][actionName], self.UpdateText, self)
end

function VHBasePlayerFrameText:UpdateText(event, state)
  local powerName = self.type:lower()
  self.textFrame.textCurrent:SetText("|cffffffff" .. tostring(state[powerName]))
  self.textFrame.textMax:SetText("|cffffffff" .. tostring(state[powerName .. "Max"]))
end

Vikinghug.PlayerFrame.BasePlayerFrameText = VHBasePlayerFrameText