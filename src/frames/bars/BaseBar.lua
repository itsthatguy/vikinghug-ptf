BaseBar = {}
BaseBar_mt = { __index = BaseBar }

-- setmetatable(BaseBar, {
--   __call = function(cls, ...)
--     return cls.create(...)
--   end,
-- })

function BaseBar:create()
  local newInstance = {}
  setmetatable(newInstance, BaseBar_mt)
  return newInstance
end

function BaseBar:init(unit, name, type, color, positions)
  self.bar = CreateFrame('StatusBar', name, UIParent)
  self.unit = unit
  self.name = name
  self.type = type
  self.value = 0
  self.height = positions.height
  self.opacity = 100

  self.widthMax = positions.width
  self.heightMax = positions.height
  self.heightForm = positions.heightForm
  -- bar:SetMovable(true)
  -- bar:EnableMouse(true)
  -- bar:RegisterForDrag("LeftButton", "RightButton")
  -- bar:SetScript("OnDragStart", bar.StartMoving)
  -- bar:SetScript("OnDragStop", bar.StopMovingOrSizing)

  if positions.reverseFill then self.bar:SetReverseFill(true) end

  -- TODO: THIS IS WHACK, AND NEEDS TO BE REMOVED
  local x = (positions.reverseFill and (-1 * positions.x) or positions.x)

  self:SetHeight(0)
  self.bar:SetPoint(positions.point, positions.relativeFrame, positions.relativePoint, x, positions.y)
  self:SetHeight(positions.height)

  -- Style it
  self.bar:SetSize(positions.width, positions.height)
  self.bar:SetBackdrop({ bgFile = VH_TEXTURES.SOLID })
  self.bar:SetStatusBarTexture(VH_TEXTURES.SOLID, 'ARTWORK') -- Background image
  self.bar:SetOrientation(positions.orientation or 'HORIZONTAL')
  self.bar:SetBackdropColor(ParseColor(VH_COLORS.BG, 0.6))

  local fill = self.bar:GetStatusBarTexture()
  fill:SetVertexColor(ParseColor(color))

  self.bar:SetScript('OnUpdate', function()
    local limit = 30 / GetFramerate()
    self:AnimateValue(limit)
    self:AnimateHeight(limit)
    self:AnimateAlpha(limit)
  end)

  self:CreateEvents()
end


function BaseBar:SetMinMaxValues(minValue, maxValue)
  self.bar:SetMinMaxValues(minValue, maxValue)
end

function BaseBar:SetHeight(value)
  self.height = value
end

function BaseBar:SetValue(value)
  self.value = value
end

function BaseBar:SetOpacity(value)
  self.opacity = value
end

function BaseBar:AnimateValue(limit)
  local cur = self.bar:GetValue()
  if (cur == self.value) then
    return
  end

  local speed = 9
  local new = cur + min((self.value-cur)/speed, max(self.value-cur, limit))
  if new ~= new then
    -- Mad hax to prevent QNAN.
    new = self.value
  end

  self.bar:SetValue(new)
  if cur == self.value or abs(new - self.value) < 2 then
    return self.bar:SetValue(self.value)
  end
end

function BaseBar:AnimateHeight(limit)
  local cur = self.bar:GetHeight()
  if (cur == self.height) then
    return
  end

  local speed = 9
  local new = cur + min((self.height-cur)/speed, max(self.height-cur, limit))
  if new ~= new then
    -- Mad hax to prevent QNAN.
    new = self.height
  end

  self.bar:SetHeight(new)
  if cur == self.height or abs(new - self.height) < 2 then
    self.bar:SetHeight(self.height)
  end
end

function BaseBar:AnimateAlpha(limit)
  local cur = self.bar:GetAlpha() * 100
  if (cur == self.alpha) then
    return
  end
  local speed = 9
  local new = cur + min((self.opacity-cur)/speed, max(self.opacity-cur, limit))
  if new ~= new then
    -- Mad hax to prevent QNAN.
    new = self.opacity
  end

  self.bar:SetAlpha(new / 100)
  if cur == self.opacity or (new - self.opacity) < 2 then
    self.bar:SetAlpha(self.opacity / 100)
  end
end

function BaseBar:CreateEvents()
  error("This method is required.")
end

Vikinghug.BaseBar = BaseBar
