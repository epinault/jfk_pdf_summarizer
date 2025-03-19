defmodule JfkPdfSummarizerWeb.ChatLive do
  use JfkPdfSummarizerWeb, :live_view
  import Phoenix.Controller, only: [get_csrf_token: 0]
  alias JfkPdfSummarizer.JfkDocuments

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> stream_configure(:messages, dom_id: &"message-#{&1.id}")
     |> stream(:messages, [])
     |> assign(:query, "")
     |> assign(:loading, false)
     |> assign(:similar_documents, [])}
  end

  @impl true
  def handle_event("submit_query", %{"query" => query}, socket) do
    if String.trim(query) == "" do
      {:noreply, socket}
    else
      # Add user message to the chat
      user_message = %{
        id: System.unique_integer([:positive]),
        role: :user,
        content: query,
        timestamp: DateTime.utc_now()
      }

      # Start async search for similar documents
      {:noreply,
       socket
       |> stream_insert(:messages, user_message)
       |> assign(:query, "")
       |> assign(:loading, true)
       |> start_async(:search_documents, fn -> search_similar_documents(query) end)}
    end
  end

  @impl true
  def handle_async(:search_documents, {:ok, %{documents: documents, response: response}}, socket) do
    # Add assistant message to the chat
    assistant_message = %{
      id: System.unique_integer([:positive]),
      role: :assistant,
      content: response,
      timestamp: DateTime.utc_now()
    }

    {:noreply,
     socket
     |> stream_insert(:messages, assistant_message)
     |> assign(:loading, false)
     |> assign(:similar_documents, documents)}
  end

  @impl true
  def handle_async(:search_documents, {:exit, reason}, socket) do
    # Handle error
    error_message = %{
      id: System.unique_integer([:positive]),
      role: :assistant,
      content: "Sorry, I encountered an error while searching for documents: #{inspect(reason)}",
      timestamp: DateTime.utc_now()
    }

    {:noreply,
     socket
     |> stream_insert(:messages, error_message)
     |> assign(:loading, false)}
  end

  # Helper function to check if a stream is empty
  def stream_empty?(stream) do
    Enum.empty?(stream)
  end

  defp search_similar_documents(query) do
    # Get all documents
    all_documents = JfkDocuments.list_documents()

    # Find similar documents based on the query
    similar_documents =
      all_documents
      |> Enum.map(fn doc ->
        # Calculate similarity score (simple keyword matching for now)
        score = calculate_similarity(query, doc)
        {doc, score}
      end)
      |> Enum.filter(fn {_doc, score} -> score > 0.1 end)
      |> Enum.sort_by(fn {_doc, score} -> score end, :desc)
      |> Enum.take(5)
      |> Enum.map(fn {doc, _score} -> doc end)

    # Generate a response based on the query and similar documents
    response =
      if Enum.empty?(similar_documents) do
        "I couldn't find any relevant documents related to your query. Could you try rephrasing your question or using different keywords?"
      else
        docs_text =
          similar_documents
          |> Enum.map(fn doc -> "- #{doc.title}" end)
          |> Enum.join("\n")

        "I found some documents that might be relevant to your query:\n\n#{docs_text}\n\nYou can click on any document to view or summarize it."
      end

    # Return both the documents and the response
    %{documents: similar_documents, response: response}
  end

  defp calculate_similarity(query, document) do
    # Simple keyword matching for now
    # In a real implementation, you would use a more sophisticated approach like embeddings
    query_words = query |> String.downcase() |> String.split(~r/\s+/)
    title_words = document.title |> String.downcase() |> String.split(~r/\s+/)
    desc_words = document.description |> String.downcase() |> String.split(~r/\s+/)

    all_words = title_words ++ desc_words
    matches = Enum.count(query_words, fn word -> Enum.member?(all_words, word) end)

    # Return a score between 0 and 1
    matches / length(query_words)
  end
end
