package hxlua;

/**
 * An interface for objects that can go to and from lua instances
 * Any class implementing this will have a macro built for every function to work in lua
 * Functions that only have a `Lua` object as an argument will be able to do like multiargument things whatever
 */
@:autoBuild(hxlua.macro.LuaObjectMacro.build())
interface ILuaObject
{
	public function toLua(lua:Lua):Void;
}