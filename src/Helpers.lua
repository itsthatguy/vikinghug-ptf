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

--
--
-- CUSTOM ANIMATION LIBRARY
-- TODO:
--   - Move to a proper library
--   - Animation groups should be able to animate multiple properties
--
-- EXAMPLE:  
--   AnimateGroup("CAST_BAR_ALPHA", {
--     { frame = self.bar, type = 'alpha', startValue = 0, endValue = 1, duration = 0.5, delay = 0 },
--     { frame = self.text, type = 'alpha', startValue = 0, endValue = 1, duration = 0.5, delay = 0 },
--     { frame = self.text, type = 'text', startValue = 0, endValue = 1, duration = 0.5, delay = 0 },
--   }, 'alpha', self.bar:GetAlpha(), 0, 0.5)

VH_ANIM_PROPS = {
  alpha = "alpha",
  height = "height",
  width = "width",
  x = "x",
  y = "y",
  color = "color",
}

VH_ANIM_PROP_FNS = {
  scale = {
    get = function(frame)
      return frame:GetScale()
    end,
    set = function(frame, value)
      return frame:SetScale(value)
    end,
  },
  -- TODO: 'timetext' should be 'value' and resolved by the anim function
  timetext = {
    get = function(frame)
      return frame:GetText()
    end,
    set = function(frame, value)
      return frame:SetFormattedText("%.1f", value)
    end,
  },
  value = {
    get = function(frame)
      return frame:GetValue()
    end,
    set = function(frame, value)
      return frame:SetValue(value)
    end,
  },
  alpha = {
    get = function(frame)
      return frame:GetAlpha()
    end,
    set = function(frame, value)
      return frame:SetAlpha(value)
    end,
  },
  height = {
    get = function(frame)
      return frame:GetHeight()
    end,
    set = function(frame, value)
      return frame:SetHeight(value)
    end,
  },
  width = {
    get = function(frame)
      return frame:GetWidth()
    end,
    set = function(frame, value)
      return frame:SetWidth(value)
    end,
  },
  x = {
    get = function(frame)
      local point, relativeTo, relativePoint, xofs, yofs = frame:GetPoint()
      return xofs
    end,
    set = function(frame, value)
      local point, relativeTo, relativePoint, xofs, yofs = frame:GetPoint()
      return frame:SetPoint(point, relativeTo, relativePoint, value, yofs)
    end,
  },
  y = {
    get = function(frame)
      local point, relativeTo, relativePoint, xofs, yofs = frame:GetPoint()
      return yofs
    end,

    set = function(frame, value)
      local point, relativeTo, relativePoint, xofs, yofs = frame:GetPoint()
      return frame:SetPoint(point, relativeTo, relativePoint, xofs, value)
    end,
  },
  color = {
    get = function(frame)
      local frameType = frame:GetObjectType()
      if (frameType == "StatusBar") then
        local texture = frame:GetStatusBarTexture()
        local r,g,b,a = texture:GetVertexColor()
        return r,g,b,a

      elseif (frameType == "FontString") then
        local r,g,b,a = frame:GetTextColor()
        return r,g,b,a

      elseif (frameType == "Texture") then
        local r,g,b,a = frame:GetVertexColor()
        return r,g,b,a
      end
    end,

    set = function(frame, r, g, b, a)
      local frameType = frame:GetObjectType()

      if (frameType == "StatusBar") then
        local texture = frame:GetStatusBarTexture()
        return texture:SetVertexColor(r, g, b, a)

      elseif (frameType == "FontString") then
        return frame:SetTextColor(r, g, b, a)

      elseif (frameType == "Texture") then
        return frame:SetVertexColor(r, g, b, a)
      end
    end
  },
}

local function SetChildren(children, value, fn)
  for i,child in pairs(children) do
    if child:IsShown() ~= true then child:Show() end
    fn(child, value)
  end
end

local AnimationGroups = {}

function AnimateGroup(name, children, property, startValue, endValue, duration, callback)
  if AnimationGroups[name] and AnimationGroups[name].used then
    AnimationGroups[name]:Hide()
    AnimationGroups[name].used = nil
    AnimationGroups[name] = nil
  end
  
  AnimationGroups[name] = CreateFrame("Frame", "VH:ANIM_FRAME_" .. name, UIParent)
  AnimationGroups[name].used = true

  -- local getFn = VH_ANIM_PROP_FNS[property].get
  local setFn = VH_ANIM_PROP_FNS[property].set

  SetChildren(children, startValue, setFn)

  local elapsed = 0
  local accumulator = 0
  local delta = endValue - startValue
  local speedLimit = 0.025

  AnimationGroups[name]:SetScript('OnUpdate', function(self, sinceLastUpdate)
    elapsed = elapsed + sinceLastUpdate
    accumulator = accumulator + sinceLastUpdate
    if accumulator < speedLimit then
      return true
    else
      accumulator = 0
    end

    if elapsed > duration then
      SetChildren(children, endValue, setFn)
      if callback then callback() end
      
      -- clear the frame from the pool
      self:Hide()
      self.used = false
      self = nil
      return true
    end
    local progress = min(elapsed / duration, 1)
    local latest = startValue + progress * delta

    SetChildren(children, latest, setFn)
  end)
end