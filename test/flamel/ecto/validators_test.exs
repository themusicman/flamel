defmodule Flamel.Test.Person do
end

defmodule Flamel.Ecto.ValidatorsTest do
  use ExUnit.Case

  import Ecto.Changeset
  import Flamel.Ecto.Validators
  alias Ecto.Changeset

  describe "validate_at_least_one_required/3" do
    test "returns a changeset with an error added to the first field in the list" do
      fields = {%{phone: "", email: ""}, %{phone: :string, email: :string}}
      attrs = %{}

      cs =
        fields
        |> cast(attrs, [:phone, :email])
        |> validate_at_least_one_required([:phone, :email], "either phone or email is required")

      %Changeset{errors: errors} = cs

      assert cs.valid? == false
      assert errors == [phone: {"either phone or email is required", []}]
    end

    test "returns a changeset without an error added if one of the fields is not empty" do
      fields = {%{phone: "", email: ""}, %{phone: :string, email: :string}}
      attrs = %{phone: "+18768765436"}

      cs =
        fields
        |> cast(attrs, [:phone, :email])
        |> validate_at_least_one_required([:phone, :email], "either phone or email is required")

      %Changeset{errors: errors} = cs

      assert cs.valid? == true
      assert errors == []
    end
  end
end
