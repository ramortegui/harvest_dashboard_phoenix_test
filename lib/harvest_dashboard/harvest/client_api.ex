defmodule Harvest.ClientApi do
  defstruct [:auth, :url, :headers ]

  def new do %Harvest.ClientApi{} end

    def headers( %Harvest.ClientApi{} = client_api ) do
      headers = [
        "Accept": "application/json",
        "Content-Type": "application/json; charset=utf-8",
      ]
      %Harvest.ClientApi{ client_api | headers: headers}
    end


    def config( %Harvest.ClientApi{} = client_api, %Harvest.Organization{} = organization, path) do
      a = %Harvest.ClientApi{ client_api | auth: [hackney: [ basic_auth: { organization.username, organization.password }]], url: "https://#{organization.subdomain}.harvestapp.com/#{path}" }
      IO.puts inspect a
      a
    end

    def request( %Harvest.ClientApi{} = client_api) do
      HTTPoison.get(client_api.url, client_api.headers, client_api.auth) 
    end

    def parse_response(response) do
      case response do
        {:ok, %HTTPoison.Response{body: body}} -> Poison.decode!(body)
      end
    end
end
