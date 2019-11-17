-- CONSTANTS
VH_FRAMES = {
  PLAYER_FRAME = "VH_PLAYER_FRAME",
  TARGET_FRAME = "VH_TARGET_FRAME"
}

VH_PLAYER = "player"
VH_TARGET = "target"

VH_COLORS = {
  RED = { 242, 51, 80 },
  ORANGE = { 242, 115, 45 },
  BLUE = { 47, 151, 247 },
  GREEN = { 115, 222, 89 },
  YELLOW = { 237, 197, 64 },
  BG = {30, 11, 38},
}

VH_POWER_COLORS = {
  MANA = VH_COLORS.BLUE,
  ENERGY = VH_COLORS.YELLOW,
  RAGE = VH_COLORS.ORANGE
}

VH_BAR_POSITIONS = {
  -- PLAYER BARS
  PLAYER_HEALTH = {
    align = "RIGHT",
    point = "TOPRIGHT",
    relativePoint = "TOP",
    relativeFrame = VH_FRAMES.PLAYER_FRAME,
    x = 40,
    y = 0,
    width = 240,
    height = 20,
    heightForm = 20
  },

  PLAYER_MANA = {
    align = "LEFT",
    point = "BOTTOMLEFT",
    relativePoint = "TOP",
    relativeFrame = VH_FRAMES.PLAYER_FRAME,
    x = 40,
    y = -20,
    width = 240,
    height = 20,
    heightForm = 5
  },

  PLAYER_ENERGY = {
    align = "LEFT",
    point = "TOPLEFT",
    relativePoint = "TOP",
    relativeFrame = VH_FRAMES.PLAYER_FRAME,
    x = 40,
    y = 0,
    width = 240,
    height = 20,
    heightForm = 15
  },

  PLAYER_RAGE = {
    align = "LEFT",
    point = "TOPLEFT",
    relativePoint = "TOP",
    relativeFrame = VH_FRAMES.PLAYER_FRAME,
    x = 40,
    y = 0,
    width = 240,
    height = 20, 
    heightForm = 15
  },

  -- TARGET BARS
  TARGET_HEALTH = {
    align = "RIGHT",
    point = "TOPRIGHT",
    relativePoint = "BOTTOM",
    relativeFrame = VH_FRAMES.TARGET_FRAME,
    x = 40,
    y = 15,
    width = 240,
    height = 15,
    heightForm = 15
  },

  TARGET_MANA = {
    align = "LEFT",
    point = "BOTTOMLEFT",
    relativePoint = "BOTTOM",
    relativeFrame = VH_FRAMES.TARGET_FRAME,
    x = 40,
    y = 0,
    width = 240,
    height = 15,
    heightForm = 3
  },

  TARGET_ENERGY = {
    align = "LEFT",
    point = "TOPLEFT",
    relativePoint = "BOTTOM",
    relativeFrame = VH_FRAMES.TARGET_FRAME,
    x = 40,
    y = 15,
    width = 240,
    height = 15,
    heightForm = 12
  },

  TARGET_RAGE = {
    align = "LEFT",
    point = "TOPLEFT",
    relativePoint = "BOTTOM",
    relativeFrame = VH_FRAMES.TARGET_FRAME,
    x = 40,
    y = 15,
    width = 240,
    height = 15,
    heightForm = 12
  }
}