# igor-SyntaxColor
Igor Procedures for changing syntax highlighting color

# Usage
## GUI
You can change syntax highlighting colors and save them as a macro from the menu bar.

<img src="http://img.f.hatena.ne.jp/images/fotolife/r/ryotako/20160910/20160910201958.png" alt="screenshot">

## Functions
This procedure provides some functions to change syntax highlighting colors.

- SyntaxColor#rgb16(String syntax_group, Variable red_16bit, Variable green_16bit, Variable blue_16bit)
- SyntaxColor#rgb8(String syntax_group, Variable red_8bit, Variable green_8bit, Variable blue_8bit)
-	SyntaxColor#hex(String syntax_group, String hex_triplet)
-	SyntaxColor#x11(String syntax_group, String x11_color_name)

Syntax groups in Igor Pro are `keyword`, `comment`,`string`,`operation`,`function`, and `pound`.

### Example
```
// Functions and macros beginning with ColorScheme_* are listed up in the menu. 
Macro ColorScheme_Demo()
	// One can change syntax highlighting color with operations
	SetIgorOption colorize,keywordColor=(39321,26208,1)
	// Execute operation (In a function, one cannot use SetIgorOption.)
	Execute "SetIgorOption colorize,commentColor=(43264,43264,43264)"

	// The followings are functions provided by SyntaxColor.ipf
	// The first argument is a syntax group name:
	// keyword, comment, string, operation, function, pound
	// 16 bit rgb values
	SyntaxColor#rgb16("string",1,39321,19939)

	// 8 bit rgb values
	SyntaxColor#rgb8("operation",220,20,60)
	
	// hex color code
	SyntaxColor#hex("function"   ,"#FF69B4") // # can be omitted.

	// X11 colors
	SyntaxColor#x11("pound", "DarkTurquoise")
End
```
