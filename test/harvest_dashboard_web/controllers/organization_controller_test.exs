defmodule HarvestDashboardWeb.OrganizationControllerTest do
  use HarvestDashboardWeb.ConnCase

  alias HarvestDashboard.Organizations

  @create_attrs %{password: "some password", subdomain: "some subdomain", username: "some username"}
  @update_attrs %{password: "some updated password", subdomain: "some updated subdomain", username: "some updated username"}
  @invalid_attrs %{password: nil, subdomain: nil, username: nil}

  def fixture(:organization) do
    {:ok, organization} = Organizations.create_organization(@create_attrs)
    organization
  end

  describe "index" do
    test "lists all organizations", %{conn: conn} do
      conn = get conn, organization_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Organizations"
    end
  end

  describe "new organization" do
    test "renders form", %{conn: conn} do
      conn = get conn, organization_path(conn, :new)
      assert html_response(conn, 200) =~ "New Organization"
    end
  end

  describe "create organization" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, organization_path(conn, :create), organization: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == organization_path(conn, :show, id)

      conn = get conn, organization_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Organization"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, organization_path(conn, :create), organization: @invalid_attrs
      assert html_response(conn, 200) =~ "New Organization"
    end
  end

  describe "edit organization" do
    setup [:create_organization]

    test "renders form for editing chosen organization", %{conn: conn, organization: organization} do
      conn = get conn, organization_path(conn, :edit, organization)
      assert html_response(conn, 200) =~ "Edit Organization"
    end
  end

  describe "update organization" do
    setup [:create_organization]

    test "redirects when data is valid", %{conn: conn, organization: organization} do
      conn = put conn, organization_path(conn, :update, organization), organization: @update_attrs
      assert redirected_to(conn) == organization_path(conn, :show, organization)

      conn = get conn, organization_path(conn, :show, organization)
      assert html_response(conn, 200) =~ "some updated password"
    end

    test "renders errors when data is invalid", %{conn: conn, organization: organization} do
      conn = put conn, organization_path(conn, :update, organization), organization: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Organization"
    end
  end

  describe "delete organization" do
    setup [:create_organization]

    test "deletes chosen organization", %{conn: conn, organization: organization} do
      conn = delete conn, organization_path(conn, :delete, organization)
      assert redirected_to(conn) == organization_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, organization_path(conn, :show, organization)
      end
    end
  end

  defp create_organization(_) do
    organization = fixture(:organization)
    {:ok, organization: organization}
  end
end
