defmodule TodoOffline.Repo.Migrations.CreateUserDocument do
  use Ecto.Migration

  def change do
    create table(:user_document) do
      add :document, :text, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:user_document, [:user_id])
  end
end
