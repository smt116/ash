defmodule Ash.Actions.Attributes do
  def attribute_change_requests(changeset, api, resource, action) do
    resource
    |> Ash.attributes()
    |> Enum.reject(fn attribute ->
      attribute.name in Map.get(changeset, :__ash_skip_authorization_fields__, [])
    end)
    |> Enum.filter(fn attribute ->
      attribute.write_rules != false && Map.has_key?(changeset.changes, attribute.name)
    end)
    |> Enum.map(fn attribute ->
      Ash.Engine.Request.new(
        api: api,
        rules: attribute.write_rules,
        resource: resource,
        changeset: changeset,
        action_type: action.type,
        dependencies: [[:data]],
        fetcher: fn _, %{data: data} -> {:ok, data} end,
        state_key: :data,
        relationship: [],
        source: "change on `#{attribute.name}`"
      )
    end)
  end
end