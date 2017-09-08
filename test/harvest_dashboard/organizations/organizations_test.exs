defmodule HarvestDashboard.OrganizationsTest do
  use HarvestDashboard.DataCase

  alias HarvestDashboard.Organizations

  describe "organizations" do
    alias HarvestDashboard.Organizations.Organization

    @valid_attrs %{password: "some password", subdomain: "some subdomain", username: "some username"}
    @update_attrs %{password: "some updated password", subdomain: "some updated subdomain", username: "some updated username"}
    @invalid_attrs %{password: nil, subdomain: nil, username: nil}

    def organization_fixture(attrs \\ %{}) do
      {:ok, organization} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Organizations.create_organization()

      organization
    end

    test "list_organizations/0 returns all organizations" do
      organization = organization_fixture()
      assert Organizations.list_organizations() == [organization]
    end

    test "get_organization!/1 returns the organization with given id" do
      organization = organization_fixture()
      assert Organizations.get_organization!(organization.id) == organization
    end

    test "create_organization/1 with valid data creates a organization" do
      assert {:ok, %Organization{} = organization} = Organizations.create_organization(@valid_attrs)
      assert organization.password == "some password"
      assert organization.subdomain == "some subdomain"
      assert organization.username == "some username"
    end

    test "create_organization/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Organizations.create_organization(@invalid_attrs)
    end

    test "update_organization/2 with valid data updates the organization" do
      organization = organization_fixture()
      assert {:ok, organization} = Organizations.update_organization(organization, @update_attrs)
      assert %Organization{} = organization
      assert organization.password == "some updated password"
      assert organization.subdomain == "some updated subdomain"
      assert organization.username == "some updated username"
    end

    test "update_organization/2 with invalid data returns error changeset" do
      organization = organization_fixture()
      assert {:error, %Ecto.Changeset{}} = Organizations.update_organization(organization, @invalid_attrs)
      assert organization == Organizations.get_organization!(organization.id)
    end

    test "delete_organization/1 deletes the organization" do
      organization = organization_fixture()
      assert {:ok, %Organization{}} = Organizations.delete_organization(organization)
      assert_raise Ecto.NoResultsError, fn -> Organizations.get_organization!(organization.id) end
    end

    test "change_organization/1 returns a organization changeset" do
      organization = organization_fixture()
      assert %Ecto.Changeset{} = Organizations.change_organization(organization)
    end
  end
end
