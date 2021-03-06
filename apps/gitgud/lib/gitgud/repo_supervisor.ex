defmodule GitGud.RepoSupervisor do
  @moduledoc """
  Supervisor for dealing with repository processes.
  """
  use Supervisor

  alias GitGud.RepoPool
  alias GitGud.RepoPoolMonitor

  @doc """
  Starts the supervisor as part of a supervision tree.
  """
  @spec start_link(Supervisor.options) ::  {:ok, pid} | {:error, {:already_started, pid} | {:shutdown, term} | term}
  def start_link(opts \\ []) do
    opts = Keyword.put(opts, :name, __MODULE__)
    Supervisor.start_link(__MODULE__, [], opts)
  end

  #
  # Callbacks
  #

  @impl true
  def init([]) do
    children = [
      {RepoPool, []},
      {RepoPoolMonitor, []},
      {Registry, keys: :unique, name: GitGud.RepoRegistry}
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end
end
