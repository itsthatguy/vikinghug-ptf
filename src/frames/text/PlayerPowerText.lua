local PlayerPowerText = inheritsFrom(Vikinghug.PlayerFrame.BasePlayerFrameText)

function PlayerPowerText:init()
  local playerPowerText = {
    name = "VH_PLAYER_POWER_TEXT",
    type = "POWER",
    direction = "RIGHT",
  }

  self:CreateTextFrame(playerPowerText)
end

Vikinghug.PlayerFrame.PlayerPowerText = PlayerPowerText