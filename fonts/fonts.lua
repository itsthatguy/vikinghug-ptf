local LSM = LibStub("LibSharedMedia-3.0") 

if not LSM then return end -- Oh No Mr. Nil!

local folder = [[Vikinghug\fonts\]]

VH_FONTS = {
  -- Interface\Addons\Vikinghug\fonts\FORCED_SQUARE.ttf
  FORCED_SQUARE = [[Interface\Addons\]] .. folder .. [[FORCED_SQUARE.ttf]],
}

-- From SharedMedia
LSM:Register("font", "FORCED SQUARE", VH_FONTS.FORCED_SQUARE)