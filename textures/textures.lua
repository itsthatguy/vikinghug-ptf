local LSM = LibStub("LibSharedMedia-3.0") 

if not LSM then return end -- Oh No Mr. Nil!

local folder = [[Vikinghug\textures\]]

VH_TEXTURES = {
  -- Interface\Addons\Vikinghug\textures\
  DRUID_ICON = [[Interface\Addons\]] .. folder .. [[druid.tga]],
  HUNTER_ICON = [[Interface\Addons\]] .. folder .. [[hunter.tga]],
  MAGE_ICON = [[Interface\Addons\]] .. folder .. [[mage.tga]],
  PALADIN_ICON = [[Interface\Addons\]] .. folder .. [[paladin.tga]],
  PRIEST_ICON = [[Interface\Addons\]] .. folder .. [[priest.tga]],
  ROGUE_ICON = [[Interface\Addons\]] .. folder .. [[rogue.tga]],
  SHAMAN_ICON = [[Interface\Addons\]] .. folder .. [[shaman.tga]],
  WARLOCK_ICON = [[Interface\Addons\]] .. folder .. [[warlock.tga]],
  WARRIOR_ICON = [[Interface\Addons\]] .. folder .. [[warrior.tga]],

  SOLID = [[Interface\Addons\]] .. folder .. [[solid.tga]]
}

-- From SharedMedia
LSM:Register("background", "Druid Icon", VH_TEXTURES.DRUID_ICON)
LSM:Register("background", "Hunter Icon", VH_TEXTURES.HUNTER_ICON)
LSM:Register("background", "Mage Icon", VH_TEXTURES.MAGE_ICON)
LSM:Register("background", "Paladin Icon", VH_TEXTURES.PALADIN_ICON)
LSM:Register("background", "Priest Icon", VH_TEXTURES.PRIEST_ICON)
LSM:Register("background", "Rogue Icon", VH_TEXTURES.ROGUE_ICON)
LSM:Register("background", "Shaman Icon", VH_TEXTURES.SHAMAN_ICON)
LSM:Register("background", "Warlock Icon", VH_TEXTURES.WARLOCK_ICON)
LSM:Register("background", "Warrior Icon", VH_TEXTURES.WARRIOR_ICON)