defmodule Ash.Resource.Change.SetAttribute do
  @moduledoc false
  use Ash.Resource.Change
  alias Ash.Changeset

  def init(opts) do
    with :ok <- validate_attribute(opts[:attribute]),
         :ok <- validate_value(opts[:value]) do
      {:ok, opts}
    end
  end

  defp validate_attribute(nil), do: {:error, "attribute is required"}
  defp validate_attribute(value) when is_atom(value), do: :ok
  defp validate_attribute(other), do: {:error, "attribute is invalid: #{inspect(other)}"}
  defp validate_value(value) when is_function(value, 0), do: :ok

  defp validate_value(value) when is_function(value),
    do: {:error, "only 0 argument functions are supported"}

  defp validate_value(_), do: :ok

  def change(changeset, opts, _) do
    case opts[:value] do
      {arg_key, arg} when arg_key in [:arg, :_arg] ->
        case Ash.Changeset.fetch_argument(changeset, arg) do
          {:ok, value} ->
            if opts[:new?] do
              if Ash.Changeset.changing_attribute?(changeset, opts[:attribute]) do
                changeset
              else
                Changeset.force_change_attribute(changeset, opts[:attribute], value)
              end
            else
              Changeset.force_change_attribute(changeset, opts[:attribute], value)
            end

          _ ->
            changeset
        end

      _ ->
        value =
          case opts[:value] do
            value when is_function(value) -> value.()
            value -> value
          end

        if opts[:new?] do
          if Ash.Changeset.changing_attribute?(changeset, opts[:attribute]) do
            changeset
          else
            Changeset.force_change_attribute(changeset, opts[:attribute], value)
          end
        else
          Changeset.force_change_attribute(changeset, opts[:attribute], value)
        end
    end
  end
end
