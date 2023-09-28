defmodule AshTypeID.Macros do
  @moduledoc false

  defmacro typeid_attribute(name, opts \\ []) do
    default_prefix =
      __CALLER__.module
      |> Module.split()
      |> List.last()
      |> Macro.underscore()
      |> String.replace("_", "-")

    prefix = Keyword.get(opts, :prefix, default_prefix)

    constraints = [
      prefix: prefix
    ]

    default =
      quote do
        fn -> AshTypeID.TypeID.generator(unquote(constraints)) end
      end

    field_opts =
      opts
      |> Keyword.delete(:prefix)
      |> Keyword.put_new(:primary_key?, true)
      |> Keyword.put_new(:allow_nil?, false)
      |> Keyword.put_new(:default, default)
      |> Keyword.put_new(:writable?, false)
      |> Keyword.update(:constraints, constraints, fn kw ->
        kw
        |> Keyword.put(:prefix, prefix)
      end)

    quote do
      attribute unquote(name), AshTypeID.TypeID, unquote(field_opts)
    end
  end
end
