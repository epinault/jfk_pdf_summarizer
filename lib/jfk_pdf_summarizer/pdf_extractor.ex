defmodule JfkPdfSummarizer.PdfExtractor do
  use Rustler, otp_app: :jfk_pdf_summarizer, crate: "pdf_extractor"

  # When your NIF is loaded, it will override these functions
  @spec extract_pdf(binary()) :: {:ok, binary()} | {:error, binary()}
  def extract_pdf(_pdf_path), do: :erlang.nif_error(:nif_not_loaded)
end
