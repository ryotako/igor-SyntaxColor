#pragma ModuleName=SyntaxColor
strconstant SyntaxColorMenu="SyntaxColor"

// Menu
Menu StringFromList(0,SyntaxColorMenu)
	RemoveListItem(0,SyntaxColorMenu)
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
	Execute/P "SetIgorOption colorize,keywordColor=(0,0,65535)"
	Execute/P "SetIgorOption colorize,commentColor=(65535,0,0)"
	Execute/P "SetIgorOption colorize,stringColor=(0,40000,0)"
	Execute/P "SetIgorOption colorize,operationColor=(0,30000,30000)"
	Execute/P "SetIgorOption colorize,functionColor=(50000,20000,0)"
	Execute/P "SetIgorOption colorize,poundColor=(52428,1,41942)"
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
	rgb8(group, Str2Num("0x"+code[0,1]), Str2Num("0x"+code[2,3]), Str2Num("0x"+code[4,5]))
End

static Function rgb8(group,r,g,b)
	String group; Variable r,g,b
	return rgb16(group, r*256, g*256, b*256)
End

static Function rgb16(group,r,g,b)
	String group; Variable r,g,b
	String cmd
	sprintf cmd,"SetIgorOption colorscheme,%sColor=(%d,%d,%d)",group,r,g,b
	Execute/Z cmd
End

