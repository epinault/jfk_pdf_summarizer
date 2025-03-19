defmodule JfkPdfSummarizer.JfkDocuments do
  @moduledoc """
  Module for handling JFK document collection from the National Archives.
  """
  
  @doc """
  Returns a list of JFK documents from the National Archives.
  This includes real documents from the 2025 release.
  """
  def list_documents do
    # Combine the static list with documents from the CSV file
    static_documents() ++ load_csv_documents()
  end

  # Static list of important documents
  defp static_documents do
    [
      %{
        title: "Warren Commission Report",
        url: "https://www.archives.gov/research/jfk/warren-commission-report/toc",
        description: "The official report of the assassination of President Kennedy"
      },
      %{
        title: "House Select Committee on Assassinations Report",
        url: "https://www.archives.gov/research/jfk/select-committee-report/toc",
        description: "Report from the congressional investigation into the assassinations"
      },
      %{
        title: "Assassination Records Review Board Report",
        url: "https://www.archives.gov/research/jfk/review-board/report/index",
        description: "Report from the board established to collect assassination records"
      }
    ]
  end

  # Load documents from the CSV file
  defp load_csv_documents do
    csv_path = Path.join(File.cwd!(), "jfk_links.csv")
    
    if File.exists?(csv_path) do
      csv_path
      |> File.stream!()
      |> CSV.decode!(headers: true)
      |> Enum.map(fn %{"Filename" => filename, "URL" => url} ->
        %{
          title: "JFK Document #{filename}",
          url: url,
          description: "Document from the JFK Records Collection"
        }
      end)
    else
      # If CSV file doesn't exist, return an empty list
      []
    end
  end
  
  @doc """
  Fetches documents from the National Archives JFK Collection.
  This would be implemented to scrape or use an API to get the latest documents.
  """
  def fetch_latest_documents do
    # In a real implementation, this would make HTTP requests to the National Archives
    # website and parse the response to extract document information.
    # For now, we'll just return the static list.
    list_documents()
  end
  
  @doc """
  Downloads a document from the given URL and returns the path to the downloaded file.
  """
  def download_document(url) do
    # Create a temporary file to store the PDF
    {:ok, temp_path} = Temp.path(%{suffix: ".pdf"})
    
    # Download the PDF
    case Req.get(url, into: File.stream!(temp_path)) do
      {:ok, %{status: 200}} ->
        {:ok, temp_path}
      {:ok, %{status: status}} ->
        {:error, "Failed to download document: HTTP status #{status}"}
      {:error, reason} ->
        {:error, "Failed to download document: #{inspect(reason)}"}
    end
  end
end
