# JFK PDF Summarizer

A Phoenix application that downloads and summarizes JFK documents in PDF format using Elixir, Rust, and LangChain.

**[Visit Our Website](https://your-username.github.io/jfk_pdf_summarizer/)**

## Features

- Download PDFs from URLs
- Extract text from PDFs using Rust NIF with the extractous crate
- Summarize text using LangChain and OpenAI's API
- Browse JFK documents from the National Archives

## Prerequisites

- Elixir 1.18+
- Erlang/OTP 27+
- Rust and Cargo
- OpenAI API key

## Setup

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd jfk_pdf_summarizer
   ```

2. Install dependencies:
   ```bash
   mix deps.get
   ```

3. Configure OpenAI API key:
   Edit `config/dev.secret.exs` and add your OpenAI API key:
   ```elixir
   import Config

   # LangChain configuration with OpenAI
   config :langchain,
     openai: [
       api_key: "your_openai_api_key_here"
     ]

   # Set the OpenAI API key as an environment variable
   config :openai,
     api_key: "your_openai_api_key_here"
   ```

4. Compile the project:
   ```bash
   mix compile
   ```

5. Start the Phoenix server:
   ```bash
   mix phx.server
   ```

Now you can visit [`localhost:5000`](http://localhost:5000) from your browser.

## How It Works

1. **Document Acquisition**: The application downloads PDF documents from URLs or allows users to upload their own files.
2. **Text Extraction**: A high-performance Rust NIF extracts text content from PDFs using the extractous crate.
3. **AI Summarization**: The extracted text is processed through LangChain and OpenAI to generate concise, informative summaries.
4. **Presentation**: Results are displayed in a clean, user-friendly interface, with options to view both the original text and the summary.

## Project Structure

- `lib/jfk_pdf_summarizer/pdf_processor.ex` - Core logic for downloading, extracting, and summarizing PDFs
- `lib/jfk_pdf_summarizer/pdf_extractor.ex` - Elixir interface to the Rust NIF
- `native/pdf_extractor/` - Rust implementation of the PDF extraction functionality
- `lib/jfk_pdf_summarizer/jfk_documents.ex` - Module for handling JFK document collection
- `lib/jfk_pdf_summarizer_web/` - Phoenix web interface

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## GitHub Pages

This project includes a GitHub Pages site in the `docs/` directory. To view it locally:

1. Install Jekyll and Bundler:
   ```bash
   gem install jekyll bundler
   ```

2. Navigate to the docs directory:
   ```bash
   cd docs
   ```

3. Install dependencies:
   ```bash
   bundle install
   ```

4. Start the local server:
   ```bash
   bundle exec jekyll serve
   ```

5. Visit `http://localhost:4000` in your browser.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- National Archives for providing access to JFK assassination records
- Phoenix Framework for the web interface
- LangChain and OpenAI for AI summarization capabilities
- Extractous and Rustler for PDF text extraction
