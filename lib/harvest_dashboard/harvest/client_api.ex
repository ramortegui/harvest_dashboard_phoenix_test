defmodule Harvest.ClientApi do
  defstruct [:auth, :headers, :connection]
  def new do %Harvest.ClientApi{} end

  def auth(%Harvest.ClientApi{} = client_api, %Harvest.Organization{} = organization) do
    %Harvest.ClientApi{ client_api | auth: Base.encode64 "#{organization.username}:#{organization.password}"}
  end

  def headers( %Harvest.ClientApi{ auth: auth } = client_api ) do
    headers = [
      "Accept": "application/json",
      "Content-Type": "application/json; charset=utf-8",
      "Authorization": "Basic #{auth}",
      "User-Agent": "API client Ruben"
    ]
    %Harvest.ClientApi{ client_api | headers: headers}
  end

  def connection

end
