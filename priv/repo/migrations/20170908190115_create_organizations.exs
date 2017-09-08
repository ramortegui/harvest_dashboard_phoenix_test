defmodule HarvestDashboard.Repo.Migrations.CreateOrganizations do
  use Ecto.Migration

  def change do
    create table(:organizations) do
      add :username, :string
      add :password, :string
      add :subdomain, :string

      timestamps()
    end

  end
end
