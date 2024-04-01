defmodule TodoOffline.UserDataFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TodoOffline.UserData` context.
  """

  @doc """
  Generate a user_document.
  """
  def user_document_fixture(attrs \\ %{}) do
    {:ok, user_document} =
      attrs
      |> Enum.into(%{
        document: "some document"
      })
      |> TodoOffline.UserData.create_user_document()

    user_document
  end
end
