use rustler::NifResult;
use std::fs::File;
use std::io::Read;
use extractous::Extractor;

#[rustler::nif(schedule = "DirtyCpu")]
fn extract_pdf(pdf_path: String) -> Result<String, String> {
    // Create a new extractor
    let extractor = Extractor::new();
    
    // Extract text from the PDF file
    match extractor.extract_file_to_string(&pdf_path) {
        Ok((content, _metadata)) => Ok(content),
        Err(e) => Err(format!("Failed to extract text from PDF: {}", e)),
    }
}

rustler::init!("Elixir.JfkPdfSummarizer.PdfExtractor", [extract_pdf]);