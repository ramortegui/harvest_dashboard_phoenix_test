defmodule Harvest.Report do
  defstruct [:companies_report]

  alias Harvest.ClientApi

  def new, do: %Harvest.Report{}

  def structured_report(organizations, from \\ '20160101' , to \\ '20161231'  ) when is_list(organizations) do
    Enum.map(
              organizations, 
              fn(org) ->
                report_hash = %{}
                report_list = Enum.map([:"account/who_am_i", :clients, :people, :tasks , :projects], fn(resource)->  
                  result = ClientApi.new 
                    |> ClientApi.headers 
                    |> ClientApi.config(org, Atom.to_string(resource)) 
                    |> ClientApi.request 
                    |> ClientApi.parse_response 

                    Map.put( report_hash, resource, result )
                end)

              company_report =  Enum.reduce(
                report_list, %{}, 
                fn structure, acc ->
                  [struct | _ ] = Map.keys(structure)
                  case struct do
                    :clients -> acc = Map.put(acc, :clients , structure[:clients] )
                    :people -> acc = Map.put(acc, :people , structure[:people] )
                    :tasks -> acc = Map.put(acc, :tasks , structure[:tasks] )
                    :projects -> acc = Map.put(acc, :projects , structure[:projects] )
                    :"account/who_am_i" -> acc = Map.put(acc, :"account/who_am_i", structure[:"account/who_am_i"] )
                  end
                end)

              entries = Enum.map(company_report[:projects], fn(proy) -> 
                ClientApi.new 
                |> ClientApi.headers 
                |> ClientApi.config(org,"projects/#{proy["project"]["id"]}/entries?from=#{from}&to=#{to}") 
                |> ClientApi.request 
                |> ClientApi.parse_response 
              end) |> List.flatten

              Map.put(company_report, :entries, entries)
              end)
  end

  def detailed_report(structured_report) do
    Enum.reduce(structured_report,fn(company_report, acc)-> 
      clients = convert_to_hash(:clients, company_report)
      people = convert_to_hash(:people, company_report) 
      tasks = convert_to_hash(:tasks, company_report) 
      projects = convert_to_hash(:projects, company_report)
      organization = convert_to_hash(:"account/who_am_i", company_report)

      Enum.map(company_report[:entries],fn(entry)-> 
        day_entry = entry["day_entry"]
        project_id = projects[day_entry["project_id"]]["id"]
        client_id = projects[day_entry["project_id"]]["client_id"]
        %{
          "date" => day_entry["spent_at"],
          "project" => projects[project_id]["name"],
          "client" => clients[client_id]["name"],
          "project_active" => projects[day_entry["project_id"]]["active"],
          "task" => tasks[day_entry["task_id"]]["name"],
          "person" => people[day_entry["user_id"]]["first_name"]<>" "<>people[day_entry["user_id"]]["last_name"],
          "hours" => day_entry["hours"],
          "organization" => company_report[:"account/who_am_i"]["company"]["name"]
        }
      end)

    end)
  end


  def convert_to_hash(structure, company_report) do
    case structure do
      :clients -> 
        Enum.reduce(company_report[:clients], %{}, fn client, new_structure -> Map.put(new_structure, client["client"]["id"], client["client"])  end)
      :people-> 
        Enum.reduce(company_report[:people], %{}, fn user, new_structure -> Map.put(new_structure, user["user"]["id"], user["user"])  end)
      :tasks-> 
        Enum.reduce(company_report[:tasks], %{},  fn task, new_structure -> Map.put(new_structure, task["task"]["id"], task["task"])  end)
      :projects-> 
        Enum.reduce(company_report[:projects], %{},  fn project, new_structure -> Map.put(new_structure, project["project"]["id"], project["project"])  end)
      :"account/who_am_i" ->
        company_report[:"account/who_am_i"]
    end
  end

  def pmap(collection, func) do
    collection
    |> Enum.map(&(Task.async(fn -> func.(&1) end)))
    |> Enum.map(&Task.await/1)
  end
end
