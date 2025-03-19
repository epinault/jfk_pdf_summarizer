# JFK PDF Summarizer - GitHub Pages

This directory contains the GitHub Pages website for the JFK PDF Summarizer project.

## Development

To test the GitHub Pages site locally:

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

## Deployment

The site is automatically deployed to GitHub Pages when changes are pushed to the main branch.

## Structure

- `index.html`: Main landing page
- `styles.css`: Additional CSS styles
- `_config.yml`: Jekyll configuration
- `assets/`: Directory for images and other assets
