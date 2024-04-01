defmodule TodoOffline.UserData do
  @moduledoc """
  The UserData context.
  """

  import Ecto.Query, warn: false
  alias TodoOffline.Repo

  alias TodoOffline.Jwt
  alias TodoOffline.UserData.UserDocument

  # PubSub _________________________________________________________________________________________

  @topic "user_document"

  @doc """
  Subscribe to user_document updates for a given user_id.
  """
  def subscribe(user_id) do
    Phoenix.PubSub.subscribe(TodoOffline.PubSub, "#{@topic}:#{user_id}")
  end

  @doc """
  Broadcast to subscribers of a user_document.
  If an error is passed to broadcast/2, the error is returned.
  """
  def broadcast({:ok, user_document}, tag) do
    Phoenix.PubSub.broadcast(
      TodoOffline.PubSub,
      "#{@topic}:#{user_document.user_id}",
      {tag, user_document}
    )

    {:ok, user_document}
  end

  def broadcast({:error, changeset}, _tag), do: {:error, changeset}

  # CRUD ___________________________________________________________________________________________

  @doc """
  Returns the list of user_document.

  ## Examples

      iex> list_user_document()
      [%UserDocument{}, ...]

  """
  def list_user_document do
    Repo.all(UserDocument)
  end

  @doc """
  Gets a single user_document.

  Raises `Ecto.NoResultsError` if the User document does not exist.

  ## Examples

      iex> get_user_document!(123)
      %UserDocument{}

      iex> get_user_document!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_document!(id), do: Repo.get!(UserDocument, id)

  @doc """
  Gets a single user_document by user_id.

  If a user_document does not exist, return nil.
  """
  def get_user_document_by_user_id(user_id) do
    Repo.get_by(UserDocument, user_id: user_id)
  end

  @doc """
  Get base64 document for the current user in a socket.

  Returns nil if no document exists.
  """
  def get_document(socket) do
    user_id = socket.assigns.current_user.id

    case Repo.get_by(UserDocument, user_id: user_id) do
      nil -> nil
      %{document: document} -> document
    end
  end

  @doc """
  Creates a user_document.

  ## Examples

      iex> create_user_document(%{field: value})
      {:ok, %UserDocument{}}

      iex> create_user_document(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_document(attrs \\ %{}) do
    %UserDocument{}
    |> UserDocument.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_document.

  ## Examples

      iex> update_user_document(user_document, %{field: new_value})
      {:ok, %UserDocument{}}

      iex> update_user_document(user_document, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_document(%UserDocument{} = user_document, attrs) do
    user_document
    |> UserDocument.changeset(attrs)
    |> Repo.update()
    |> broadcast(:user_document_updated)
  end

  @doc """
  Deletes a user_document.

  ## Examples

      iex> delete_user_document(user_document)
      {:ok, %UserDocument{}}

      iex> delete_user_document(user_document)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_document(%UserDocument{} = user_document) do
    Repo.delete(user_document)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_document changes.

  ## Examples

      iex> change_user_document(user_document)
      %Ecto.Changeset{data: %UserDocument{}}

  """
  def change_user_document(%UserDocument{} = user_document, attrs \\ %{}) do
    UserDocument.changeset(user_document, attrs)
  end

  # Yjs ____________________________________________________________________________________________

  @doc """
  Get the latest document state by merging the Yjs document saved in the server
  database with the document from the client.

  The merge is handled by via a Cloudflare Worker in order to use Yjs on server side.
  """
  def get_latest_document(socket, client_document) do
    extra_claims = %{
      # TODO: Handle case where no document exists?
      "serverDocument" => get_document(socket),
      "clientDocument" => client_document
    }

    # Create JWT token.
    {:ok, token, _} = Jwt.generate_and_sign(extra_claims)

    # Send request for merge to JS backend.
    # TODO: Handle errors.
    Req.post!(System.get_env("JS_BACKEND_URL"), json: %{jwt: token}).body[
      "document"
    ]
  end
end
