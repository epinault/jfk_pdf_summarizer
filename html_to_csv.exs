#!/usr/bin/env elixir

defmodule HtmlToCsv do
  @input_file "links.html"
  @output_file "jfk_links.csv"
  @base_url "https://www.archives.gov"

  def convert do
    # Read the HTML file
    html_content = File.read!(@input_file)

    # Extract all links using regex
    pattern = ~r/<td><a href="([^"]+)" target="_blank">([^<]+)<\/a><\/td>/
    matches = Regex.scan(pattern, html_content)

    # Prepare CSV data
    csv_data =
      matches
      |> Enum.map(fn [_full_match, href, filename] ->
        full_url = @base_url <> href
        [filename, full_url]
      end)

    # Add header
    csv_data = [["Filename", "URL"] | csv_data]

    # Write to CSV
    csv_content =
      csv_data
      |> Enum.map(&Enum.join(&1, ","))
      |> Enum.join("\n")

    # Write to file
    File.write!(@output_file, csv_content)

    IO.puts("Conversion complete! #{length(matches)} links extracted to #{@output_file}")
  end
end

HtmlToCsv.convert()
