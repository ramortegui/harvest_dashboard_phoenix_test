defmodule Harvest.ClientApi do
  defstruct [:auth]
  def new do %Harvest.ClientApi{} end
  def auth(%Harvest.ClientApi{} = client_api, %Harvest.Organization{} = organization) do
    %Harvest.ClientApi{ client_api | auth: Base.encode64 "#{organization.username}:#{organization.password}"}
  end
end
