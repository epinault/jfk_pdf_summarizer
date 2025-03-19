defmodule JfkPdfSummarizer.PdfProcessor do
  alias JfkPdfSummarizer.PdfExtractor
  alias LangChain.Chains.LLMChain
  alias LangChain.ChatModels.ChatOpenAI
  alias LangChain.Message
  
  @doc """
  Downloads a PDF from a URL and returns the path to the downloaded file.
  """
  @spec download_pdf(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def download_pdf(url) do
    # Create a temporary file to store the PDF
    {:ok, temp_path} = Temp.path(%{suffix: ".pdf"})
    
    # Download the PDF
    case Req.get(url, into: File.stream!(temp_path)) do
      {:ok, %{status: 200}} ->
        {:ok, temp_path}
      {:ok, %{status: status}} ->
        {:error, "Failed to download PDF: HTTP status #{status}"}
      {:error, reason} ->
        {:error, "Failed to download PDF: #{inspect(reason)}"}
    end
  end
  
  @doc """
  Extracts text from a PDF file.
  """
  @spec extract_text(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def extract_text(pdf_path) do
    PdfExtractor.extract_pdf(pdf_path)
  end
  
  @doc """
  Summarizes text using LangChain with OpenAI.
  """
  @spec summarize_text(String.t(), integer()) :: {:ok, String.t()} | {:error, String.t()}
  def summarize_text(text, max_tokens \\ 500) do
    # Truncate text if it's too long (OpenAI has token limits)
    # A rough estimate is that 1 token is about 4 characters
    truncated_text = if String.length(text) > 16000 do
      String.slice(text, 0, 16000) <> "..."
    else
      text
    end
    
    prompt = """
    Summarize the following text from a JFK document release:
    
    #{truncated_text}
    
    Provide a concise summary that captures the key information and historical context.
    """
    
    # Get API key from config
    api_key = Application.get_env(:langchain, :openai)[:api_key]
    
    # Create a new LLMChain with ChatOpenAI model
    chain_result = 
      %{llm: ChatOpenAI.new!(%{
          model: "gpt-3.5-turbo", 
          max_tokens: max_tokens,
          api_key: api_key
        })}
      |> LLMChain.new!()
      |> LLMChain.add_messages([
        Message.new_system!("You are a helpful assistant that summarizes historical documents."),
        Message.new_user!(prompt)
      ])
      |> LLMChain.run()
    
    case chain_result do
      {:ok, updated_chain} ->
        {:ok, updated_chain.last_message.content}
      {:error, reason} ->
        {:error, "Failed to summarize text: #{inspect(reason)}"}
    end
  end
  
  @doc """
  Process a PDF: download, extract text, and summarize.
  """
  @spec process_pdf(String.t()) :: {:ok, map()} | {:error, String.t()}
  def process_pdf(url) do
    with {:ok, pdf_path} <- download_pdf(url),
         {:ok, text} <- extract_text(pdf_path),
         {:ok, summary} <- summarize_text(text) do
      # Clean up the temporary file
      File.rm(pdf_path)
      
      {:ok, %{
        url: url,
        text: text,
        summary: summary
      }}
    else
      {:error, reason} -> {:error, reason}
    end
  end
end
