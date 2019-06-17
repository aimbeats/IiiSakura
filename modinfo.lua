name = "IiiSkura"
description = "我想守护的人都已不在"
author = "hongjiu"
version = "1.0"
forumthread = ""

api_version = 10
dst_compatible = true --联机版兼容
dont_starve_compatible = false --单机版兼容
reign_of_giants_compatible = false --巨人统治兼容
all_clients_require_mod = true  --所有玩家是否需要这个mod

icon_atlas = "modicon.xml" --图片xml解析
icon = "modicon.tex" --mod图片

-- server_filter_tags = {
-- 	"character",
-- }

local alpha = 
{
    {description = "B", key = 98},
    {description = "C", key = 99},
    {description = "G", key = 103},
    {description = "J", key = 106},
    {description = "R", key = 114},
    {description = "T", key = 116},
    {description = "V", key = 118},
    {description = "X", key = 120},
    {description = "Z", key = 122},
    {description = "LAlt", key = 308},
    {description = "LCtrl", key = 306},
    {description = "LShift", key = 304},
    {description = "Space", key = 32},
}
local keyslist = {}
for i = 1,#alpha do keyslist[i] = {description = alpha[i].description, data = alpha[i].key} end
--配置选项范例
configuration_options = {
    {
        name = "windPressureKey",
        label = "风压",
        options = keyslist,
        default = 122,
    },
    {
        name = "dodgeKey",
        label = "雾鸦·雷鸣",
        options = keyslist,
        default = 120,
    },
    {
        name = "topspeedKey",
        label = "雷动",
        options = keyslist,
        default = 99,
    },
    {
        name = "skillKey",
        label = "瞬剑·繁华落尽",
        options = keyslist,
        default = 118,
    },
    {
        name = "checkKey",
        label = "自我检查按键",
        options = keyslist,
        default = 114
    }
}
-- {
--     name = "language",
--     label = "language",
--     options = 
--         {
            
--             {description = "Auto", data = 1},
--             {description = "English", data = 2},
--             {description = "中文", data = 3},
--         },
--         default = 1,
--     },
-- }