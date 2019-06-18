--预制件的列表，所有东西都要在这里注册
PrefabFiles = {
"iiisakura",--三世樱
-- "fox_mask"--狐狸面具
-- "rock_dachi",--石刀
"stealth_dachi",--无影剑
"dawn_dachi",--破晓
-- "nightmare_dachi",--梦魇
"thorne_dachi",--荆棘
-- "demon_blade",--妖刀·千盏繁华
"rock_shovel",--多功能石铲
-- "gold_shovel",--多功能金铲
-- "tm_shovel"--多功能铥铲
"nuclear_silo",--核弹发射井
-- "nuclear_bomb",--蘑菇弹
"laser_pointer",--激光指示器
"hit_marks",--锁定打击
}
--这里存放该mod所需要的所有动画文件和图片，需要把所有的图片和xml文件存放在这里
Assets = {
	--还不知道是什么图
	Asset( "IMAGE", "images/saveslot_portraits/iiisakura.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/iiisakura.xml" ),
	--选择人物时的肖像
	Asset( "IMAGE", "images/selectscreen_portraits/iiisakura.tex" ),
	Asset( "ATLAS", "images/selectscreen_portraits/iiisakura.xml" ),
	--“silho”文件只是锁定角色时所选择的屏幕图像的一幅被涂黑的图像
	Asset( "IMAGE", "images/selectscreen_portraits/iiisakura_silho.tex" ),
	Asset( "ATLAS", "images/selectscreen_portraits/iiisakura_silho.xml" ),
	--人物大图
	Asset( "IMAGE", "bigportraits/iiisakura.tex" ),
	Asset( "ATLAS", "bigportraits/iiisakura.xml" ),
	--自定义的小地图图标
	Asset( "IMAGE", "images/map_icons/iiisakura.tex" ),
	Asset( "ATLAS", "images/map_icons/iiisakura.xml" ),
	--化身？
	Asset( "IMAGE", "images/avatars/avatar_iiisakura.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_iiisakura.xml" ),
	--幽灵形态
	Asset( "IMAGE", "images/avatars/avatar_ghost_iiisakura.tex" ),
	Asset( "ATLAS", "images/avatars/avatar_ghost_iiisakura.xml" ),
	--库存图片
	--狐狸面具
	Asset( "IMAGE", "images/inventoryimages/fox_mask.tex" ),
	Asset( "ATLAS", "images/inventoryimages/fox_mask.xml" ),
	--石刀
	Asset( "IMAGE", "images/inventoryimages/rock_dachi.tex" ),
	Asset( "ATLAS", "images/inventoryimages/rock_dachi.xml" ),
	--无形
	Asset( "IMAGE", "images/inventoryimages/stealth_dachi.tex" ),
	Asset( "ATLAS", "images/inventoryimages/stealth_dachi.xml" ),
	--梦魇
	Asset( "IMAGE", "images/inventoryimages/nightmare_dachi.tex" ),
	Asset( "ATLAS", "images/inventoryimages/nightmare_dachi.xml" ),
	--荆棘
	Asset( "IMAGE", "images/inventoryimages/thorne_dachi.tex" ),
	Asset( "ATLAS", "images/inventoryimages/thorne_dachi.xml" ),
	--破晓
	Asset( "IMAGE", "images/inventoryimages/dawn_dachi.tex" ),
	Asset( "ATLAS", "images/inventoryimages/dawn_dachi.xml" ),
	--妖刀·千盏繁华
	Asset( "IMAGE", "images/inventoryimages/demon_blade.tex" ),
	Asset( "ATLAS", "images/inventoryimages/demon_blade.xml" ),
	--多功能石铲
	Asset( "IMAGE", "images/inventoryimages/rock_shovel.tex" ),
	Asset( "ATLAS", "images/inventoryimages/rock_shovel.xml" ),
	--多功能金铲
	Asset( "IMAGE", "images/inventoryimages/gold_shovel.tex" ),
	Asset( "ATLAS", "images/inventoryimages/gold_shovel.xml" ),
	--多功能铥铲
	Asset( "IMAGE", "images/inventoryimages/tm_shovel.tex" ),
	Asset( "ATLAS", "images/inventoryimages/tm_shovel.xml" ),
	--核弹发射井
	Asset( "IMAGE", "images/inventoryimages/nuclear_silo.tex" ),
	Asset( "ATLAS", "images/inventoryimages/nuclear_silo.xml" ),
	--蘑菇弹
	Asset( "IMAGE", "images/inventoryimages/nuclear_bomb.tex" ),
	Asset( "ATLAS", "images/inventoryimages/nuclear_bomb.xml" ),
	--激光指示器
	Asset( "IMAGE", "images/inventoryimages/laser_pointer.tex" ),
	Asset( "ATLAS", "images/inventoryimages/laser_pointer.xml" ),
}

local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS
local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local TECH = GLOBAL.TECH

modimport("scripts/sakura_util/sakura_util.lua")
TUNING.windPressureKey = GetModConfigData('windPressureKey')
TUNING.dodgeKey = GetModConfigData('dodgeKey')
TUNING.topspeedKey = GetModConfigData('topspeedKey')
TUNING.skillKey = GetModConfigData('skillKey')
TUNING.checkKey = GetModConfigData('checkKey')

--这里告诉游戏添加小地图图标
AddMinimapAtlas("images/map_icons/iiisakura.xml")
--加载台词
STRINGS.CHARACTERS.TSUI_RABBIT = require "speech_iiisakura"
--制作物品时的配方和图片
-- 第一个参数，prefab的名字。
-- 第二个参数，配方表，用{}框起来，里面每一项配方用一个Ingredient。Ingredient的第一个参数是具体的prefab名，第二个是数量
-- 第三个参数，装备的归类，RECIPETABS.SURVIVAL表明归类到生存，也就是可以在生存栏里找到。
-- 第四个参数，装备需要的科技等级，TECH.NONE 表明不需要科技，随时都可以制造。
-- 后续5个参数都是nil，表明不需要这些参数，但需要占位置
-- 最后一个参数，指明图片文档地址，用于制作栏显示图片。
local marisatab = AddRecipeTab( "Marisa's Tab", 514, "images/hud/marisatab.xml", "marisatab.tex", "marisa_builder")
-- --狐狸面具：干草*5,、绳子*1、花瓣*5
-- AddRecipe("fox_mask",
-- {Ingredient("cutgrass", 5),Ingredient("rope", 1),Ingredient("petals", 5)}, RECIPETABS.WAR,
-- TECH.NONE, nil, nil, nil, nil, nil,
-- "images/inventoryimages/fox_mask.xml", "fox_mask.tex" )
-- --石刀：木板*1、石砖*1、绳子*1
-- AddRecipe("rock_dachi",
-- {Ingredient("boards", 1),Ingredient("cutstone", 1),Ingredient("rope", 1)}, RECIPETABS.WAR,
-- TECH.NONE, nil, nil, nil, nil, nil,
-- "images/inventoryimages/rock_dachi.xml", "rock_dachi.tex" )
-- --荆棘：石刀、蜂刺*5
-- AddRecipe("thorne_dachi",
-- {Ingredient("rock_dachi", 1),Ingredient("stinger", 5)}, RECIPETABS.WAR,
-- TECH.NONE, nil, nil, nil, nil, nil,
-- "images/inventoryimages/thorne_dachi.xml", "thorne_dachi.tex" )
-- --无形：石刀、噩梦燃料*5
-- AddRecipe("stealth_dachi",
-- {Ingredient("rock_dachi", 1),Ingredient("nightmarefuel", 5)}, RECIPETABS.WAR,
-- TECH.NONE, nil, nil, nil, nil, nil,
-- "images/inventoryimages/stealth_dachi.xml", "stealth_dachi.tex" )
-- --梦魇：石刀*1、噩梦花瓣*5、紫宝石*1
-- AddRecipe("nightmare_dachi",
-- {Ingredient("rock_dachi", 1),Ingredient("petals_evil", 5),Ingredient("purplegem", 1)}, RECIPETABS.WAR,
-- TECH.NONE, nil, nil, nil, nil, nil,
-- "images/inventoryimages/nightmare_dachi.xml", "nightmare_dachi.tex" )
-- --妖刀·千盏繁华：活木*8、铥矿*10、红宝石*2
-- AddRecipe("demon_blade",
-- {Ingredient("livinglog", 8),Ingredient("thulecite", 10),Ingredient("redgem", 2)}, RECIPETABS.WAR,
-- TECH.NONE, nil, nil, nil, nil, nil,
-- "images/inventoryimages/demon_blade.xml", "demon_blade.tex" )
-- --多功能石铲：燧石*5、小树枝*5
-- AddRecipe("rock_shovel",
-- {Ingredient("flint", 5),Ingredient("twigs", 5)}, RECIPETABS.WAR,
-- TECH.NONE, nil, nil, nil, nil, nil,
-- "images/inventoryimages/rock_shovel.xml", "rock_shovel.tex" )
-- --多功能金铲：金子*5、小树枝*10
-- AddRecipe("gold_shovel",
-- {Ingredient("goldnugget", 1),Ingredient("twigs", 10)}, RECIPETABS.WAR,
-- TECH.NONE, nil, nil, nil, nil, nil,
-- "images/inventoryimages/gold_shovel.xml", "gold_shovel.tex" )
-- --多功能铥铲：铥矿*10、小树枝*10
-- AddRecipe("tm_shovel",
-- {Ingredient("thulecite", 1),Ingredient("twigs", 10)}, RECIPETABS.WAR,
-- TECH.NONE, nil, nil, nil, nil, nil,
-- "images/inventoryimages/tm_shovel.xml", "tm_shovel.tex" )
--核弹发射井：石砖*20、电子元件*10、火药*5
AddRecipe("nuclear_silo",
{Ingredient("petals", 1)}, RECIPETABS.TOWN,
TECH.NONE, nil, nil, nil, nil, nil,
"images/inventoryimages/nuclear_silo.xml", "nuclear_silo.tex" )
--蘑菇弹：红蓝绿蘑菇*20
AddRecipe("nuclear_bomb",
{Ingredient("petals", 1)}, RECIPETABS.TOWN,
TECH.NONE, nil, nil, nil, nil, nil,
"images/inventoryimages/nuclear_bomb.xml", "nuclear_bomb.tex" )
--激光指示器：燧石*1、电器元件*1
AddRecipe("laser_pointer",
{Ingredient("petals", 1)}, RECIPETABS.TOWN,
TECH.NONE, nil, nil, nil, nil, nil,
"images/inventoryimages/laser_pointer.xml", "laser_pointer.tex" )


STRINGS.CHARACTERS.GENERIC.DESCRIBE.MARISA =
{
	GENERIC = "你好，八重樱",
	ATTACKER = "八重樱，现在我们是对手了！",
	MURDERER = "你的双手也会沾染无辜者的鲜血吗？",
	REVIVER = "我的救命恩人！",
	GHOST = "巫女也需要救赎",
}
--这将为游戏添加你的角色
AddModCharacter("iiisakura","FEMALE")
