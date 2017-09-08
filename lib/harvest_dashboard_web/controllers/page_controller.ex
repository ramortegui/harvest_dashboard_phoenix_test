defmodule HarvestDashboardWeb.PageController do
  require Logger
  use HarvestDashboardWeb, :controller
  alias HarvestDashboard.Repo
  def index(conn, params) do

    from = DateTime.utc_now
           |> DateTime.to_date
           |> Date.to_string
    from =  Regex.replace(~r/-/, from,"")

    to = DateTime.utc_now
           |> DateTime.to_date
           |> Date.to_string
    to = Regex.replace(~r/-/, to,"")
     
    if (params["Elixir.Search"] ) do
      from_day = String.to_integer(params["Elixir.Search"]["from"]["day"])
      from_month =String.to_integer( params["Elixir.Search"]["from"]["month"])
      from_year = String.to_integer(params["Elixir.Search"]["from"]["year"])
      {:ok, from} = Date.new(from_year, from_month, from_day)
      from = Regex.replace(~r/-/,Date.to_string(from),"")
      to_day = String.to_integer(params["Elixir.Search"]["to"]["day"])
      to_month= String.to_integer(params["Elixir.Search"]["to"]["month"])
      to_year = String.to_integer(params["Elixir.Search"]["to"]["year"])
      {:ok, to} = Date.new(to_year, to_month, to_day)
      to = Regex.replace(~r/-/,Date.to_string(to),"")
    end
    organizations =   Enum.map(Repo.all(HarvestDashboard.Organizations.Organization),fn(a) -> %Harvest.Organization{
    username: a.username, password: a.password, subdomain: a.subdomain } 
    end)

    detailed_report = Harvest.Report.structured_report(organizations,from,to) 
                      |> Harvest.Report.detailed_report

    render conn, "index.html", entries: detailed_report 
  end
end
