local ADDON_NAME,VERSION="BanditsLootManager",1.10
BanditsLootManagerInProgress=false		--API state variable
local itemStyles={
	[ITEMSTYLE_RACIAL_BRETON]=true,
	[ITEMSTYLE_RACIAL_REDGUARD]=true,
	[ITEMSTYLE_RACIAL_ORC]=true,
	[ITEMSTYLE_RACIAL_DARK_ELF]=true,
	[ITEMSTYLE_RACIAL_NORD]=true,
	[ITEMSTYLE_RACIAL_ARGONIAN]=true,
	[ITEMSTYLE_RACIAL_HIGH_ELF]=true,
	[ITEMSTYLE_RACIAL_WOOD_ELF]=true,
	[ITEMSTYLE_RACIAL_KHAJIIT]=true,
	[ITEMSTYLE_AREA_ANCIENT_ELF]=true,
	[ITEMSTYLE_AREA_REACH]=true,
	[ITEMSTYLE_ENEMY_PRIMITIVE]=true,
	[ITEMSTYLE_ENEMY_DAEDRIC]=true,
	[ITEMSTYLE_RACIAL_IMPERIAL]=true,
}
local ignoreList={
	[56862]=true,	--Fortified Nirncrux
	[56863]=true,	--Potent Nirncrux
	[33235]=true,	--Wabbajack
	[29956]=true,	--Hunting Bow
	[54982]=true,	--Sentinel's Lash
	[54983]=true,	--Cadwell's Lost Robe
	[54984]=true,	--Er-Jaseen's Worn Jack
	[54985]=true,	--Unfinished Torment Cuirass
	[43757]=true,	--Wet Gunny Sack
	[71073]=true,	--AvA Stam
	[71071]=true,	--AvA Health
	[71072]=true,	--AvA Magicka
	[74728]=true,	--TG Stam/Stealth
	[74728]=true,	--TG Stam/Speed
	[27059] =true,	--Bervez Juice
	[26802] =true,	--Frost Mirriam
	[64222] =true,	--Caviar
}
local MonsterParts={
	[54382]=true,	--Carapace
	[54383]=true,	--Daedra Husk
	[54384]=true,	--Ectoplasm
	[54385]=true,	--Elemental Esssence
	[54381]=true,	--Foul Hide
	[54388]=true,	--Supple Root
}
local QuestItems={
	["Nibbles and Bits"]={[54382]=4,[54383]=5,[54381]=3},
	["Morsels and Pecks"]={[54385]=2,[54388]=3,[54384]=3}
}
local Consumables={
	[33271]="|H1:item:33271:31:50:0:0:0:0:0:0:0:0:0:0:0:0:36:0:0:0:0:0|h|h",	--Soulgem
	[33265]="|H1:item:33265:30:50:0:0:0:0:0:0:0:0:0:0:0:0:36:0:0:0:0:0|h|h",	--Soulgem (empty)
	[30357]="|H1:item:30357:175:1:0:0:0:0:0:0:0:0:0:0:0:0:36:0:0:0:0:0|h|h",	--Lockpick
	[44879]="|H1:item:44879:121:50:0:0:0:0:0:0:0:0:0:0:0:0:36:0:0:0:0:0|h|h",	--Repair kit
	[27037]="|H1:item:27037:307:50:0:0:0:0:0:0:0:0:0:0:0:0:36:0:0:0:0:0|h|h",	--Essence of Magicka
	[27038]="|H1:item:27038:307:50:0:0:0:0:0:0:0:0:0:0:0:0:36:0:0:0:0:0|h|h",	--Essence of Stamina
	[27138]="|H1:item:27138:175:1:0:0:0:0:0:0:0:0:0:0:0:0:36:0:0:0:0:0|h|h",	--Keep Wall Repair kit
	[27962]="|H1:item:27962:175:1:0:0:0:0:0:0:0:0:0:0:0:0:36:0:0:0:0:0|h|h",	--Keep Door Repair Kit
	}
local AvAitems={
[SPECIALIZED_ITEMTYPE_SIEGE_BALLISTA]=true,
[SPECIALIZED_ITEMTYPE_SIEGE_BATTLE_STANDARD]=true,
[SPECIALIZED_ITEMTYPE_SIEGE_CATAPULT]=true,
[SPECIALIZED_ITEMTYPE_SIEGE_GRAVEYARD]=true,
[SPECIALIZED_ITEMTYPE_SIEGE_MONSTER]=true,
[SPECIALIZED_ITEMTYPE_SIEGE_OIL]=true,
[SPECIALIZED_ITEMTYPE_SIEGE_RAM]=true,
[SPECIALIZED_ITEMTYPE_SIEGE_TREBUCHET]=true,
[SPECIALIZED_ITEMTYPE_SIEGE_UNIVERSAL]=true,
[SPECIALIZED_ITEMTYPE_AVA_REPAIR]=true,
}
local Fragments={
--[SPECIALIZED_ITEMTYPE_TROPHY_KEY]=true,
[SPECIALIZED_ITEMTYPE_TROPHY_KEY_FRAGMENT]=true,
[SPECIALIZED_ITEMTYPE_TROPHY_MATERIAL_UPGRADER]=true,
[SPECIALIZED_ITEMTYPE_TROPHY_RUNEBOX_FRAGMENT]=true,
}
local IsCommonStyle={
	[0]=true,
	[ITEMSTYLE_RACIAL_BRETON]=true,
	[ITEMSTYLE_RACIAL_REDGUARD]=true,
	[ITEMSTYLE_RACIAL_ORC]=true,
	[ITEMSTYLE_RACIAL_DARK_ELF]=true,
	[ITEMSTYLE_RACIAL_NORD]=true,
	[ITEMSTYLE_RACIAL_ARGONIAN]=true,
	[ITEMSTYLE_RACIAL_HIGH_ELF]=true,
	[ITEMSTYLE_RACIAL_WOOD_ELF]=true,
	[ITEMSTYLE_RACIAL_KHAJIIT]=true,
	[ITEMSTYLE_AREA_ANCIENT_ELF]=true,
	[ITEMSTYLE_AREA_REACH]=true,
	[ITEMSTYLE_ENEMY_PRIMITIVE]=true,
	[ITEMSTYLE_ENEMY_DAEDRIC]=true,
	[ITEMSTYLE_RACIAL_IMPERIAL]=true,
}
local ItemQuality={
--	[ITEM_QUALITY_TRASH]="Trash",
	[ITEM_QUALITY_NORMAL]="Normal",
	[ITEM_QUALITY_MAGIC]="|c22EE22Green|r",
	[ITEM_QUALITY_ARCANE]="|c5555FFBlue|r",
	[ITEM_QUALITY_ARTIFACT]="|cEE22EEPurple|r",
	[ITEM_QUALITY_LEGENDARY]="|cEEEE33Gold|r",
}
local IsHihgMaterial={
	[64489]=true,	--Rubedite ingot
	[64504]=true,	--Ancestor Silk
	[64506]=true,	--Rubedo leather
	[64502]=true,	--Sanded ruby ash
	}
local Destroy={
	[42878]=true	--Used bait
	}
local Default={	--Base settings
--	World			=string.match(GetWorldName(),"%a+"),
	Sell			=false,
	Transfer		=false,
	Deposit		=false,
	Launder		=false,
	ChatOutput		=true,
	DetailedBank	=false,
	DetailedLoot	=false,
	--			Quality,	Price,	Destroy,	Junk,		ToBank,	FromBank
	Gold			={nil,	10000,	nil,		nil,		false,	false},
	Telvar		={nil,	0,		nil,		nil,		false,	false},
	AP			={nil,	0,		nil,		nil,		false,	false},
	Voucher		={nil,	0,		nil,		nil,		false,	false},
	Consumables		={nil,	200,		nil,		nil,		false,	false},
	--Items
	Items			={1,		0,		false,	false,	nil,		nil},
		TrashItems		=true,
		MonsterParts	=false,
		RareStyleEquip	=false,
		SetItems		=false,
		Ornate		=false,
		Intricate		=false,
		FishingLure		=false,
	Stolen		={3,		10,		false,	false,	nil,		nil},
	Jewelry		={1,		0,		false,	false,	false,	nil},
	Glyph			={1,		nil,		false,	false,	false,	false},
	Fragments		={nil,	nil,		nil,		nil,		false,	false},
	Potions		={nil,	nil,		false,	false,	false,	false},
	Food			={1,		nil,		false,	false,	false,	false},
	Furnishing		={1,		nil,		nil,		false,	false,	false},
	--Materials
	LowMaterial		={nil,	nil,		nil,		false,	nil,		nil},
	Alchemy		={nil,	nil,		nil,		nil,		false,	false},
	Blacksmithing	={nil,	nil,		nil,		nil,		false,	false},
	Clothier		={nil,	nil,		nil,		nil,		false,	false},
	Woodworking		={nil,	nil,		nil,		nil,		false,	false},
	JewelryCrafting	={nil,	nil,		nil,		nil,		false,	false},
--	JewelryTrait	={nil,	nil,		nil,		nil,		false,	false},
	FurnishingCrafting={nil,	nil,		nil,		nil,		false,	false},
	StyleMaterial	={nil,	nil,		false,	nil,		false,	false},
	TraitMaterial	={nil,	nil,		false,	nil,		false,	false},
	CraftingBooster	={nil,	nil,		nil,		nil,		false,	false},
	Ingridient		={nil,	nil,		false,	nil,		false,	false},
	Rune			={nil,	nil,		false,	false,	false,	false},
	Aspect		={1,		nil,		false,	false,	false,	false},
	--Recieps
	StyleKnown		={3,		nil,		false,	nil,		false,	false},
	StyleUnknown	={nil,	nil,		nil,		nil,		false,	false},
	RecipeKnown		={2,		nil,		false,	false,	false,	false},
	RecipeUnknown	={nil,	nil,		nil,		nil,		false,	false},
	TreasureMap		={nil,	nil,		nil,		nil,		false,	false},
	MasterWrit		={nil,	nil,		nil,		nil,		false,	false},
	}
local Localisation={
	en={
		Tooltip={
		"Quality",
		"Price<=",
		"Destroy items",
		"Mark items as junk",
		"Push to bank",
		"Retreive from bank",
		"\nwith quality <<1>> or lower",
		"\nand price <<2>>|t16:16:EsoUI/Art/currency/currency_gold.dds|t or lower",
		},
		Sold			="Sold |t16:16:<<1>>|t<<3>>x <<t:2>> for <<4>>|t16:16:EsoUI/Art/currency/currency_gold.dds|t.",
		SoldTotal		="Sold <<1>> <<1[item/items]>> for <<2>>|t16:16:EsoUI/Art/currency/currency_gold.dds|t.",
		Laundered		="Laundered |t16:16:<<1>>|t<<3>>x <<t:2>> for <<4>>|t16:16:EsoUI/Art/currency/currency_gold.dds|t.",
		LaunderedTotal	="Laundered <<1>> <<1[item/items]>> for <<2>>|t16:16:EsoUI/Art/currency/currency_gold.dds|t.",
		Deposited		="Deposited <<1>>|t16:16:<<2>>|t to bank.",
		DepositedItem	="Deposited |t16:16:<<1>>|t<<3>> x <<t:2>>.",
		DepositedTotal	="Deposited <<1>> <<1[item/items]>> (<<2>> total).",
		Withdrawn		="Withdrawn <<1>>|t16:16:<<2>>|t from bank.",
		WithdrawnItem	="Withdrawn |t16:16:<<1>>|t<<3>> x <<t:2>>.",
		WithdrawnTotal	="Withdrawn <<1>> <<1[item/items]>> (<<2>> total).",
		Destroy		="Destroy |t16:16:<<1>>|t<<2>> (<<3>>)",
		Junk			="Junk |t16:16:<<1>>|t<<2>>",
		Progress		="|cEE2222In progress|r",
		Rescan		={entry="Rescan", tooltip="Rescan inventory"},
		Sell			={entry="Auto sell in store"},
		Transfer		={entry="Auto currency transfer"},
		Deposit		={entry="Auto deposit to bank"},
		Launder		={entry="Auto laundry with fence",tooltip="Will not launder trophy and lockpicks."},
		ChatOutput		={
			entry="Chat messages",
			[1]="Post to chat total sold/laundered/deposited/withdrawn messages.",
			[2]="Detailed bank/store/fence (withdraw/deposit) chat messages.",
			[3]="Detailed loot (destroy/mark as junk) chat messages.",
			},
		Gold			={entry="Keep gold quantity"},
		Telvar		={entry="Keep telvar quantity"},
		AP			={entry="Alliance points"},
		Voucher		={entry="Writ vouchers"},
		TrashItems		={entry="Trash items"},
		MonsterParts	={entry="Monster parts (Needed for quest in Clockwork City)."},
		RareStyleEquip	={entry="Rare style equipement"},
		SetItems		={entry="Set items"},
		Ornate		={entry="Items with ornate trait"},
		Intricate		={entry="Items with intricate trait"},
		FishingLure		={entry="Fishing lure"},
		Stolen		={entry="Stolen items"},
		Jewelry		={entry="Jewelry",[5]=" (execpt locked)"},
		Glyph			={entry="Glyphs"},
		Fragments		={entry="Fragments", tooltip="Trophy key/runebox fragments."},
		Potions		={entry="Potions/poisons",[3]=" (except 150 potions)",[4]=" (except 150 potions)"},
		Food			={entry="Food/drink"},
		Furnishing		={entry="Furnishing"},
		LowMaterial		={entry="Low level materials",tooltip="<150 level (except raw materials)"},
		Alchemy		={entry="Alchemy reagents"},
		Blacksmithing	={entry="Blacksmithing materials"},
		Clothier		={entry="Clothier materials"},
		Woodworking		={entry="Woodworking materials"},
		JewelryCrafting	={entry="Jewelry materials"},
--		JewelryTrait	={entry="Jewelry trait materials"},
		FurnishingCrafting={entry="Furnishing materials"},
		StyleMaterial	={entry="Style material",[3]=" (except rare style materials)"},
		TraitMaterial	={entry="Trait material",[3]=" (except jewelry materials)"},
		CraftingBooster	={entry="Crafting boosters"},
		Ingridient		={entry="Food ingredients",[3]=" (except "..ItemQuality[4].." quality)"},
		Rune			={entry="Potency/essence rune"},
		Aspect		={entry="Aspect rune"},
		StyleKnown		={entry="Crafting style known"},
		StyleUnknown	={entry="Crafting style unknown"},
		RecipeKnown		={entry="Recipe known"},
		RecipeUnknown	={entry="Recipe unknown"},
		TreasureMap		={entry="Treasure/survey maps"},
		MasterWrit		={entry="Master writs"},
		--Headers
		HeaderCurency	={entry="Currency"},
		HeaderItems		={entry="Items"},
		HeaderMaterials	={entry="Materials"},
		HeaderRecieps	={entry="Recipes"},
		HeaderConsumables	={entry="Consumables"},
	}
}
local lang=GetCVar("language.2") if not Localisation[lang] then lang="en" end
for id,itemLink in pairs(Consumables) do Localisation[lang][id]={entry=GetItemLinkName(itemLink)} end
local MenuSettings={
	{param="Sell",		icon="/esoui/art/bank/bank_tabicon_gold_up.dds"},
	{param="Transfer",	icon="/esoui/art/bank/bank_tabicon_deposit_up.dds"},
	{param="Deposit",		icon="/esoui/art/tutorial/vendor_tabicon_sell_up.dds"},
	{param="Launder",		icon="/esoui/art/vendor/vendor_tabicon_fence_up.dds"},
	{param="ChatOutput",	icon="/esoui/art/tutorial/chat-notifications_up.dds"},
	{param="HeaderCurency",	header=true},
	{param="Gold",		count=true,icon="/esoui/art/bank/bank_tabicon_gold_up.dds"},
	{param="Telvar",		count=true,icon="/esoui/art/bank/bank_tabicon_telvar_up.dds"},
	{param="AP",		count=true,icon="/esoui/art/currency/alliancepoints_32.dds"},
	{param="Voucher",		count=true,icon="/esoui/art/currency/writvoucher_mipmap.dds"},
	{param="HeaderConsumables",	header=true},
	{param="Consumables",	count=true,filters="ConsumableFilters"},
	{param="HeaderItems",	header=true},
	{param="Items",		filters="TrashFilters"},
	{param="Stolen",		icon="/esoui/art/inventory/gamepad/gp_inventory_icon_stolenitem.dds"},
	{param="Jewelry",		icon="/esoui/art/icons/gear_altmer_neck_a.dds"},
	{param="Glyph",		switch=true,icon="/esoui/art/icons/crafting_enchantment_032.dds"},
	{param="Fragments",	switch=true,icon="/esoui/art/icons/quest_daedricembers.dds"},
	{param="Potions",		switch=true,icon="/esoui/art/treeicons/store_indexicon_consumables_up.dds"},
	{param="Food",		switch=true,icon="/esoui/art/tutorial/inventory_tabicon_food_up.dds"},
	{param="Furnishing",	switch=true,icon="/esoui/art/treeicons/collection_indexicon_furnishings_up.dds"},
	{param="HeaderMaterials",header=true},
	{param="LowMaterial",	icon="/esoui/art/icons/crafting_ore_base_iron_r2.dds"},
	{param="Alchemy",		switch=true,icon="/esoui/art/inventory/inventory_tabicon_craftbag_alchemy_up.dds"},
	{param="Blacksmithing",	switch=true,icon="/esoui/art/inventory/inventory_tabicon_craftbag_blacksmithing_up.dds"},
	{param="Clothier",	switch=true,icon="/esoui/art/inventory/inventory_tabicon_craftbag_clothing_up.dds"},
	{param="Woodworking",	switch=true,icon="/esoui/art/inventory/inventory_tabicon_craftbag_woodworking_up.dds"},
	{param="JewelryCrafting",switch=true,icon="/esoui/art/icons/servicetooltipicons/servicetooltipicon_jewelrycrafting.dds"},
--	{param="JewelryTrait",	switch=true,icon="/esoui/art/icons/servicetooltipicons/servicetooltipicon_jewelrycrafting.dds"},
	{param="FurnishingCrafting",switch=true,icon="/esoui/art/treeicons/collection_indexicon_furnishings_up.dds"},
	{param="StyleMaterial",	switch=true,icon="/esoui/art/inventory/inventory_tabicon_craftbag_stylematerial_up.dds"},
	{param="TraitMaterial",	switch=true,icon="/esoui/art/inventory/inventory_tabicon_craftbag_itemtrait_up.dds"},
	{param="CraftingBooster",switch=true,icon="/esoui/art/icons/jewelrycrafting_booster_refined_chromium.dds"},
	{param="Ingridient",	switch=true,icon="/esoui/art/inventory/inventory_tabicon_craftbag_provisioning_up.dds"},
	{param="Rune",		switch=true,icon="/esoui/art/crafting/enchantment_tabicon_potency_up.dds"},
	{param="Aspect",		switch=true,icon="/esoui/art/crafting/enchantment_tabicon_aspect_up.dds"},
	{param="HeaderRecieps",	header=true},
	{param="StyleKnown",	switch=true,icon="/esoui/art/treeicons/gamepad/gp_lorelibrary_categoryicon_craftingstyle.dds"},
	{param="StyleUnknown",	switch=true,icon="/esoui/art/treeicons/gamepad/gp_lorelibrary_categoryicon_craftingstyle.dds"},
	{param="RecipeKnown",	switch=true,icon="/esoui/art/icons/quest_scroll_001.dds"},
	{param="RecipeUnknown",	switch=true,icon="/esoui/art/icons/quest_scroll_001.dds"},
	{param="TreasureMap",	switch=true,icon="/esoui/art/icons/quest_scroll_001.dds"},
	{param="MasterWrit",	switch=true,icon="/esoui/art/icons/master_writ_blacksmithing.dds"},
}
local ItemFilters={
	TrashFilters={
	TrashItems		={icon="/esoui/art/inventory/inventory_tabicon_junk_up.dds"},
	MonsterParts	={icon="/esoui/art/icons/crafting_daedra_noisome_husk.dds"},
	RareStyleEquip	={icon="/esoui/art/tutorial/inventory_tabicon_armor_up.dds"},
	SetItems		={icon="/esoui/art/crafting/smithing_tabicon_armorset_up.dds"},
	Ornate		={icon="/esoui/art/vendor/vendor_tabicon_sell_up.dds"},
	Intricate		={icon="/esoui/art/crafting/enchantment_tabicon_deconstruction_up.dds"},
	FishingLure		={icon="/esoui/art/inventory/inventory_tabicon_craftbag_fishing_up.dds"}
	},
	ConsumableFilters={
	[33271]	={icon="/esoui/art/icons/soulgem_006_filled.dds"},
	[33265]	={icon=GetItemLinkInfo(Consumables[33265])},
	[30357]	={icon="/esoui/art/icons/lockpick.dds"},
	[44879]	={icon="/esoui/art/lfg/lfg_bonus_crate.dds"},
	[27138]	={icon=GetItemLinkInfo(Consumables[27138])},
	[27962]	={icon=GetItemLinkInfo(Consumables[27962])},
	[27037]	={icon=GetItemLinkInfo(Consumables[27037])},
	[27038]	={icon=GetItemLinkInfo(Consumables[27038])},
	}
}
--	/script local itemIcon=GetItemLinkInfo("|H1:item:5413:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0|h|h") StartChatInput(itemIcon)
local isRecipe={
[SPECIALIZED_ITEMTYPE_RECIPE_ALCHEMY_FORMULA_FURNISHING]=true,
[SPECIALIZED_ITEMTYPE_RECIPE_BLACKSMITHING_DIAGRAM_FURNISHING]=true,
[SPECIALIZED_ITEMTYPE_RECIPE_CLOTHIER_PATTERN_FURNISHING]=true,
[SPECIALIZED_ITEMTYPE_RECIPE_ENCHANTING_SCHEMATIC_FURNISHING]=true,
[SPECIALIZED_ITEMTYPE_RECIPE_JEWELRYCRAFTING_SKETCH_FURNISHING]=true,
[SPECIALIZED_ITEMTYPE_RECIPE_PROVISIONING_DESIGN_FURNISHING]=true,
[SPECIALIZED_ITEMTYPE_RECIPE_PROVISIONING_STANDARD_DRINK]=true,
[SPECIALIZED_ITEMTYPE_RECIPE_PROVISIONING_STANDARD_FOOD]=true,
[SPECIALIZED_ITEMTYPE_RECIPE_WOODWORKING_BLUEPRINT_FURNISHING]=true
}
local SavedVars,CustomJunk,ignoreId
--Functions
local function IsItemProtected(bagId,slotId)
	if IsItemPlayerLocked(bagId,slotId) then
		return true
	end
	--Item Saver support
	if ItemSaver_IsItemSaved then
		return ItemSaver_IsItemSaved(bagId,slotId)
	end
	--FCO ItemSaver support
	if FCOIS and FCOIS.IsJunkLocked then
		return FCOIS.IsJunkLocked(bagId,slotId)
	end
	--FilterIt support
	if FilterIt and FilterIt.AccountSavedVariables and FilterIt.AccountSavedVariables.FilteredItems then
		local sUniqueId=Id64ToString(GetItemUniqueId(bagId,slotId))
		if FilterIt.AccountSavedVariables.FilteredItems[sUniqueId] then
			return FilterIt.AccountSavedVariables.FilteredItems[sUniqueId] ~= FILTERIT_VENDOR
		end
	end

	return false
end

local function JoinTables(target,source)
	local target=target or {}
	local source=source or {}
	for param,value in pairs(source) do
		if type(value)=="table" then
			target[param]={}
			for param1,value1 in pairs(value) do
				target[param][param1]=value1
			end
		else
			target[param]=value
		end
	end
	return target
end
--Bank
local function ChangeLabel()
	local control=KEYBIND_STRIP.keybinds["UI_SHORTCUT_QUATERNARY"]
	if control then
		control=control:GetChild(1)
		if control:GetType()==CT_LABEL then
			control:SetText(BanditsLootManagerInProgress and Localisation[lang].Progress or Localisation[lang].Deposit.entry)
		end
	end
end

local function MoveCurrency()
	for i=5,6 do
		local curency={}
		if SavedVars.Gold[i] then curency[CURT_MONEY]=SavedVars.Gold[2] end
		if SavedVars.Telvar[i] then curency[CURT_TELVAR_STONES]=SavedVars.Telvar[2] end
		if SavedVars.AP[i] then curency[CURT_ALLIANCE_POINTS]=SavedVars.AP[2] end
		if SavedVars.Voucher[i] then curency[CURT_WRIT_VOUCHERS]=SavedVars.Voucher[2] end
		for currencyType,amount in pairs(curency) do
			local amount_character=GetCurrencyAmount(currencyType,CURRENCY_LOCATION_CHARACTER)
			local amount_to_transfer=i==6 and math.min(amount-amount_character,GetCurrencyAmount(currencyType,CURRENCY_LOCATION_BANK)) or amount_character-amount
			if amount_to_transfer>0 then
				TransferCurrency(currencyType,amount_to_transfer,i==6 and CURRENCY_LOCATION_BANK or CURRENCY_LOCATION_CHARACTER,i==6 and CURRENCY_LOCATION_CHARACTER or CURRENCY_LOCATION_BANK)
				d(zo_strformat(Localisation[lang][i==5 and "Deposited" or "Withdrawn"],amount_to_transfer,GetCurrencyKeyboardIcon(currencyType)))
			end
		end
	end
end

local function MoveItems()
	BanditsLootManagerInProgress=true
	ChangeLabel(true)
	local QueueData={}
	local BagCache={[BAG_BACKPACK]=SHARED_INVENTORY.bagCache[BAG_BACKPACK],[BAG_BANK]=SHARED_INVENTORY.bagCache[BAG_BANK]}
	local tempBagCache={[BAG_BACKPACK]={},[BAG_BANK]={}}
	local FirstSlot={[BAG_BACKPACK]=0,[BAG_BANK]=0}
	local BagSize={[BAG_BACKPACK]=GetBagSize(BAG_BACKPACK),[BAG_BANK]=GetBagSize(BAG_BANK)}
	--Find slot to stack
	local function FindSlotToStack(bagId,itemId,count)
		for slotIndex=0, BagSize[bagId]-1 do
			if itemId and itemId==GetItemId(bagId,slotIndex) then
				local stackCount,stackMax=GetSlotStackSize(bagId,slotIndex)
				if stackMax-stackCount>=count then return slotIndex end
			end
		end
	end
	--Find empty slot
	local function FindEmptySlotInBag(bagId)
		for slotIndex=FirstSlot[bagId], BagSize[bagId]-1 do
			if not BagCache[bagId][slotIndex] and not tempBagCache[bagId][slotIndex] then
				tempBagCache[bagId][slotIndex]=true
				FirstSlot[bagId]=slotIndex+1
				return slotIndex
			end
		end
	end
	--Consumables
	local ConsumableItems={}
	for id in pairs(Consumables) do
		ConsumableItems[id]={
			Info={[BAG_BACKPACK]={},[BAG_BANK]={}},
			Count={[BAG_BACKPACK]=0,[BAG_BANK]=0},
			Hold=SavedVars[id] and SavedVars.Consumables[2] or 0,
			Deposit=SavedVars.Consumables[5],
			Withdraw=SavedVars.Consumables[6]
			}
	end
	--Quests
	for i=1,GetNumJournalQuests()do
		local items=QuestItems[GetJournalQuestName(i)]
		if items then
			for id,count in pairs(items) do
				ConsumableItems[id]={
					Info={[BAG_BACKPACK]={},[BAG_BANK]={}},
					Count={[BAG_BACKPACK]=0,[BAG_BANK]=0},
					Hold=count,
					Withdraw=true,
					}
			end
		end
	end

	for Action=5,6 do	--Deposit, Withdraw
		local sourceBag=Action==5 and BAG_BACKPACK or BAG_BANK
		local destBag=Action==5 and BAG_BANK or BAG_BACKPACK
		for slotIndex,data in pairs(BagCache[sourceBag]) do
			local param=nil
			local itemLink=GetItemLink(sourceBag,slotIndex)
			if not data.isJunk and not IsItemLinkStolen(itemLink) and not IsItemLinkCrafted(itemLink) then
				local itemId=GetItemId(sourceBag,slotIndex)
				if itemId then
					local itemType,specializedItemType=GetItemLinkItemType(itemLink)
					local stackCount,stackMax=GetSlotStackSize(sourceBag,slotIndex)
					--Consumables
					if ConsumableItems[itemId] then
						table.insert(ConsumableItems[itemId].Info[sourceBag],{slotIndex=slotIndex,stackCount=stackCount,stackMax=stackMax,itemLink=itemLink})
						ConsumableItems[itemId].Count[sourceBag]=ConsumableItems[itemId].Count[sourceBag]+stackCount
					--Items
					elseif MonsterParts[itemId] and Action==5 and not SavedVars.MonsterParts then
						table.insert(QueueData,{Action,sourceBag,destBag,slotIndex,stackCount,itemLink,(stackCount<stackMax and itemId or nil)})
					elseif itemType==ITEMTYPE_ARMOR and not IsItemPlayerLocked(sourceBag,slotIndex) then
						local _,_,_,equipType=GetItemLinkInfo(itemLink)
						if equipType==EQUIP_TYPE_NECK or equipType==EQUIP_TYPE_RING then param="Jewelry" end
					elseif itemType==ITEMTYPE_GLYPH_ARMOR or itemType==ITEMTYPE_GLYPH_JEWELRY or itemType==ITEMTYPE_GLYPH_WEAPON then param="Glyph"
					elseif Fragments[specializedItemType] then param="Fragments"
					elseif itemType==ITEMTYPE_POTION or itemType==ITEMTYPE_POISON and not IsItemBound(sourceBag,slotIndex) then param="Potions"
					elseif itemType==ITEMTYPE_FOOD or itemType==ITEMTYPE_DRINK then param="Food"
					elseif itemType==ITEMTYPE_FURNISHING then param="Furnishing"
--					elseif itemType==ITEMTYPE_LURE then param="FishingLure"
					--Materials
					elseif itemType==ITEMTYPE_STYLE_MATERIAL or itemType==ITEMTYPE_RAW_MATERIAL then param="StyleMaterial"
					elseif itemType==ITEMTYPE_ARMOR_TRAIT or itemType==ITEMTYPE_WEAPON_TRAIT then param="TraitMaterial"
					elseif itemType==ITEMTYPE_INGREDIENT then param="Ingridient"
					elseif itemType==ITEMTYPE_BLACKSMITHING_BOOSTER or itemType==ITEMTYPE_CLOTHIER_BOOSTER or itemType==ITEMTYPE_WOODWORKING_BOOSTER or itemType==ITEMTYPE_JEWELRYCRAFTING_BOOSTER or itemType==ITEMTYPE_JEWELRYCRAFTING_RAW_BOOSTER then param="CraftingBooster"
					--Enchanting
					elseif itemType==ITEMTYPE_ENCHANTING_RUNE_ESSENCE or itemType==ITEMTYPE_ENCHANTING_RUNE_POTENCY then param="Rune"
					elseif itemType==ITEMTYPE_ENCHANTING_RUNE_ASPECT then param="Aspect"
					--Craft
--					elseif (itemType==ITEMTYPE_BLACKSMITHING_MATERIAL or itemType==ITEMTYPE_CLOTHIER_MATERIAL or itemType==ITEMTYPE_WOODWORKING_MATERIAL) and not IsHihgMaterial[itemId] then param="LowMaterial"
					elseif itemType==ITEMTYPE_REAGENT or itemType==ITEMTYPE_POISON_BASE or itemType==ITEMTYPE_POTION_BASE then param="Alchemy"
					elseif itemType==ITEMTYPE_BLACKSMITHING_MATERIAL or itemType==ITEMTYPE_BLACKSMITHING_RAW_MATERIAL then param="Blacksmithing"
					elseif itemType==ITEMTYPE_CLOTHIER_MATERIAL or itemType==ITEMTYPE_CLOTHIER_RAW_MATERIAL then param="Clothier"
					elseif itemType==ITEMTYPE_WOODWORKING_MATERIAL or itemType==ITEMTYPE_WOODWORKING_RAW_MATERIAL then param="Woodworking"
					elseif itemType==ITEMTYPE_JEWELRYCRAFTING_MATERIAL or itemType==ITEMTYPE_JEWELRYCRAFTING_RAW_MATERIAL or itemType==ITEMTYPE_JEWELRY_RAW_TRAIT or itemType==ITEMTYPE_JEWELRY_TRAIT then param="JewelryCrafting"
--					elseif itemType==ITEMTYPE_JEWELRY_RAW_TRAIT or itemType==ITEMTYPE_JEWELRY_TRAIT then param="JewelryTrait"
					elseif itemType==ITEMTYPE_FURNISHING_MATERIAL then param="FurnishingCrafting"
					--Recieps
					elseif itemType==ITEMTYPE_RACIAL_STYLE_MOTIF then param=IsItemLinkBookKnown(itemLink) and "StyleKnown" or "StyleUnknown"
					elseif itemType==ITEMTYPE_RECIPE and isRecipe[specializedItemType] then param=IsItemLinkRecipeKnown(itemLink) and "RecipeKnown" or "RecipeUnknown"
					elseif specializedItemType==SPECIALIZED_ITEMTYPE_TROPHY_RECIPE_FRAGMENT then param="RecipeKnown"
					elseif specializedItemType==SPECIALIZED_ITEMTYPE_TROPHY_SURVEY_REPORT or specializedItemType==SPECIALIZED_ITEMTYPE_TROPHY_TREASURE_MAP then param="TreasureMap"
					elseif itemType==ITEMTYPE_MASTER_WRIT then param="MasterWrit"
					end
					if param then
						if SavedVars[param][Action] then
							table.insert(QueueData,{Action,sourceBag,destBag,slotIndex,stackCount,itemLink,(stackCount<stackMax and itemId or nil)})
						end
					end
--]]
				end
			end
		end
	end
	--Consumables
	for id,Item in pairs(ConsumableItems) do
		--Deposit
		if Item.Deposit and Item.Count[BAG_BACKPACK]-Item.Hold>0 then
			for _,data in pairs(Item.Info[BAG_BACKPACK]) do
				local count=math.min(Item.Count[BAG_BACKPACK]-Item.Hold,data.stackCount)
				if count>0 then
					Item.Count[BAG_BACKPACK]=Item.Count[BAG_BACKPACK]-count
					table.insert(QueueData,{5,BAG_BACKPACK,BAG_BANK,data.slotIndex,count,data.itemLink,(count<data.stackMax and id or nil)})
				end
			end
		end
		--Withdraw
		if Item.Withdraw and Item.Hold-Item.Count[BAG_BACKPACK]>0 then
			for _,data in pairs(Item.Info[BAG_BANK]) do
				local count=math.min(Item.Hold-Item.Count[BAG_BACKPACK],data.stackCount)
				if count>0 then
					Item.Count[BAG_BACKPACK]=Item.Count[BAG_BACKPACK]+count
					table.insert(QueueData,{6,BAG_BANK,BAG_BACKPACK,data.slotIndex,count,data.itemLink,(count<data.stackMax and id or nil)})
				end
			end
		end
	end
	--Process prepaired queue
	local countMoved,itemsMoved,itemsMovedTotal={[BAG_BACKPACK]=0,[BAG_BANK]=0},{[BAG_BACKPACK]=0,[BAG_BANK]=0},0
	local function MoveItem(sourceBag,sourceSlot,destBag,destSlot,stackCount)
		if IsProtectedFunction("RequestMoveItem") then
			CallSecureProtected("RequestMoveItem",sourceBag,sourceSlot,destBag,destSlot,stackCount)
		else
			RequestMoveItem(sourceBag,sourceSlot,destBag,destSlot,stackCount)
		end
		itemsMovedTotal=itemsMovedTotal+1
	end
	for _,data in pairs(QueueData) do
		if itemsMovedTotal<80 then
			local FreeSlots=GetNumBagFreeSlots(data[3])
			if FreeSlots>0 then
				local Action,sourceBag,destBag,sourceSlot,stackCount,itemLink,itemId=unpack(data)
				local destSlot=itemId and FindSlotToStack(destBag,itemId,stackCount) destSlot=destSlot or FindEmptySlotInBag(destBag)	--FindFirstEmptySlotInBag(destBag)
				if destSlot then
					--Move item
					MoveItem(sourceBag,sourceSlot,destBag,destSlot,stackCount)
					countMoved[destBag]=countMoved[destBag]+stackCount
					itemsMoved[destBag]=itemsMoved[destBag]+1
					if SavedVars.DetailedBank then
						local itemIcon=GetItemLinkInfo(itemLink)
						d(zo_strformat(Localisation[lang][Action==5 and "DepositedItem" or "WithdrawnItem"],itemIcon,stackCount,itemLink))
					end
				end
			end
		end
	end
	--Summary
	for _,bag in pairs({BAG_BACKPACK,BAG_BANK}) do
		if itemsMoved[bag]>0 then
--			StackBag(bag)
			local text=zo_strformat(Localisation[lang][bag==BAG_BANK and "DepositedTotal" or "WithdrawnTotal"],itemsMoved[bag],countMoved[bag])
			ZO_Alert(UI_ALERT_CATEGORY_ALERT, nil, text)
			if SavedVars.ChatOutput then d(text) end
		end
	end

	BanditsLootManagerInProgress=false
	ChangeLabel(false)
end

local function Bank_Init()
	ZO_CreateStringId("SI_KEYBIND_STRIP_BLM_DEPOSIT",Localisation[lang].Deposit.entry)
	Button_Deposit={
		alignment=KEYBIND_STRIP_ALIGN_LEFT,
		{
			name=Localisation[lang].Deposit.entry,
			keybind="UI_SHORTCUT_QUATERNARY",
			enabled=function() return not BanditsLootManagerInProgress end,
			visible=function() return true end,
			order=100,
			callback=MoveItems,
		},
	}
	BANK_MENU_FRAGMENT:RegisterCallback("StateChange", function(oldState, newState)
		if newState==SCENE_SHOWN then
			KEYBIND_STRIP:AddKeybindButtonGroup(Button_Deposit)
--			ChangeLabel()
		elseif newState==SCENE_HIDING then
			KEYBIND_STRIP:RemoveKeybindButtonGroup(Button_Deposit)
		end
	end)
end

local function onOpenBank(_,bankBag)
	if bankBag~=BAG_BANK then return end
	if SavedVars.Deposit then MoveItems() end
	if SavedVars.Transfer then MoveCurrency() end
end
--Store
local function SellJunkItems(isFence)
	if not SavedVars.Sell or GetInteractionType()~=INTERACTION_VENDOR then return end

	local total=0
	local count=0
	local transactions=0
	local hagglingBonus
	local bagCache=SHARED_INVENTORY:GenerateFullSlotData(nil,BAG_BACKPACK)

	if isFence then
		hagglingBonus=GetNonCombatBonus(NON_COMBAT_BONUS_HAGGLING) or 0
	end

	for _,data in pairs(bagCache) do
		if transactions<80 and data.isJunk and data.stolen==isFence and not IsItemProtected(BAG_BACKPACK,data.slotIndex) then
			if isFence then
				local totalSells,sellsUsed=GetFenceSellTransactionInfo()
				if sellsUsed>=totalSells then
					ZO_Alert(UI_ALERT_CATEGORY_ALERT,SOUNDS.NEGATIVE_CLICK,GetString("SI_STOREFAILURE",STORE_FAILURE_AT_FENCE_LIMIT))
					break
				end
			end
			SellInventoryItem(BAG_BACKPACK,data.slotIndex,data.stackCount)

			local sellPrice=data.sellPrice
			if isFence and hagglingBonus>0 then
				sellPrice=zo_round(sellPrice*(1+hagglingBonus/100))
			end

			if SavedVars.DetailedBank then
				local itemLink=GetItemLink(BAG_BACKPACK,data.slotIndex)
				local itemIcon=GetItemLinkInfo(itemLink)
				d(zo_strformat(Localisation[lang].Sold,itemIcon,itemLink,data.stackCount,sellPrice*data.stackCount))
			end
			count=count+data.stackCount
			transactions=transactions+1
			total=total+sellPrice*data.stackCount
		end
	end

	if total>0 then
		local text=zo_strformat(Localisation[lang].SoldTotal,count,total)
		ZO_Alert(UI_ALERT_CATEGORY_ALERT, nil, text)
		if SavedVars.ChatOutput then d(text) end
	end
end

local function LaunderItems()
	local total=0
	local count=0
	local transactions=0
	for _,data in pairs(SHARED_INVENTORY.bagCache[BAG_BACKPACK]) do
		if transactions<80 and data.stolen and not IsItemProtected(BAG_BACKPACK,data.slotIndex) then
			local totalSells,sellsUsed=GetFenceLaunderTransactionInfo()
			local numFreeSlots=GetNumBagFreeSlots(BAG_BACKPACK)
			local qtyToLaunder=math.min(data.stackCount,(totalSells-sellsUsed))
			if sellsUsed>=totalSells then
				ZO_Alert(UI_ALERT_CATEGORY_ALERT,SOUNDS.NEGATIVE_CLICK,GetString("SI_ITEMLAUNDERRESULT",ITEM_LAUNDER_RESULT_AT_LIMIT))
				break
			end
			if numFreeSlots>0 or data.stackCount<=(totalSells-sellsUsed) then
				local itemLink=GetItemLink(BAG_BACKPACK,data.slotIndex)
				local itemType=GetItemLinkItemType(itemLink)
				if itemType~=ITEMTYPE_TOOL and itemType~=ITEMTYPE_TREASURE then
					LaunderItem(BAG_BACKPACK,data.slotIndex,qtyToLaunder)
					if SavedVars.DetailedBank then
						local itemIcon=GetItemLinkInfo(itemLink)
						d(zo_strformat(Localisation[lang].Laundered,itemIcon,itemLink,qtyToLaunder,data.launderPrice*qtyToLaunder))
					end
					transactions=transactions+1
					count=count+qtyToLaunder
					total=total+data.launderPrice*qtyToLaunder
				end
			end
		end
	end
	if total>0 then
		local text=zo_strformat(Localisation[lang].LaunderedTotal,count,total)
		ZO_Alert(UI_ALERT_CATEGORY_ALERT, nil, text)
		if SavedVars.ChatOutput then d(text) end
	end
end

local function OnSlotUpdate(_,bagId,slotId,isNewItem)
	if not isNewItem then return end
	if BanditsLootManagerInProgress then return end
	if IsUnderArrest() then return end
	if IsItemProtected(bagId,slotId) then return end
	if Roomba and Roomba.WorkInProgress and Roomba.WorkInProgress() then return end
	if BankManagerRevived_inProgress and BankManagerRevived_inProgress() then return end

	local _,stackCount,sellPrice,_,locked,equipType,itemStyle,quality=GetItemInfo(bagId,slotId)
	if stackCount<1 or quality==ITEM_QUALITY_LEGENDARY or locked then return end

	local itemLink=GetItemLink(bagId,slotId)
	local itemId=GetItemId(bagId,slotId)
	if ignoreList[itemId] or ignoreId==itemId then ignoreId=nil return end
	if IsItemLinkCrafted(itemLink) then return end
	if CustomJunk[itemId]~=nil then
		if CustomJunk[itemId] then ignoreId=itemId SetItemIsJunk(bagId,slotId,true) end
		return
	end

	local function HandleItem(param)
		local var=SavedVars[param]
		if Destroy[itemId] or (var[3] and (not var[1] or (var[1] and quality<=var[1])) and (not var[2] or (var[2] and sellPrice<=var[2]))) then
			if SavedVars.DetailedLoot then
				local itemIcon=GetItemLinkInfo(itemLink)
				d(zo_strformat(Localisation[lang].Destroy,itemIcon,itemLink,param))
			end
			DestroyItem(bagId,slotId)
		elseif var[4] and (not var[1] or (var[1] and quality<=var[1])) and CustomJunk[itemId]~=false then
			ignoreId=itemId SetItemIsJunk(bagId,slotId,true)
		end
	end

	local param=nil
	local itemType,specializedItemType=GetItemLinkItemType(itemLink)
	if SavedVars.MonsterParts and MonsterParts[itemId] then param="Items"
	elseif SavedVars.TrashItems and (itemType==ITEMTYPE_TRASH or itemType==ITEMTYPE_TREASURE) then param="Items"
	elseif IsItemLinkStolen(itemLink) and (itemType==ITEMTYPE_TREASURE or itemType==ITEMTYPE_ARMOR or itemType==ITEMTYPE_WEAPON) then param="Stolen"
	elseif itemType==ITEMTYPE_STYLE_MATERIAL and IsCommonStyle[itemStyle] then param="StyleMaterial"
	elseif itemType==ITEMTYPE_ARMOR_TRAIT or itemType==ITEMTYPE_WEAPON_TRAIT then param="TraitMaterial"
	elseif ((itemType==ITEMTYPE_POTION and (GetItemLinkRequiredChampionPoints(itemLink) or 0)<150) or itemType==ITEMTYPE_POISON) and not IsItemBound(bagId,slotId) then param="Potions"
	elseif itemType==ITEMTYPE_POISON_BASE then ignoreId=itemId SetItemIsJunk(bagId,slotId,true) return
	elseif itemType==ITEMTYPE_ARMOR or itemType==ITEMTYPE_WEAPON then
		local isSet=GetItemLinkSetInfo(itemLink,false)
		local trait=GetItemTrait(bagId,slotId)
		if trait==ITEM_TRAIT_TYPE_ARMOR_NIRNHONED or trait==ITEM_TRAIT_TYPE_WEAPON_NIRNHONED then return
		elseif trait==ITEM_TRAIT_TYPE_WEAPON_ORNATE or trait==ITEM_TRAIT_TYPE_ARMOR_ORNATE or trait==ITEM_TRAIT_TYPE_JEWELRY_ORNATE then param=SavedVars.Ornate and "Items" or nil
		elseif trait==ITEM_TRAIT_TYPE_WEAPON_INTRICATE or trait==ITEM_TRAIT_TYPE_ARMOR_INTRICATE then param=SavedVars.Intricate and "Items" or nil
		elseif isSet then param=SavedVars.SetItems and "Items" or nil
		elseif equipType==EQUIP_TYPE_NECK or equipType==EQUIP_TYPE_RING then param="Jewelry"
		elseif not SavedVars.RareStyleEquip and not IsCommonStyle[itemStyle] then return
		else param="Items"
		end
	elseif itemType==ITEMTYPE_LURE then param=SavedVars.FishingLure and "Items" or nil
	elseif itemType==ITEMTYPE_RECIPE and isRecipe[specializedItemType] then param=IsItemLinkRecipeKnown(itemLink) and "RecipeKnown" or "RecipeUnknown"
	elseif itemType==ITEMTYPE_COLLECTIBLE and specializedItemType==SPECIALIZED_ITEMTYPE_COLLECTIBLE_MONSTER_TROPHY or specializedItemType==SPECIALIZED_ITEMTYPE_COLLECTIBLE_RARE_FISH then
		ignoreId=itemId SetItemIsJunk(bagId,slotId,true) return
	elseif itemType==ITEMTYPE_INGREDIENT then param="Ingridient"
	elseif itemType==ITEMTYPE_FOOD or itemType==ITEMTYPE_DRINK then param="Food"
	elseif itemType==ITEMTYPE_BLACKSMITHING_BOOSTER or itemType==ITEMTYPE_CLOTHIER_BOOSTER or itemType==ITEMTYPE_WOODWORKING_BOOSTER then param="CraftingBooster"
	elseif itemType==ITEMTYPE_GLYPH_ARMOR or itemType==ITEMTYPE_GLYPH_JEWELRY or itemType==ITEMTYPE_GLYPH_WEAPON then param="Glyph"
	elseif itemType==ITEMTYPE_ENCHANTING_RUNE_ESSENCE or itemType==ITEMTYPE_ENCHANTING_RUNE_POTENCY then param="Rune"
	elseif itemType==ITEMTYPE_ENCHANTING_RUNE_ASPECT then param="Aspect"
	elseif itemType==ITEMTYPE_RACIAL_STYLE_MOTIF then param=IsItemLinkBookKnown(itemLink) and "StyleKnown" or "StyleUnknown"
	elseif (itemType==ITEMTYPE_BLACKSMITHING_MATERIAL or itemType==ITEMTYPE_CLOTHIER_MATERIAL or itemType==ITEMTYPE_WOODWORKING_MATERIAL) and not IsHihgMaterial[itemId] then param="LowMaterial"
	end
	if param then HandleItem(param) end
end

local function OnOpenFence()
	if not AreAnyItemsStolen(BAG_BACKPACK) then return end
	local delay=0
	if SavedVars.Sell and HasAnyJunk(BAG_BACKPACK) then delay=500 SellJunkItems(true) end
	if SavedVars.Launder then zo_callLater(LaunderItems,delay) end
end

local function RescanInventory()
	for slotIndex,data in pairs(SHARED_INVENTORY.bagCache[BAG_BACKPACK]) do
		if not data.isJunk then OnSlotUpdate(nil,BAG_BACKPACK,slotIndex,true) end
	end
end

local function Inventory_Init()
	local hoveredBagId
	local hoveredSlotId
	local Keybinds
	local hoveredItemCanBeJunked
	local hoveredItemCanBeDestroyed
	local isItemJunk
	local descriptorName=GetString(SI_ITEM_ACTION_MARK_AS_JUNK)

	local function OnSlotMouseEnter(inventorySlot)
		if inventorySlot and inventorySlot.dataEntry then
			hoveredBagId=inventorySlot.dataEntry.data.bagId
			hoveredSlotId=inventorySlot.dataEntry.data.slotIndex
			if hoveredBagId and hoveredSlotId and hoveredBagId==BAG_BACKPACK and not IsItemProtected(hoveredBagId,hoveredSlotId) then
				hoveredItemCanBeDestroyed=true
				if CanItemBeJunk(hoveredBagId,hoveredSlotId) then
					hoveredItemCanBeJunked=true
					isItemJunk=IsItemJunk(hoveredBagId,hoveredSlotId)
				end
				KEYBIND_STRIP:UpdateKeybindButtonGroup(Keybinds)
			end
		end
	end

	local function OnSlotMouseExit()
		hoveredBagId=nil
		hoveredSlotId=nil
		hoveredItemCanBeJunked=false
		hoveredItemCanBeDestroyed=false
		isItemJunk=false
		KEYBIND_STRIP:UpdateKeybindButtonGroup(Keybinds)
	end

	local function JunkHoveredItem()
		if hoveredItemCanBeJunked then
			SetItemIsJunk(hoveredBagId,hoveredSlotId,not isItemJunk)
		end
	end

	local function DestroyHoveredItem()
		if CanHoveredItemBeDestroyed() then
			DestroyItem(hoveredBagId,hoveredSlotId)
		end
	end

	local function UpdateAndDisplayJunkKeybind()
		if isItemJunk then
			descriptorName=GetString(SI_ITEM_ACTION_UNMARK_AS_JUNK)
		else
			descriptorName=GetString(SI_ITEM_ACTION_MARK_AS_JUNK)
		end
		return hoveredItemCanBeJunked
	end

	ZO_PreHook("ZO_InventorySlot_OnMouseEnter",OnSlotMouseEnter)
	ZO_PreHook("ZO_InventorySlot_OnMouseExit",OnSlotMouseExit)
	ZO_CreateStringId("SI_BINDING_NAME_LOOTMANAGER_JUNK",descriptorName)
	ZO_CreateStringId("SI_BINDING_NAME_LOOTMANAGER_DESTROY",GetString(SI_ITEM_ACTION_DESTROY))
	Keybinds=
	{
		alignment=KEYBIND_STRIP_ALIGN_CENTER,
		{
			name=GetString(SI_ITEM_ACTION_DESTROY),
			keybind="LOOTMANAGER_DESTROY",
			callback=DestroyHoveredItem,
			visible=hoveredItemCanBeDestroyed,
		},
		{
			name=function() return descriptorName end,
			keybind="LOOTMANAGER_JUNK",-- UI_SHORTCUT_NEGATIVE cannot be used
			callback=JunkHoveredItem,
			visible=UpdateAndDisplayJunkKeybind,
		},
	}
	
	local function OnStateChanged(oldState,newState)
		if newState==SCENE_SHOWING then
			KEYBIND_STRIP:AddKeybindButtonGroup(Keybinds)
		elseif newState==SCENE_HIDDEN then
			KEYBIND_STRIP:RemoveKeybindButtonGroup(Keybinds)
		end
	end
	
	INVENTORY_FRAGMENT:RegisterCallback("StateChange",OnStateChanged)

end
--Menu
local function Menu_Init()
	local Menu,LAMb=nil,true
	if LibStub then
		Menu=LibStub("LibAddonMenu-b",true)
		if not Menu then
			LAMb=false
			Menu=LibStub("LibAddonMenu-2.0",true)
			if not Menu then return end
		end
	else return end
	local Panel={
		type="panel",
		name=(LAMb and "19. |t32:32:/esoui/art/inventory/inventory_tabicon_junk_up.dds|t" or "Bandits ").."Loot Manager",
		displayName=(LAMb and "19. " or "").."|c4B8BFEBandits|r Loot Manager",
		author="|c4B8BFEHoft|r",
		version=tostring(VERSION)..(VERSION%1==0 and ".0" or ""),
		}
	Menu:RegisterAddonPanel("BUI_LootManager_Menu",Panel)

	local container=WINDOW_MANAGER:CreateControlFromVirtual("LootManager_MenuContainer", BUI_LootManager_Menu, "ZO_ScrollContainer")
	container:SetAnchor(TOPLEFT, BUI_LootManager_Menu, TOPLEFT, 0, 50)
	container:SetAnchor(BOTTOMRIGHT, BUI_LootManager_Menu, BOTTOMRIGHT, 0, 0)
	BUI_LootManager_Menu.scroll=GetControl(container, "ScrollChild")
	BUI_LootManager_Menu.scroll:SetResizeToFitPadding(0, 0)
	local scroll=BUI_LootManager_Menu.scroll
	local w,h=BUI_LootManager_Menu:GetWidth(),26
	local h1=h+5
	local on,off='/esoui/art/cadwell/checkboxicon_checked.dds','/esoui/art/cadwell/checkboxicon_unchecked.dds'
	scroll.button={} scroll.combobox={} scroll.editbox={} scroll.switch={} scroll.icon={}
	--Import
	local function MenuUpdate()
		for _,data in pairs(scroll.button) do
			data.control:SetTexture((type(data.var)=="table" and SavedVars[data.var[1]][data.var[2]] or SavedVars[data.var]) and on or off)
		end
		for _,data in pairs(scroll.combobox) do
			data.control:SelectItemByIndex(SavedVars[data.var][1], true)
		end
		for _,data in pairs(scroll.editbox) do
			data.control:SetText(SavedVars[data.var][2])
		end
		for _,data in pairs(scroll.icon) do
			data.control:SetColor(unpack(SavedVars[data.var] and {1,1,1,1} or {1,.5,.5,1}))
		end
	end

	local AccName,PlayerName,Characters=GetDisplayName(),GetUnitName("player"),{}
	if BLM_SavedVars and BLM_SavedVars.Default and BLM_SavedVars.Default[AccName] then
		for name, data in pairs(BLM_SavedVars.Default[AccName]) do
			if name~=PlayerName then
				table.insert(Characters, name)
			end
		end
	end

	local control=WINDOW_MANAGER:CreateControlFromVirtual("$(parent)ComboBox_Import", scroll, "ZO_ComboBox")
	control:SetDimensions(120, 28)
	control:SetAnchor(TOPLEFT,scroll,TOPLEFT,w-180,0)
	local comboBox=control.m_comboBox
	comboBox:SetSortsItems(false)
	comboBox:ClearItems()
	for i, name in pairs(Characters) do
		local entry=ZO_ComboBox:CreateItemEntry(name, function()
			if name and name~="" then
				JoinTables(SavedVars,BLM_SavedVars.Default[AccName][name])
				MenuUpdate()
			end
		end)
		entry.id=i
		comboBox:AddItem(entry, ZO_COMBOBOX_SUPRESS_UPDATE)
	end
	comboBox:SelectItemByIndex(1, true)
	comboBox:SetFont("ZoFontGame")
	control.la=WINDOW_MANAGER:CreateControl(nil, control, CT_LABEL)
	control.la:SetDimensions(60,h)
	control.la:SetAnchor(TOPRIGHT,control,TOPLEFT,-3,0)
	control.la:SetFont("ZoFontHeader")
	control.la:SetColor(1,1,1,1)
	control.la:SetHorizontalAlignment(2)
	control.la:SetVerticalAlignment(1)
	control.la:SetText("Import")
	--Rescan
	button=WINDOW_MANAGER:CreateControlFromVirtual(nil, control, "ZO_DefaultButton")
	button:SetWidth(120, 28)
	button:SetText(Localisation[lang].Rescan.entry)
	button:SetAnchor(TOPLEFT,scroll,TOPLEFT,w-180,h1*2)
	button:SetClickSound("Click")
	button.data={tooltipText=Localisation[lang].Rescan.tooltip}
	button:SetHandler("OnClicked", RescanInventory)

	--Menu settings
	for i,data in ipairs(MenuSettings) do
		local param=data.param
		if data.header then
			local backdrop=WINDOW_MANAGER:CreateControl("$(parent)Bg"..i, scroll, CT_BACKDROP)
			backdrop:SetDimensions(w-20,h)
			backdrop:SetAnchor(TOPLEFT,scroll,TOPLEFT,0,h1*(i-1))
			backdrop:SetCenterColor(.4,.4,.4,.3)
			backdrop:SetEdgeColor(0,0,0,0)
			backdrop:SetEdgeTexture("",8,2,2)

			local label=WINDOW_MANAGER:CreateControl("$(parent)Header"..i, scroll, CT_LABEL)
			label:SetDimensions(w,h)
			label:SetAnchor(TOPLEFT,scroll,TOPLEFT,0,h1*(i-1))
			label:SetFont("ZoFontHeader")
			label:SetColor(.8,.8,.6,1)
			label:SetHorizontalAlignment(1)
			label:SetVerticalAlignment(1)
			label:SetModifyTextType(MODIFY_TEXT_TYPE_UPPERCASE)
			label:SetText(Localisation[lang][param].entry)
		else
			if data.filters then
				--Filters
				local f=0
				for filter,data in pairs (ItemFilters[data.filters]) do
					local control=WINDOW_MANAGER:CreateControl("$(parent)Icon"..#scroll.icon+1, scroll, CT_CONTROL)
					control:SetDimensions(h, h)
					control:SetAnchor(TOPLEFT,scroll,TOPLEFT,h*f,h1*(i-1))
					control.icon=WINDOW_MANAGER:CreateControl(nil, control, CT_TEXTURE)
					control.icon:SetDimensions(h, h)
					control.icon:SetAnchor(CENTER,control,CENTER,0,0)
					control.icon:SetTexture(data.icon)
					control.icon:SetColor(unpack(SavedVars[filter] and {1,1,1,1} or {.3,.3,.2,1}))
					control:SetMouseEnabled(true)
					control:SetHandler("OnMouseDown", function(self)
						SavedVars[filter]=not SavedVars[filter]
						self.icon:SetColor(unpack(SavedVars[filter] and {1,1,1,1} or {.3,.3,.2,1}))
					end)
					control:SetHandler("OnMouseEnter", function(self)
						self.icon:SetDimensions(h*1.3, h*1.3)
						ZO_Tooltips_ShowTextTooltip(self,BOTTOM,(SavedVars[filter] and GetString(SI_CHECK_BUTTON_ON) or GetString(SI_CHECK_BUTTON_OFF))..": "..Localisation[lang][filter].entry)
					end)
					control:SetHandler("OnMouseExit", function(self)
						self.icon:SetDimensions(h, h)
						ZO_Tooltips_HideTextTooltip()
					end)
					scroll.icon[#scroll.icon+1]={control=control.icon,var=filter}
					f=f+1
				end
			else
				--Label
				local label=WINDOW_MANAGER:CreateControl("$(parent)Label"..i, scroll, CT_LABEL)
				label:SetDimensions(210,h)
				label:SetAnchor(TOPLEFT,scroll,TOPLEFT,0,h1*(i-1))
				label:SetFont("ZoFontHeader")
				label:SetColor(1,1,1,1)
				label:SetHorizontalAlignment(0)
				label:SetVerticalAlignment(1)
				label:SetText(zo_iconFormat(data.icon,h,h).." "..(Localisation[lang][param].entry or param))
				if Localisation[lang][param].tooltip then
					label:SetMouseEnabled(true)
					label:SetHandler("OnMouseEnter", function(self) ZO_Tooltips_ShowTextTooltip(self, BOTTOM, Localisation[lang][param].tooltip) end)
					label:SetHandler("OnMouseExit", ZO_Tooltips_HideTextTooltip)
				end
			end
			if type(Default[param])=="boolean" then
				local button=WINDOW_MANAGER:CreateControl("$(parent)Button"..#scroll.button+1, scroll, CT_TEXTURE)
				button:SetDimensions(h, h)
				button:SetAnchor(TOPLEFT,scroll,TOPLEFT,220,h1*(i-1))
				button:SetTexture(SavedVars[param] and on or off)
				button:SetColor(.6,.57,.46,1)
				button:SetMouseEnabled(true)
				button:SetHandler("OnMouseDown", function(self) SavedVars[param]=not SavedVars[param] self:SetTexture(SavedVars[param] and on or off)end)
				if Localisation[lang][param][1] then
					button:SetHandler("OnMouseEnter", function(self) ZO_Tooltips_ShowTextTooltip(self,BOTTOM,Localisation[lang][param][1]) self:SetColor(.9,.9,.8,1)end)
					button:SetHandler("OnMouseExit",  function(self)ZO_Tooltips_HideTextTooltip() self:SetColor(.6,.57,.46,1)end)
				end
				scroll.button[#scroll.button+1]={control=button,var=param}
				if param=="ChatOutput" then
					local button=WINDOW_MANAGER:CreateControl("$(parent)Button"..#scroll.button+1, scroll, CT_TEXTURE)
					button:SetDimensions(h, h)
					button:SetAnchor(TOPLEFT,scroll,TOPLEFT,220+30,h1*(i-1))
					button:SetTexture(SavedVars.DetailedBank and on or off)
					button:SetColor(.6,.57,.46,1)
					button:SetMouseEnabled(true)
					button:SetHandler("OnMouseDown", function(self) SavedVars.DetailedBank=not SavedVars.DetailedBank self:SetTexture(SavedVars.DetailedBank and on or off)end)
					button:SetHandler("OnMouseEnter", function(self) ZO_Tooltips_ShowTextTooltip(self,BOTTOM,Localisation[lang][param][2]) end)
					button:SetHandler("OnMouseExit", ZO_Tooltips_HideTextTooltip)
					scroll.button[#scroll.button+1]={control=button,var="DetailedBank"}
					local button=WINDOW_MANAGER:CreateControl("$(parent)Button"..#scroll.button+1, scroll, CT_TEXTURE)
					button:SetDimensions(h, h)
					button:SetAnchor(TOPLEFT,scroll,TOPLEFT,220+60,h1*(i-1))
					button:SetTexture(SavedVars.DetailedLoot and on or off)
					button:SetColor(.6,.57,.46,1)
					button:SetMouseEnabled(true)
					button:SetHandler("OnMouseDown", function(self) SavedVars.DetailedLoot=not SavedVars.DetailedLoot self:SetTexture(SavedVars.DetailedLoot and on or off)end)
					button:SetHandler("OnMouseEnter", function(self)ZO_Tooltips_ShowTextTooltip(self,BOTTOM,Localisation[lang][param][3]) self:SetColor(.9,.9,.8,1)end)
					button:SetHandler("OnMouseExit",  function(self)ZO_Tooltips_HideTextTooltip() self:SetColor(.6,.57,.46,1)end)
					scroll.button[#scroll.button+1]={control=button,var="DetailedLoot"}
				end
			else
				--Checkboxes
				scroll.switch[i]={}
				for b=3,6 do
					if Default[param][b]~=nil then
					local button=WINDOW_MANAGER:CreateControl("$(parent)Button"..#scroll.button+1, scroll, CT_TEXTURE)
					button:SetDimensions(h, h)
					button:SetAnchor(TOPLEFT,scroll,TOPLEFT,220+(b-3)*30,h1*(i-1))
					button:SetTexture(SavedVars[param][b] and on or off)
					button:SetColor(.6,.57,.46,1)
					button:SetMouseEnabled(true)
					button:SetHandler("OnMouseDown", function(self)
						SavedVars[param][b]=not SavedVars[param][b] self:SetTexture(SavedVars[param][b] and on or off)
						if data.switch then
							if b==5 and SavedVars[param][6] then
								SavedVars[param][6]=not SavedVars[param][5] scroll.switch[i][6]:SetTexture(SavedVars[param][6] and on or off)
							elseif b==6 and SavedVars[param][5] then
								SavedVars[param][5]=not SavedVars[param][6] scroll.switch[i][5]:SetTexture(SavedVars[param][5] and on or off)
							end
						end
					end)
					button:SetHandler("OnMouseEnter", function(self)
						self:SetColor(.9,.9,.8,1)
						ZO_Tooltips_ShowTextTooltip(self,BOTTOM,zo_strformat(Localisation[lang].Tooltip[b]..((b<5 and Default[param][1]) and Localisation[lang].Tooltip[7] or "")..((b==3 and Default[param][2]) and Localisation[lang].Tooltip[8] or "")..((Localisation[lang][param] and Localisation[lang][param][b]) or ""),ItemQuality[SavedVars[param][1]],SavedVars[param][2]))
					end)
					button:SetHandler("OnMouseExit",  function(self)ZO_Tooltips_HideTextTooltip() self:SetColor(.6,.57,.46,1)end)
					scroll.button[#scroll.button+1]={control=button,var={param,b}}
					scroll.switch[i][b]=button
					end
				end
				--Quality
				if Default[param][1]~=nil then
					local control=WINDOW_MANAGER:CreateControlFromVirtual("$(parent)ComboBox"..i, scroll, "ZO_ComboBox")
					control:SetDimensions(90, 28)
					control:SetAnchor(TOPLEFT,scroll,TOPLEFT,360,h1*(i-1))
					local comboBox=control.m_comboBox
					comboBox:SetSortsItems(false)
					comboBox:ClearItems()
					for i, v in pairs(ItemQuality) do
						local entry=ZO_ComboBox:CreateItemEntry(v, function() SavedVars[param][1]=i end)
						entry.id=i
						comboBox:AddItem(entry, ZO_COMBOBOX_SUPRESS_UPDATE)
					end
					comboBox:SelectItemByIndex(SavedVars[param][1], true)
					comboBox:SetFont("ZoFontGame")
					scroll.combobox[#scroll.combobox+1]={control=comboBox,var=param}
					control.la=WINDOW_MANAGER:CreateControl("$(parent)Mark1_"..i, control, CT_LABEL)
					control.la:SetDimensions(20,h)
					control.la:SetAnchor(TOPRIGHT,control,TOPLEFT,-3,0)
					control.la:SetFont("ZoFontGame")
					control.la:SetColor(.6,.6,.4,1)
					control.la:SetHorizontalAlignment(2)
					control.la:SetVerticalAlignment(1)
					control.la:SetText("<=")
				end
				--Price
				if Default[param][2]~=nil then
					local control=WINDOW_MANAGER:CreateControl("$(parent)EditBox"..i, scroll, CT_EDITBOX)
					control.bg=WINDOW_MANAGER:CreateControlFromVirtual(nil, control, "ZO_EditBackdrop_Gamepad")
					control.eb=WINDOW_MANAGER:CreateControlFromVirtual(nil, control, "ZO_DefaultEditForBackdrop")
					control:ClearAnchors()
					control:SetAnchor(TOPLEFT,scroll,TOPLEFT,520,h1*(i-1))
					control:SetAnchor(BOTTOMRIGHT, scroll, TOPLEFT, 520+60, h1*(i-1)+h)
					control.bg:SetAnchorFill()
					control.eb:ClearAnchors()
					control.eb:SetAnchorFill()
					control.eb:SetMaxInputChars(6)
					control.eb:SetHandler("OnEnter", function(self) self:LoseFocus() SavedVars[param][2]=tonumber(self:GetText()) end)
					control.eb:SetHandler("OnFocusLost", function(self) self:LoseFocus() SavedVars[param][2]=tonumber(self:GetText()) end)
					control.eb:SetFont("ZoFontGame")
					control.eb:SetText(SavedVars[param][2])
					scroll.editbox[#scroll.editbox+1]={control=control.eb,var=param}
					if not data.count then
						control.la=WINDOW_MANAGER:CreateControl("$(parent)Mark2_"..i, control, CT_LABEL)
						control.la:SetDimensions(60,h)
						control.la:SetAnchor(TOPRIGHT,control,TOPLEFT,-3,0)
						control.la:SetFont("ZoFontGame")
						control.la:SetColor(.6,.6,.4,1)
						control.la:SetHorizontalAlignment(2)
						control.la:SetVerticalAlignment(1)
						control.la:SetText(Localisation[lang].Tooltip[2])
					end
				end
			end
		end
	end
end

local function OnLoad(_,name)
	if name~=ADDON_NAME then return true end
	SavedVars=ZO_SavedVars:New("BLM_SavedVars",1,nil,Default)
	CustomJunk=ZO_SavedVars:NewAccountWide("BLM_SavedJunk",1,nil,{})
	Menu_Init()
	Bank_Init()
--	Inventory_Init()

	local SetItemIsJunkOrig=SetItemIsJunk
	SetItemIsJunk=function(bagId,slotId,junk,...)
		if junk and IsItemProtected(bagId,slotId) then junk=false
		else
			local itemId=GetItemId(bagId,slotId) if itemId and ignoreId~=itemId then CustomJunk[itemId]=junk end
			if SavedVars.DetailedLoot then
				local itemLink=GetItemLink(bagId,slotId)
				local itemIcon=GetItemLinkInfo(itemLink)
				d(zo_strformat(Localisation[lang].Junk,itemIcon,itemLink)..(ignoreId~=itemId and (junk and " (mark)" or " (unmark)") or ""))
			end
		end
		SetItemIsJunkOrig(bagId,slotId,junk,...)
	end

	ZO_PreHook("SellAllJunk",function() SellJunkItems(false) end)
	ESO_Dialogs["SELL_ALL_JUNK"]={
		title={text=SI_PROMPT_TITLE_SELL_ITEMS},
		mainText={text=SI_SELL_ALL_JUNK},
		buttons={
			[1]={text=SI_SELL_ALL_JUNK_CONFIRM,callback=SellAllJunk},
			[2]={text=SI_DIALOG_DECLINE}
		}
	}

	EVENT_MANAGER:RegisterForEvent(ADDON_NAME,EVENT_OPEN_STORE,function()SellJunkItems(false)end)
	EVENT_MANAGER:RegisterForEvent(ADDON_NAME,EVENT_OPEN_FENCE,OnOpenFence)
	EVENT_MANAGER:RegisterForEvent(ADDON_NAME,EVENT_INVENTORY_SINGLE_SLOT_UPDATE,OnSlotUpdate)
	EVENT_MANAGER:AddFilterForEvent(ADDON_NAME,EVENT_INVENTORY_SINGLE_SLOT_UPDATE,REGISTER_FILTER_BAG_ID,BAG_BACKPACK)
	EVENT_MANAGER:AddFilterForEvent(ADDON_NAME,EVENT_INVENTORY_SINGLE_SLOT_UPDATE,REGISTER_FILTER_INVENTORY_UPDATE_REASON,INVENTORY_UPDATE_REASON_DEFAULT)
	EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_OPEN_BANK, onOpenBank)
	EVENT_MANAGER:UnregisterForEvent(ADDON_NAME,EVENT_ADD_ON_LOADED)
end

EVENT_MANAGER:RegisterForEvent(ADDON_NAME,EVENT_ADD_ON_LOADED,OnLoad)
