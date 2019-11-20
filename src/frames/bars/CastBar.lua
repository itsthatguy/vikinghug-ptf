local CastBar = inheritsFrom(Vikinghug.BaseBar)

function CastBar:CreateEvents()
  self.bar:SetScript('OnUpdate', nil)
  self.bar:Hide()

  -- Vikinghug.RegisterCallback(self, VH_ACTIONS[self.unit].configureBars, self.ConfigureBars, self)
  Vikinghug.RegisterCallback(self, VH_ACTIONS[self.unit].updateCast, self.UpdateCast, self)

  Vikinghug.RegisterCallback(self, VH_ACTIONS[self.unit].startCast, self.StartCast, self)
  Vikinghug.RegisterCallback(self, VH_ACTIONS[self.unit].stopCast, self.StopCast, self)
end

function CastBar:StartCast(event, state)
  self.bar:SetMinMaxValues(0, state.castDuration)
  self.bar:Show()
  AnimateGroup(state.unit.."_CAST_BAR_ALPHA", {self.bar}, 'alpha', self.bar:GetAlpha(), 1, 0.25)
  AnimateGroup(state.unit.."_CAST_BAR_VALUE", {self.bar}, 'value',
    state.castStart,
    state.castEnd,
    state.castDuration
  )
end

function CastBar:StopCast(event, state)
  AnimateGroup(state.unit.."_CAST_BAR_ALPHA", {self.bar}, 'alpha', self.bar:GetAlpha(), 0, 0.25, function()
    self.bar:Hide()
  end)
end

function CastBar:UpdateCast(event, state)
  AnimateGroup(state.unit.."_CAST_BAR_VALUE", {self.bar}, 'value',
    state.castStart,
    state.castEnd,
    state.castDuration
  )
end

Vikinghug.CastBar = CastBar