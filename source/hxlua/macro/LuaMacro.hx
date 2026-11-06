package hxlua.macro;

import haxe.macro.Expr;

@:allow(hxlua)
class LuaMacro 
{
	static macro function loopTable(v:Expr, e:Expr)
	{
		return macro
		{
			toLua(null);
			while (lua_next(handle, $v < 0 ? $v - 1 : $v)) 
			{
				$e;
				lua_pop(handle, 1);
			}
		}
	}
}