defmodule Harvest.Organization do
  @enforce_keys [:username, :password, :subdomain]
  defstruct [:username, :password, :subdomain]
end
