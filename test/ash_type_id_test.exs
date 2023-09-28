defmodule Ash.Test.Type.TypeIDTest do
  @moduledoc false
  use ExUnit.Case, async: true
  import AshTypeID.Macros

  import Ash.Changeset

  defmodule Post do
    @moduledoc false
    use Ash.Resource, data_layer: Ash.DataLayer.Ets

    ets do
      private?(true)
    end

    actions do
      defaults [:create, :read, :update, :destroy]
    end

    attributes do
      typeid_attribute(:id, prefix: "posty")

      attribute :name, :string do
        allow_nil? false

        constraints trim?: true,
                    allow_empty?: false,
                    min_length: 3,
                    max_length: 100
      end

      update_timestamp :updated_at
      create_timestamp :inserted_at
    end
  end

  defmodule Registry do
    @moduledoc false
    use Ash.Registry

    entries do
      entry Post
    end
  end

  defmodule This do
    @moduledoc false
    use Ash.Api

    resources do
      registry Registry
    end
  end

  test "create a post with a typeid" do
    post =
      Post
      |> new(%{name: "foo"})

    assert post.attributes.name == "foo"
  end

  test "create a post with a typeid using api create" do
    post =
      Post
      |> new(%{
        name: "  foo  "
      })
      |> This.create!()

    assert post.name == "foo"
    assert TypeID.prefix(post.id) == "posty"
  end
end
