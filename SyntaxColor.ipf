#pragma ModuleName=SyntaxColor
strconstant SyntaxColor_Menu="SyntaxColor"

// Menu
Menu StringFromList(0,SyntaxColor_Menu)
	RemoveListItem(0,SyntaxColor_Menu)
	SubMenu SyntaxColor#MenuTitleSetColor("keyword")
		SyntaxColor#MenuItemSetColor("keyword"),/Q,SyntaxColor#MenuCommandSetColor("keyword")
	End
	SubMenu SyntaxColor#MenuTitleSetColor("comment")
		SyntaxColor#MenuItemSetColor("comment"),/Q,SyntaxColor#MenuCommandSetColor("comment")
	End
	SubMenu SyntaxColor#MenuTitleSetColor("string")
		SyntaxColor#MenuItemSetColor("string"),/Q,SyntaxColor#MenuCommandSetColor("string")
	End
	SubMenu SyntaxColor#MenuTitleSetColor("operation")
		SyntaxColor#MenuItemSetColor("operation"),/Q,SyntaxColor#MenuCommandSetColor("operation")
	End
	SubMenu SyntaxColor#MenuTitleSetColor("function")
		SyntaxColor#MenuItemSetColor("function"),/Q,SyntaxColor#MenuCommandSetColor("function")
	End
	SubMenu SyntaxColor#MenuTitleSetColor("pound")
		SyntaxColor#MenuItemSetColor("pound"),/Q,SyntaxColor#MenuCommandSetColor("pound")
	End
	"-"
	"Save Colorscheme",/Q,SyntaxColor#SaveColorscheme()
	"-"
	SubMenu "Colorscheme"
		"Default",/Q,SyntaxColor#DefaultColorscheme()
		SelectString(strlen(SyntaxColor#MenuItemColorscheme(0)),"","-")
		SyntaxColor#MenuItemColorscheme(0),/Q
		SyntaxColor#MenuItemColorscheme(1),/Q
		SyntaxColor#MenuItemColorscheme(2),/Q
		SyntaxColor#MenuItemColorscheme(3),/Q
		SyntaxColor#MenuItemColorscheme(4),/Q
		SyntaxColor#MenuItemColorscheme(5),/Q
		SyntaxColor#MenuItemColorscheme(6),/Q
		SyntaxColor#MenuItemColorscheme(7),/Q
		SyntaxColor#MenuItemColorscheme(8),/Q
		SyntaxColor#MenuItemColorscheme(9),/Q
		SyntaxColor#MenuItemColorscheme(10),/Q
		SyntaxColor#MenuItemColorscheme(11),/Q
		SyntaxColor#MenuItemColorscheme(12),/Q
		SyntaxColor#MenuItemColorscheme(13),/Q
		SyntaxColor#MenuItemColorscheme(14),/Q
		SyntaxColor#MenuItemColorscheme(15),/Q
		SyntaxColor#MenuItemColorscheme(16),/Q
		SyntaxColor#MenuItemColorscheme(17),/Q
		SyntaxColor#MenuItemColorscheme(18),/Q
		SyntaxColor#MenuItemColorscheme(19),/Q
	End
End


// Change syntax color from the menu bar.
static Function/S MenuTitleSetColor(group)
	String group
	return group
End
static Function/S MenuItemSetColor(group)
	String group
	WAVE w=capture(group)
	String item
	sprintf item, "*COLORPOP*(%d,%d,%d)",w[0],w[1],w[2]
	return item
End
static Function MenuCommandSetColor(group)
	String group
	GetLastUserMenuInfo
	rgb16(group,V_red,V_green,V_blue)
End

// Save colorscheme as a macro
static Function SaveColorscheme()
	String cmd=""
	cmd +="Macro "+UniqueMacroName("Colorscheme")+"()"
	cmd +="\r\t"+colorschemeCommand("keyword"  )
	cmd +="\r\t"+colorschemeCommand("comment"  )
	cmd +="\r\t"+colorschemeCommand("string"   )
	cmd +="\r\t"+colorschemeCommand("operation")
	cmd +="\r\t"+colorschemeCommand("function" )
	cmd +="\r\t"+colorschemeCommand("pound"    )
	cmd +="\rEnd\r"
	Execute/P "INSERTINCLUDE dummy"+"\r"+cmd
	Execute/P "DELETEINCLUDE dummy"
	Execute/P "COMPILEPROCEDURES "
End
static Function/S colorschemeCommand(group)
	String group
	WAVE w=capture(group)
	String cmd
	print w
	sprintf cmd,"SetIgorOption colorize,%sColor=(%d,%d,%d)",group,w[0],w[1],w[2]
	return cmd
End
static Function/S UniqueMacroName(base)
	String base
	String name=base; Variable i=0
	do
		name = base+"_"+Num2Str(i)
		i += 1
	while(ItemsInList(MacroList(name,";","")))
	return name
End

// Capture the current rgb values
static Function/WAVE capture(group)
	String group
	DFREF here = GetDataFolderDFR()
	SetDataFolder NewFreeDataFolder()
	Execute/Z "SetIgorOption colorize,"+group+"Color=?"
	NVAR V_Red, V_Green, V_Blue
	Make/FREE w={V_Red,V_Green,V_Blue}
	SetDataFolder here
	return w
End

// Change colorscheme from the menu bar
static Function/S MenuItemColorscheme(i)
	Variable i
	String list=MacroList("Colorscheme_*",";","NPARAMS:0")
	if(i<ItemsInList(list))
		return StringFromList(i,list)
	else
		return ""
	endif
End
static Function DefaultColorscheme()
	Execute/Z "SetIgorOption colorize,keywordColor=(0,0,65535)"
	Execute/Z "SetIgorOption colorize,commentColor=(65535,0,0)"
	Execute/Z "SetIgorOption colorize,stringColor=(0,40000,0)"
	Execute/Z "SetIgorOption colorize,operationColor=(0,30000,30000)"
	Execute/Z "SetIgorOption colorize,functionColor=(50000,20000,0)"
	Execute/Z "SetIgorOption colorize,poundColor=(52428,1,41942)"
End

////////////////////////////////////////
// Functions for syntax color setting //
////////////////////////////////////////
// Usage
// SyntaxColor#hex  ("keyword","FFFFFF")
// SyntaxColor#rgb8 ("comment",255,255,255)
// SyntaxColor#rgb16("string" ,65535,65535,65535)
//
// the first argument is syntax group:
// keyword, comment, string, operation, function, pound

static Function hex(group,code)
	String group, code
	code = SelectString(cmpstr(code[0],"#"),code[1,inf],code)
	rgb8(group, Str2Num("0x"+code[0,1]), Str2Num("0x"+code[2,3]), Str2Num("0x"+code[4,5]))
End

static Function rgb8(group,r,g,b)
	String group; Variable r,g,b
	return rgb16(group, r*256, g*256, b*256)
End

static Function rgb16(group,r,g,b)
	String group; Variable r,g,b
	String cmd
	sprintf cmd,"SetIgorOption colorize,%sColor=(%d,%d,%d)",group,r,g,b
	Execute/Z cmd
End

static Function x11(group,color)
	String group,color
	String dict=""
	// Pink colors
	dict+="Pink                :FFC0CB;"
	dict+="LightPink           :FFB6C1;"
	dict+="HotPink             :FF69B4;"
	dict+="DeepPink            :FF1493;"
	dict+="PaleVioletRed       :DB7093;"
	dict+="MediumVioletRed     :C71585;"
	// Red colors
	dict+="LightSalmon         :FFA07A;"
	dict+="Salmon              :FA8072;"
	dict+="DarkSalmon          :E9967A;"
	dict+="LightCoral          :F08080;"
	dict+="IndianRed           :CD5C5C;"
	dict+="Crimson             :DC143C;"
	dict+="FireBrick           :B22222;"
	dict+="DarkRed             :8B0000;"
	dict+="Red                 :FF0000;"
	// Orange colors
	dict+="OrangeRed           :FF4500;"
	dict+="Tomato              :FF6347;"
	dict+="Coral               :FF7F50;"
	dict+="DarkOrange          :FF8C00;"
	dict+="Orange              :FFA500;"
	// Yellow colors
	dict+="Yellow              :FFFF00;"
	dict+="LightYellow         :FFFFE0;"
	dict+="LemonChiffon        :FFFACD;"
	dict+="LightGoldenrodYellow:FAFAD2;"
	dict+="PapayaWhip          :FFEFD5;"
	dict+="Moccasin            :FFE4B5;"
	dict+="PeachPuff           :FFDAB9;"
	dict+="PaleGoldenrod       :EEE8AA;"
	dict+="Khaki               :F0E68C;"
	dict+="DarkKhaki           :BDB76B;"
	dict+="Gold                :FFD700;"
	// Brown colors
	dict+="Cornsilk            :FFF8DC;"
	dict+="BlanchedAlmond      :FFEBCD;"
	dict+="Bisque              :FFE4C4;"
	dict+="NavajoWhite         :FFDEAD;"
	dict+="Wheat               :F5DEB3;"
	dict+="BurlyWood           :DEB887;"
	dict+="Tan                 :D2B48C;"
	dict+="RosyBrown           :BC8F8F;"
	dict+="SandyBrown          :F4A460;"
	dict+="Goldenrod           :DAA520;"
	dict+="DarkGoldenrod       :B8860B;"
	dict+="Peru                :CD853F;"
	dict+="Chocolate           :D2691E;"
	dict+="SaddleBrown         :8B4513;"
	dict+="Sienna              :A0522D;"
	dict+="Brown               :A52A2A;"
	dict+="Maroon              :800000;"
	// Green colors
	dict+="DarkOliveGreen      :556B2F;"
	dict+="Olive               :808000;"
	dict+="OliveDrab           :6B8E23;"
	dict+="YellowGreen         :9ACD32;"
	dict+="LimeGreen           :32CD32;"
	dict+="Lime                :00FF00;"
	dict+="LawnGreen           :7CFC00;"
	dict+="Chartreuse          :7FFF00;"
	dict+="GreenYellow         :ADFF2F;"
	dict+="SpringGreen         :00FF7F;"
	dict+="MediumSpringGreen   :00FA9A;"
	dict+="LightGreen          :90EE90;"
	dict+="PaleGreen           :98FB98;"
	dict+="DarkSeaGreen        :8FBC8F;"
	dict+="MediumAquamarine    :66CDAA;"
	dict+="MediumSeaGreen      :3CB371;"
	dict+="SeaGreen            :2E8B57;"
	dict+="ForestGreen         :228B22;"
	dict+="Green               :008000;"
	dict+="DarkGreen           :006400;"
	// Cyan colors
	dict+="Aqua                :00FFFF;"
	dict+="Cyan                :00FFFF;"
	dict+="LightCyan           :E0FFFF;"
	dict+="PaleTurquoise       :AFEEEE;"
	dict+="Aquamarine          :7FFFD4;"
	dict+="Turquoise           :40E0D0;"
	dict+="MediumTurquoise     :48D1CC;"
	dict+="DarkTurquoise       :00CED1;"
	dict+="LightSeaGreen       :20B2AA;"
	dict+="CadetBlue           :5F9EA0;"
	dict+="DarkCyan            :008B8B;"
	dict+="Teal                :008080;"
	// Blue colors
	dict+="LightSteelBlue      :B0C4DE;"
	dict+="PowderBlue          :B0E0E6;"
	dict+="LightBlue           :ADD8E6;"
	dict+="SkyBlue             :87CEEB;"
	dict+="LightSkyBlue        :87CEFA;"
	dict+="DeepSkyBlue         :00BFFF;"
	dict+="DodgerBlue          :1E90FF;"
	dict+="CornflowerBlue      :6495ED;"
	dict+="SteelBlue           :4682B4;"
	dict+="RoyalBlue           :4169E1;"
	dict+="Blue                :0000FF;"
	dict+="MediumBlue          :0000CD;"
	dict+="DarkBlue            :00008B;"
	dict+="Navy                :000080;"
	dict+="MidnightBlue        :191970;"
	// Purple, violet, and magenta colors
	dict+="Lavender            :E6E6FA;"
	dict+="Thistle             :D8BFD8;"
	dict+="Plum                :DDA0DD;"
	dict+="Violet              :EE82EE;"
	dict+="Orchid              :DA70D6;"
	dict+="Fuchsia             :FF00FF;"
	dict+="Magenta             :FF00FF;"
	dict+="MediumOrchid        :BA55D3;"
	dict+="MediumPurple        :9370DB;"
	dict+="BlueViolet          :8A2BE2;"
	dict+="DarkViolet          :9400D3;"
	dict+="DarkOrchid          :9932CC;"
	dict+="DarkMagenta         :8B008B;"
	dict+="Purple              :800080;"
	dict+="Indigo              :4B0082;"
	dict+="DarkSlateBlue       :483D8B;"
	dict+="SlateBlue           :6A5ACD;"
	dict+="MediumSlateBlue     :7B68EE;"
	// White colors
	dict+="White               :FFFFFF;"
	dict+="Snow                :FFFAFA;"
	dict+="Honeydew            :F0FFF0;"
	dict+="MintCream           :F5FFFA;"
	dict+="Azure               :F0FFFF;"
	dict+="AliceBlue           :F0F8FF;"
	dict+="GhostWhite          :F8F8FF;"
	dict+="WhiteSmoke          :F5F5F5;"
	dict+="Seashell            :FFF5EE;"
	dict+="Beige               :F5F5DC;"
	dict+="OldLace             :FDF5E6;"
	dict+="FloralWhite         :FFFAF0;"
	dict+="Ivory               :FFFFF0;"
	dict+="AntiqueWhite        :FAEBD7;"
	dict+="Linen               :FAF0E6;"
	dict+="LavenderBlush       :FFF0F5;"
	dict+="MistyRose           :FFE4E1;"
	// Gray and black colors
	dict+="Gainsboro           :DCDCDC;"
	dict+="LightGray           :D3D3D3;"
	dict+="Silver              :C0C0C0;"
	dict+="DarkGray            :A9A9A9;"
	dict+="Gray                :808080;"
	dict+="DimGray             :696969;"
	dict+="LightSlateGray      :778899;"
	dict+="SlateGray           :708090;"
	dict+="DarkSlateGray       :2F4F4F;"
	dict+="Black               :000000;"
	
	dict = ReplaceString(" ",dict,"")
	return hex(group,StringByKey(color,dict))
End
