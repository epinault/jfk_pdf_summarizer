defmodule JfkPdfSummarizer.JfkDocuments do
  @moduledoc """
  Module for handling JFK document collection from the National Archives.
  """
  
  @doc """
  Returns a list of JFK documents from the National Archives.
  This includes real documents from the 2025 release.
  """
  def list_documents do
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
      },
      # 2025 Release Documents
      %{
        title: "JFK Document 104-10004-10143",
        url: "https://www.archives.gov/files/research/jfk/releases/2025/0318/104-10004-10143.pdf",
        description: "Document from the 2025 JFK Records Release"
      },
      %{
        title: "JFK Document 104-10004-10156",
        url: "https://www.archives.gov/files/research/jfk/releases/2025/0318/104-10004-10156.pdf",
        description: "Document from the 2025 JFK Records Release"
      },
      %{
        title: "JFK Document 104-10005-10321",
        url: "https://www.archives.gov/files/research/jfk/releases/2025/0318/104-10005-10321.pdf",
        description: "Document from the 2025 JFK Records Release"
      },
      %{
        title: "JFK Document 104-10006-10247",
        url: "https://www.archives.gov/files/research/jfk/releases/2025/0318/104-10006-10247.pdf",
        description: "Document from the 2025 JFK Records Release"
      },
      %{
        title: "JFK Document 104-10007-10345",
        url: "https://www.archives.gov/files/research/jfk/releases/2025/0318/104-10007-10345.pdf",
        description: "Document from the 2025 JFK Records Release"
      },
      %{
        title: "JFK Document 104-10009-10021",
        url: "https://www.archives.gov/files/research/jfk/releases/2025/0318/104-10009-10021.pdf",
        description: "Document from the 2025 JFK Records Release"
      },
      %{
        title: "JFK Document 104-10012-10022",
        url: "https://www.archives.gov/files/research/jfk/releases/2025/0318/104-10012-10022.pdf",
        description: "Document from the 2025 JFK Records Release"
      },
      %{
        title: "JFK Document 104-10014-10051",
        url: "https://www.archives.gov/files/research/jfk/releases/2025/0318/104-10014-10051.pdf",
        description: "Document from the 2025 JFK Records Release"
      }
    ]
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
