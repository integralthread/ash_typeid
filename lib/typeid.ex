defmodule AshTypeID.TypeID do
  @constraints [
    prefix: [type: :string, doc: "Prefix", default: "id"]
    # string?: [type: :boolean, doc: "String?", default: true]
  ]

  @moduledoc """
  AshTypeID -  type-safe, K-sortable, globally unique identifier inspired by Stripe IDs.

    ```Elixir
  config :ash, :custom_types, [ash_typeid: AshTypeID.TypeID]
  ```


  ### Constraints

  #{Spark.OptionsHelpers.docs(@constraints)}
  """

  use Ash.Type

  @doc """
  Returns the *underlying* storage type (the underlying type of the *ecto type* of the *ash type*)
  """
  # @spec storage_type(t()) :: Ecto.Type.t()
  @impl Ash.Type
  def storage_type, do: :binary_id

  @doc """
  Returns the ecto compatible type for an Ash.Type.

  If you `use Ash.Type`, this is created for you. For builtin types
  this may return a corresponding ecto builtin type (atom)
  """

  # @spec ecto_type(t) :: Ecto.Type.t()
  # @impl Ash.Type
  # def ecto_type({:array, type}), do: {:array, ecto_type(type)}

  @impl Ash.Type
  def generator(constraints) do
    TypeID.new(constraints[:prefix])
  end

  @doc """
  Casts input (e.g. unknown) data to an instance of the type, or errors

  Maps to `Ecto.Type.cast/2`
  """
  # @spec cast_input(t(), term, constraints | nil) :: {:ok, term} | {:error, Keyword.t()} | :error
  @impl Ash.Type
  def cast_input(nil, _), do: {:ok, nil}

  def cast_input(term, constraints) do
    TypeID.Ecto.cast(term, %{prefix: constraints[:prefix]})
  end

  @doc """
  Casts a value from the data store to an instance of the type, or errors

  Maps to `Ecto.Type.load/2`
  """
  # @spec cast_stored(t(), term, constraints | nil) :: {:ok, term} | {:error, keyword()} | :error
  @impl Ash.Type
  def cast_stored(nil, _), do: {:ok, nil}

  def cast_stored(term, constraints) do
    TypeID.Ecto.load(term, nil, %{prefix: constraints[:prefix], type: storage_type()})
  end

  @doc """
  Casts a value from the Elixir type to a value that the data store can persist

  Maps to `Ecto.Type.dump/2`
  """
  # @spec dump_to_native(t(), term, constraints | nil) :: {:ok, term} | {:error, keyword()} | :error
  @impl Ash.Type
  def dump_to_native(nil, _), do: {:ok, nil}

  def dump_to_native(term, constraints) do
    TypeID.Ecto.dump(term, nil, %{prefix: constraints[:prefix], type: storage_type()})
  end

  @doc """
  Casts a value from the Elixir type to a value that can be embedded in another data structure.

  Embedded resources expect to be stored in JSON, so this allows things like UUIDs to be stored
  as strings in embedded resources instead of binary.
  """
  # @spec dump_to_embedded(t(), term, constraints | nil) :: {:ok, term} | {:error, keyword()} | :error
  @impl Ash.Type
  def dump_to_embedded(term, constraints) do
    TypeID.Ecto.dump(term, nil, %{prefix: constraints[:prefix], type: :string})
  end

  @doc """
  Determines if two values of a given type are equal.

  Maps to `Ecto.Type.equal?/3`
  """
  # @spec equal?(t(), term, term) :: boolean
  @impl Ash.Type
  def equal?(term1, term2) do
    dump_to_embedded(term1, constraints()) == dump_to_embedded(term2, constraints())
  end

  @impl Ash.Type
  def constraints, do: @constraints

  @impl Ash.Type
  def apply_constraints(_term, _constraints), do: :ok
end
