dofile("System/iteminfo2.lub") 
dofile("System/customeffects.lua") -- for people using custom effects
dofile("System/community_iteminfo.lua")

universalUnidentifiedDescription = {
    "Unidentified item.",
    "Can be identified by using a [Magnifier]"
}

markupToken = {
    -- they didn't like my rainbow  
    --["<LB>"] = {text = "^ff0000\n—^ff8000—^ffff00—^80ff00—^00ff00—^00ff80—^00ffff—^0080ff—^0000ff—^8000ff—^d70ead—^ff0080—^000000"},
    -- blank linebreak
    --["<LB>"] = {text = "\n^FFFFFF—^000000"},
    -- black linebreak
    ["<LB>"] = {text = "^000000\n————————————"},
    ["<IND>"] = {text = "^777777• ^000000"},
    ["<IND2>"] = {text = "^777777 º ^000000"},
    ["<IND3>"] = {text = "^777777  • ^000000"},
    ["<BLA>"] = {text = "^000000"},
    ["<G>"] = {text = "^1a9401"},
    ["<BLU>"] = {text = "^0404d1"},
    ["<R>"] = {text = "^FF0000"},
    ["<SK>"] = {text = "^0437d1"},
    ["<PR>"] = {text = "^800080"},
    ["<TL>"] = {text = "^005270"},
    ["<EQ>"] = {text = "^777777"},
    ["<GR>"] = {text = "^d3d3d3"},
    ["</SK>"] = {text = "^000000"},
    ["</>"] = {text = "^000000"},
    -- string constants
    ["VCT"] = {text = "Variable Cast Time"},
    ["FCT"] = {text = "Fixed Cast Time"},
    ["ACD"] = {text = "After Cast Delay"},
    ["LRD"] = {text = "Ranged Damage"},
    ["CTD"] = {text = "Critical Damage"},
    ["RDTF"] = {text = "Reduce damage taken from"},
    -- refines
    ["@5"] = {text = "^1a9401When refined to +5 or higher,^000000"},
    ["@6"] = {text = "^1a9401When refined to +6 or higher,^000000"},
    ["@7"] = {text = "^1a9401When refined to +7 or higher,^000000"},
    ["@8"] = {text = "^1a9401When refined to +8 or higher,^000000"},
    ["@9"] = {text = "^1a9401When refined to +9 or higher,^000000"},
    ["@10"] = {text = "^1a9401When refined to +10 or higher,^000000"},
    ["@11"] = {text = "^1a9401When refined to +11 or higher,^000000"},
    ["@12"] = {text = "^1a9401When refined to +12 or higher,^000000"},
    ["@13"] = {text = "^1a9401When refined to +13 or higher,^000000"},
    -- set bonus
    ["<SB>"] = {text = "^800080Set Bonus^005270\n"},
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