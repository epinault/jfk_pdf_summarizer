defmodule JfkPdfSummarizerWeb.PdfController do
  use JfkPdfSummarizerWeb, :controller
  
  alias JfkPdfSummarizer.PdfProcessor
  alias JfkPdfSummarizer.JfkDocuments
  
  def index(conn, _params) do
    render(conn, :index)
  end
  
  def summarize_url(conn, %{"url" => url}) do
    case PdfProcessor.process_pdf(url) do
      {:ok, %{summary: summary, text: text}} ->
        conn
        |> put_flash(:info, "PDF processed successfully!")
        |> render(:summary, url: url, summary: summary, text: text)
      
      {:error, reason} ->
        conn
        |> put_flash(:error, "Error processing PDF: #{reason}")
        |> render(:index)
    end
  end
  
  def summarize_upload(conn, %{"pdf" => %Plug.Upload{path: path, filename: filename}}) do
    case PdfProcessor.extract_text(path) do
      {:ok, text} ->
        case PdfProcessor.summarize_text(text) do
          {:ok, summary} ->
            conn
            |> put_flash(:info, "PDF processed successfully!")
            |> render(:summary, url: filename, summary: summary, text: text)
            
          {:error, reason} ->
            conn
            |> put_flash(:error, "Error summarizing PDF: #{reason}")
            |> render(:index)
        end
        
      {:error, reason} ->
        conn
        |> put_flash(:error, "Error extracting text from PDF: #{reason}")
        |> render(:index)
    end
  end
  
  def jfk_documents(conn, _params) do
    # Get the JFK documents from our module
    documents = JfkDocuments.list_documents()
    
    render(conn, :jfk_documents, documents: documents)
  end
end
