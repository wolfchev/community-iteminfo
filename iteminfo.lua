dofile("System/iteminfo2.lub") 
dofile("System/customeffects.lua") -- for people using custom effects
dofile("System/community_iteminfo.lua")

universalUnidentifiedDescription = {
    "Unidentified item.",
    "Can be identified by using a [Magnifier]"
}

markupToken = {
    ["<lb>"] = {text = "\n^FFFFFF-^000000"},
    ["<bla>"] = {text = "^000000"},
    ["<g>"] = {text = "^1a9401"},
    ["<blu>"] = {text = "^0404d1"},
    ["<r>"] = {text = "^FF0000"},
    ["<sk>"] = {text = "^0437d1"},
    ["<pr>"] = {text = "^800080"},
    ["<tl>"] = {text = "^005270"},
    ["<eq>"] = {text = "^777777"},
    ["<gr>"] = {text = "^d3d3d3"},
    ["</sk>"] = {text = "^000000"},
    ["</>"] = {text = "^000000"},
    ["VCT"] = {text = "Variable Cast Time"},
    ["FCT"] = {text = "Fixed Cast Time"},
    ["ACD"] = {text = "After Cast Delay"},
    ["LRD"] = {text = "Ranged Damage"},
}

main = function() 
    for ItemID, DESC in pairs(tbl) do
        local unidentifiedDisplayName = "";
        
        if DESC.slotCount ~= nil and DESC.slotCount > 0 then
            unidentifiedDisplayName = DESC.identifiedDisplayName .. " [" .. DESC.slotCount .. "]";
        else
            unidentifiedDisplayName = DESC.identifiedDisplayName;
        end
        
        result, msg = AddItem(ItemID, unidentifiedDisplayName, DESC.identifiedResourceName, DESC.identifiedDisplayName, DESC.identifiedResourceName, DESC.slotCount, DESC.ClassNum)
        if not result == true then
            return false, msg
        end
        
        if community_iteminfo[ItemID] == nil then
            for k, v in pairs(DESC.identifiedDescriptionName) do
                result, msg = AddItemIdentifiedDesc(ItemID, v)
                if not result == true then
                    return false, msg
                end
            end
        end

        -- universal unidentified item description
        for k, v in pairs(universalUnidentifiedDescription) do
            result, msg = AddItemUnidentifiedDesc(ItemID, v)
            if not result == true then
                return false, msg
            end
        end

        if nil ~= DESC.EffectID then
			result, msg = AddItemEffectInfo(ItemID, DESC.EffectID)
			if not result == true then
				return false, msg
			end
		end
        k = DESC.identifiedResourceName
        v = DESC.identifiedDisplayName
    end
    
    -- add user defined effects
    for ItemID, DESC in pairs(customeffects) do
        result, msg = AddItemEffectInfo(ItemID, DESC.EffectID)
        if not result == true then
            return false, msg
        end
    end

    -- add community item info
    for ItemID, DESC in pairs(community_iteminfo) do
        result, msg = AddItemIdentifiedDesc(ItemID, "^FF0000[Community Description]^000000")
        if not result == true then
            return false, msg
        end
        for k, v in pairs(DESC.identifiedDescriptionName) do

            local desc = v
            for k2, v2 in pairs(markupToken) do
                desc = desc:gsub(k2,v2.text)
            end

            result, msg = AddItemIdentifiedDesc(ItemID, desc)
            if not result == true then
                return false, msg
            end
        end
    end

    return true, "good"
end