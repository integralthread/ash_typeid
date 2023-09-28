defmodule AshTypeID do
  @moduledoc """
  Base module.

  """
  @moduledoc since: "0.1.0"

  use Spark.Dsl.Extension,
    imports: [AshTypeID.Macros],
    transformers: []
end
