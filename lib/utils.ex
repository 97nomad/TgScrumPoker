defmodule TgScrumPoker.Utils do
  def extract_name(user) do
    case user do
      %{first_name: first_name, last_name: last_name} -> ~s"#{first_name} #{last_name}"
      %{first_name: first_name} -> first_name
    end
  end
end
