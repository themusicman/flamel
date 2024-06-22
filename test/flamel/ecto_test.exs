defmodule Flamel.Ecto.Profile do
  defstruct first_name: "", last_name: ""
end

defmodule Flamel.Ecto.User do
  defstruct id: nil, profile: %Ecto.Association.NotLoaded{}
end

defmodule Flamel.EctoTest do
  use ExUnit.Case
  doctest Flamel.Ecto

  describe "loaded?/1" do
    test "returns true if the association is loaded" do
      user = %Flamel.Ecto.User{
        profile: %Flamel.Ecto.Profile{first_name: "Bob", last_name: "Conner"}
      }

      assert Flamel.Ecto.loaded?(user.profile) == true
    end

    test "returns false if the association is loaded" do
      user = %Flamel.Ecto.User{}
      assert Flamel.Ecto.loaded?(user.profile) == false
    end
  end
end
