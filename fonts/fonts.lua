local LSM = LibStub("LibSharedMedia-3.0") 

if not LSM then return end -- Oh No Mr. Nil!

local folder = [[Vikinghug\fonts\]]

VH_FONTS = {
  -- Interface\Addons\Vikinghug\fonts\FORCED_SQUARE.ttf
  FORCED_SQUARE = [[Interface\Addons\]] .. folder .. [[FORCED_SQUARE.ttf]],
  GEO_REGULAR = [[Interface\Addons\]] .. folder .. [[Geo-Regular.ttf]],
  JOCKEY_ONE = [[Interface\Addons\]] .. folder .. [[JockeyOne-Regular.ttf]],
  JOLLY_LODGER = [[Interface\Addons\]] .. folder .. [[JollyLodger-Regular.ttf]],
  SECULAR_ONE = [[Interface\Addons\]] .. folder .. [[SecularOne-Regular.ttf]],
  SOURCE_CODE_PRO = [[Interface\Addons\]] .. folder .. [[SourceCodePro-Medium.ttf]],
  SQUADA_ONE = [[Interface\Addons\]] .. folder .. [[SquadaOne-Regular.ttf]],
  STAATLICHES = [[Interface\Addons\]] .. folder .. [[Staatliches-Regular.ttf]], 
}


LSM:Register("font", "FORCED SQUARE", VH_FONTS.FORCED_SQUARE)
LSM:Register("font", "Geo Regular", VH_FONTS.GEO_REGULAR)
LSM:Register("font", "Jockey One", VH_FONTS.JOCKEY_ONE)
LSM:Register("font", "Jolly Lodger", VH_FONTS.JOLLY_LODGER)
LSM:Register("font", "Secular One", VH_FONTS.SECULAR_ONE)
LSM:Register("font", "Source Code Pro", VH_FONTS.SOURCE_CODE_PRO)
LSM:Register("font", "Squada One", VH_FONTS.SQUADA_ONE)
LSM:Register("font", "Staatliches", VH_FONTS.STAATLICHES)
