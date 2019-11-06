function ShallowClone(ot)
  local nt = {}
  for i, v in pairs(ot) do
    nt[i] = v
  end
  return nt
end

function ParseColor(color, alpha)
  local t = {}
  for index, value in ipairs(color) do
    t[index] = value / 255
  end
  t[#t+1] = alpha and alpha or 1
  return unpack(t)
end

-- Blizzard Colors
-- red      1,    0.1,    0.1
-- orange   1,    0.5,    0.25
-- yellow   1,    1,      0
-- green    0.25, 0.25,   0.75
-- white    1,    1,      1
-- grey     0.5,  0.5,    0.5
local function ConvertBlizzardToVHColor(color)
  local vhColor = {}
  if (color.r == 1 and color.g == 0.1 and color.b == 0.1) then
    vhColor = VH_COLORS.RED

  elseif (color.r == 1 and color.g == 0.5 and color.b == 0.5) then
    vhColor = VH_COLORS.ORANGE

  elseif (color.r == 1 and color.g == 1 and color.b == 0) then
    vhColor = VH_COLORS.YELLOW

  elseif (color.r == 0.25 and color.g == 0.25 and color.b == 0.75) then
    vhColor = VH_COLORS.GREEN

  else
    return color
  end

  return { r = vhColor[1] / 255, g = vhColor[2] / 255, b = vhColor[3] / 255 }
end

function GetDifficultyColorText(num)
  local blizzardColor = GetDifficultyColor(num)
  local col = ConvertBlizzardToVHColor(blizzardColor)

  return ColorToText(col.r, col.g, col.b, 1)
end

function ColorToText( r, g, b, a )
  if not a then a = 1.0 end
  r = 255 * (r+0.0001)
  g = 255 * (g+0.0001)
  b = 255 * (b+0.0001)
  a = 255 * (a+0.0001)
  return string.format ( "|c%.2x%.2x%.2x%.2x", a, r, g, b )
end

function inheritsFrom( baseClass )
  local new_class = {}
  local class_mt = { __index = new_class }
  
  function new_class:create()
    local newinst = {}
    setmetatable( newinst, class_mt )
    return newinst
  end
  
  if nil ~= baseClass then
    setmetatable( new_class, { __index = baseClass } )
  end
  
  -- Implementation of additional OO properties starts here --
  
  -- Return the class object of the instance
  function new_class:class()
    return new_class
  end
  
  -- Return the super class object of the instance
  function new_class:superClass()
    return baseClass
  end
  
  -- Return true if the caller is an instance of theClass
  function new_class:isa( theClass )
    local b_isa = false
    
    local cur_class = new_class
    
    while ( nil ~= cur_class ) and ( false == b_isa ) do
      if cur_class == theClass then
        b_isa = true
      else
        cur_class = cur_class:superClass()
      end
    end
    
    return b_isa
  end
  
  return new_class
end