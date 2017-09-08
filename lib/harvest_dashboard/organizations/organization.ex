defmodule HarvestDashboard.Organizations.Organization do
  use Ecto.Schema
  import Ecto.Changeset
  alias HarvestDashboard.Organizations.Organization


  schema "organizations" do
    field :password, :string
    field :subdomain, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(%Organization{} = organization, attrs) do
    organization
    |> cast(attrs, [:username, :password, :subdomain])
    |> validate_required([:username, :password, :subdomain])
  end
end
