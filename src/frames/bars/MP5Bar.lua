local MP5Bar = inheritsFrom(Vikinghug.BaseBar)

function MP5Bar:CreateEvents()
  self.bar:SetScript('OnUpdate', nil)
  self.bar:Hide()

  Vikinghug.RegisterCallback(self, VH_ACTIONS[self.unit].stopCast, self.StartMP5, self)
end

function MP5Bar:Show()
  self.bar:Show()
  AnimateGroup(self.unit.."_MP5_BAR_ALPHA", {self.bar}, 'alpha', self.bar:GetAlpha(), 1, 0.25)
end

function MP5Bar:Hide()
  AnimateGroup(self.unit.."_MP5_BAR_ALPHA", {self.bar}, 'alpha', self.bar:GetAlpha(), 0, 0.25, function()
    self.bar:Hide()
  end)
end

function MP5Bar:StartMP5(event, state)
  self.bar:SetMinMaxValues(0, 5)
  self:Show()
  AnimateGroup(self.unit.."_MP5_BAR_VALUE", {self.bar}, 'value', 5, 0, 5, function()
    self:Hide()
  end)
end

Vikinghug.MP5Bar = MP5Bar