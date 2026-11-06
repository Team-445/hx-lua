package hxlua.macro;

#if macro
import haxe.macro.Context;
import haxe.macro.Type;
import haxe.macro.Expr;

using haxe.macro.Tools;
using haxe.macro.TypeTools;
using haxe.macro.ComplexTypeTools;

using StringTools;
#end

class LuaObjectMacro
{
	#if macro
	/**
	 * @return The modified list of fields for the target class.
	 */
	public static macro function build():Array<Field>
	{
		var cls:ClassType = Context.getLocalClass().get();

		var fields:Array<Field> = Context.getBuildFields();

		var has = false;
		for (int in cls.interfaces)
		{
			if (int.t.get().name == "ILuaObject")
			{
				has = true;
			}
		}
		// we aRNET EVEN A 
		if (!has)
			return null;

		var toLuas:Array<Expr> = [];

		for (field in fields)
		{
			if (!field.access.contains(APublic))
				continue;

			var luaFieldName:String = field.name;
			var luaArg:Bool = false;
			for (meta in field.meta)
			{
				switch (meta.name.startsWith(":") ? meta.name.substr(1) : meta.name)
				{
					case "noLua":
						continue;
					case "luaName":
						luaFieldName = cast meta.params[0].getValue();
					case "luaArg":
						luaArg = true;
				}
			}

			final fieldName:String = field.name;

			switch field.kind
			{
				case FFun(f):
					if (field.name == "new")
						continue;

					if (luaArg)
						f.ret = macro :Int;

					toLuas.push(macro 
					{
						// push function
						${
							if (luaArg)
							{
								macro hxlua.Lua.lua_haxe_callback_table_single(lua.handle, lua, this.$fieldName);
							}
							else
							{
								macro hxlua.Lua.lua_haxe_callback_table(lua.handle, lua, this.$fieldName);
							}
						}
						hxlua.Lua.lua_setfield(lua.handle, -2, $v{luaFieldName});
					});
				default:
			}
		}

		fields.push({
			name: "toLua",
			kind: FFun({
				args: [{name: "lua", type: macro :hxlua.Lua}],
				expr: macro
				{
					hxlua.Lua.lua_createtable(lua.handle, 0, $v{toLuas.length} + 1);
					$b{toLuas}
					
					// push pointer to source object
					hxlua.Lua.lua_haxe_pointer_to_lua(lua.handle, this);
					hxlua.Lua.lua_setfield(lua.handle, -2, "__HAXE_OBJECT");
				}
			}),
			access: [APublic],
			pos: Context.currentPos(),
		});

		return fields;
	}
	#end
}