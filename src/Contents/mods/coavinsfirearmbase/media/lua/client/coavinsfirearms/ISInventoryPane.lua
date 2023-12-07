local FIREARMS = require('coavinsfirearms/FirearmsHelper')

local realFn = ISInventoryPane.drawItemDetails

function ISInventoryPane:drawItemDetails(item, y, xoff, yoff, red)
	if item and FIREARMS.itemIsPart(item) then
		local hdrHgt = self.headerHgt
		local top = hdrHgt + y * self.itemHgt + yoff
		local fgBar = {r=0.0, g=0.6, b=0.0, a=0.7}
		local fgText = {r=0.6, g=0.8, b=0.5, a=0.6}
		if red then fgText = {r=0.0, g=0.0, b=0.5, a=0.7} end
		local text = getText("IGUI_invpanel_Condition") .. ":"
		self:drawTextAndProgressBar(text, item:getCondition() / item:getConditionMax(), xoff, top, fgText, fgBar)
	else
		realFn(self, item, y, xoff, yoff, red)
	end
end
