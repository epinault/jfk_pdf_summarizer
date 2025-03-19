defmodule JfkPdfSummarizer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      JfkPdfSummarizerWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:jfk_pdf_summarizer, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: JfkPdfSummarizer.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: JfkPdfSummarizer.Finch},
      # Start a worker by calling: JfkPdfSummarizer.Worker.start_link(arg)
      # {JfkPdfSummarizer.Worker, arg},
      # Start to serve requests, typically the last entry
      JfkPdfSummarizerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: JfkPdfSummarizer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    JfkPdfSummarizerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
