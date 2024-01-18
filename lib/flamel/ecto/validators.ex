defmodule Flamel.Ecto.Validators do
  @moduledoc """
  Some validation functions for Ecto
  """

  import Ecto.Changeset, only: [get_field: 2, add_error: 3, validate_required: 3]
  alias Ecto.Changeset

  @doc """
  A validate function that checks to see at least one of the fields is not blank

  ## Example

      iex> Flamel.Ecto.Validators.validate_at_least_one_required(changeset, [:phone, :email], "either phone or email is required")
  """
  @spec validate_at_least_one_required(Changeset.t(), [atom()], binary()) :: Changeset.t()
  def validate_at_least_one_required(changeset, fields, msg) when is_list(fields) do
    Enum.all?(fields, fn field ->
      Flamel.blank?(get_field(changeset, field))
    end)
    |> if do
      add_error(changeset, hd(fields), msg)
    else
      changeset
    end
  end

  @doc """
  A validate function that requires a field have a value if a condition is met

  ## Example

      iex> Flamel.Ecto.Validators.validate_required_if(changeset, :confirm, fn _changeset -> true end) "confirm is required")
  """
  @spec validate_required_if(Changeset.t(), atom(), function(), keyword()) :: Changeset.t()
  def validate_required_if(changeset, field, condition, opts) do
    if condition.(changeset) do
      validate_required(changeset, field, opts)
    else
      changeset
    end
  end
end
