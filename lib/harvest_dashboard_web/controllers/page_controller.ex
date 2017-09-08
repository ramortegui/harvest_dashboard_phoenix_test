defmodule HarvestDashboardWeb.PageController do
  require Logger
  use HarvestDashboardWeb, :controller
  alias HarvestDashboard.Repo
  def index(conn, _params) do
    organizations =   Enum.map(Repo.all(HarvestDashboard.Organizations.Organization),fn(a) -> %Harvest.Organization{
    username: a.username, password: a.password, subdomain: a.subdomain } 
    end)

    detailed_report = Harvest.Report.structured_report(organizations) 
                      |> Harvest.Report.detailed_report

    render conn, "index.html", entries: detailed_report 
  end
end
