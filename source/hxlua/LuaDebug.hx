package hxlua;

class LuaDebug
{
	public var event:Int;
	public var name:String; 		/* (n) */
	public var nameWhat:String; 	/* (n) `global', `local', `field', `method' */
	public var what:String; 		/* (S) `Lua' function, `C' function, Lua `main' */
	public var source:String; 		/* (S) */
	public var currentLine:Int; 	/* (l) */
	public var nups:Int; 			/* (u) number of upvalues */
	public var lineDefined:Int; 	/* (S) */
	public var shortSrc:String; 	/* (S) */

	public function new() {}

	public function toString():String
	{
		return 'LuaDebug ($event, $name, $nameWhat, $what, $source, $currentLine, $nups, $lineDefined, $shortSrc)';
	}
}