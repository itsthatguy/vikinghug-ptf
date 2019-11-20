-- CONSTANTS
VH_FRAMES = {
  PLAYER_FRAME = "VH_PLAYER_FRAME",
  PLAYER_CAST_FRAME = "VH_PLAYER_CAST_FRAME",
  PLAYER_MP5_FRAME = "VH_PLAYER_MP5_FRAME",

  TARGET_FRAME = "VH_TARGET_FRAME",
  TARGET_CAST_FRAME = "VH_TARGET_CAST_FRAME",
  TARGET_HEALTH_FRAME = "VH_TARGET_HEALTH",
  TARGET_MANA_FRAME = "VH_TARGET_MANA",
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
    reverseFill = true,
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
    reverseFill = false,
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
    reverseFill = false,
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
    reverseFill = false,
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
    reverseFill = true,
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
    reverseFill = false,
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
    reverseFill = false,
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
    reverseFill = false,
    point = "TOPLEFT",
    relativePoint = "BOTTOM",
    relativeFrame = VH_FRAMES.TARGET_FRAME,
    x = 40,
    y = 15,
    width = 240,
    height = 15,
    heightForm = 12
  },
}

-- NOTE: VH_BAR_POSITIONS will be migrated to this data structure
VH_FRAME_POSITIONS = {
  PLAYER_CAST_FRAME = {
    reverseFill = false,
    name = VH_FRAMES.PLAYER_CAST_FRAME,
    point = "TOP",
    relativePoint = "TOP",
    relativeFrame = VH_FRAMES.PLAYER_FRAME,
    x = 0,
    y = 0,
    width = 72,
    height = 60,

    children = {
      bar = {
        name = "VH_PLAYER_CAST_BAR",
        reverseFill = false,
        point = "TOPRIGHT",
        orientation = "VERTICAL",
        relativePoint = "TOP",
        relativeFrame = VH_FRAMES.PLAYER_CAST_FRAME,
        x = -18,
        y = 0,
        width = 10,
        height = 60
      },
      text = {
        name = "VH_PLAYER_CAST_TEXT",
        point = "TOP",
        relativePoint = "BOTTOM",
        relativeFrame = VH_FRAMES.PLAYER_CAST_FRAME,
        x = 0,
        y = -4,
        textSize = 20,
        justifyH = "CENTER",
      },
      nameText = {
        name = "VH_PLAYER_CAST_NAME_TEXT",
        reverseFill = false,
        point = "TOP",
        relativePoint = "BOTTOM",
        relativeFrame = VH_FRAMES.PLAYER_CAST_FRAME,
        x = 0,
        y = -40,
        textSize = 32,
        justifyH = "CENTER",
      },
    }
  },

  TARGET_HEALTH = {
    name = "VH_TARGET_HEALTH",
    reverseFill = true,
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
    name = "VH_TARGET_MANA",
    reverseFill = false,
    point = "BOTTOMLEFT",
    relativePoint = "BOTTOM",
    relativeFrame = VH_FRAMES.TARGET_FRAME,
    x = 40,
    y = 0,
    width = 240,
    height = 15,
    heightForm = 3
  },

  TARGET_CAST_FRAME = {
    name = VH_FRAMES.TARGET_CAST_FRAME,
    point = "TOPLEFT",
    relativePoint = "TOPLEFT",
    relativeFrame = VH_FRAMES.TARGET_MANA_FRAME,
    x = 0,
    y = 0,
    width = 240,
    height = 4,

    children = {
      bar = {
        name = "VH_TARGET_CAST_BAR",
        reverseFill = false,
        point = "BOTTOMLEFT",
        relativePoint = "TOPLEFT",
        relativeFrame = VH_FRAMES.TARGET_CAST_FRAME,
        x = 0,
        y = 0,
        width = 240,
        height = 4
      },
      text = {
        name = "VH_TARGET_CAST_TEXT",
        point = "TOPRIGHT",
        relativePoint = "TOPRIGHT",
        relativeFrame = VH_FRAMES.TARGET_CAST_FRAME,
        x = -5,
        y = -2,
        textSize = 12,
        justifyH = "RIGHT",
      },
      nameText = {
        name = "VH_TARGET_CAST_NAME_TEXT",
        reverseFill = false,
        point = "TOPLEFT",
        relativePoint = "TOPLEFT",
        relativeFrame = VH_FRAMES.TARGET_CAST_FRAME,
        x = 5,
        y = -2,
        textSize = 12,
        justifyH = "LEFT",
      },
    }
  },

  PLAYER_MP5_FRAME = {
    reverseFill = false,
    name = VH_FRAMES.PLAYER_MP5_FRAME,
    point = "TOPLEFT",
    orientation = "VERTICAL",
    relativePoint = "TOP",
    relativeFrame = VH_FRAMES.PLAYER_CAST_FRAME,
    x = 18,
    y = 0,
    width = 10,
    height = 60,
  }
}