local PlayerHealthText = inheritsFrom(Vikinghug.PlayerFrame.BasePlayerFrameText)

function PlayerHealthText:init()
  local playerHealthText = {
    name = "VH_PLAYER_HEALTH_TEXT",
    type = "HEALTH",
    direction = "LEFT",
  }

  self:CreateTextFrame(playerHealthText)
end

Vikinghug.PlayerFrame.PlayerHealthText = PlayerHealthText