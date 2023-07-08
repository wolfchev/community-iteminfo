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
    ["CRITD"] = {text = "Critical Damage"},
    ["RDTF"] = {text = "Reduce damage taken from"},
    ["ER"] = {text = "^1a9401For every refine^000000,"},
    ["NOWOE"] = {text = "^FF0000This effect does not work in WoE maps^000000"},
    -- set bonus
    ["<SB>"] = {text = "^800080Set Bonus^005270\n"},
    ["<SM>"] = {text = "^800080Set Malus^005270\n"},
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
                result, msg = AddItemUnidentifiedDesc(ItemID, v)
                if not result == true then
                    return false, msg
                end
            end
        end

        --[[ universal unidentified item description
        for k, v in pairs(universalUnidentifiedDescription) do
            result, msg = AddItemUnidentifiedDesc(ItemID, v)
            if not result == true then
                return false, msg
            end
        end
        ]]--
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
        result, msg = AddItemUnidentifiedDesc(ItemID, "^FF0000[Community Description]^000000")
        if not result == true then
            return false, msg
        end
        for k, v in pairs(DESC.identifiedDescriptionName) do

            local desc = v
            for k2, v2 in pairs(markupToken) do
                desc = desc:gsub(k2,v2.text)
            end

            -- Refine at X
            desc = desc:gsub("@%d+","^1a9401When refined to +%0 or higher,^000000")
            desc = desc:gsub("@","")
            
            -- Every X Refines Of
            desc = desc:gsub("E%d+RO","^1a9401For every %0 refines of ")
            desc = desc:gsub("E%d+RO", function(s) return s:gsub("E",""):gsub("RO","")end)

            -- Every X Refines
            desc = desc:gsub("E%d+R","^1a9401For every %0 refines,^000000")
            desc = desc:gsub("E%d+R", function(s) return s:gsub("E",""):gsub("R","")end)

            result, msg = AddItemIdentifiedDesc(ItemID, desc)
            result, msg = AddItemUnidentifiedDesc(ItemID, v)
            if not result == true then
                return false, msg
            end
        end
    end

    return true, "good"
end