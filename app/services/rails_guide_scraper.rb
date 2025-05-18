# app/services/rails_guide_scraper.rb
require "faraday"
require "nokogiri"

class RailsGuideScraper
  BASE_URL = "https://guides.rubyonrails.org"

  def initialize(test_mode: false)
    @test_mode = test_mode
  end

  def call
    guide_links = extract_guide_links
    puts "Found #{guide_links.size} guides to scrape."
    return if guide_links.empty?
    guide_links.each do |guide_url|
      fetch_guide_content(guide_url)
    end
  end

  private

  def extract_guide_links
    html = fetch("#{BASE_URL}/index.html")
    doc = Nokogiri::HTML(html)

    doc.css("#article-body .guide-index-list a").map do |link|
      href = link["href"]
      next if href.nil? || href.empty?
      full_url = href.start_with?("http") ? href : "#{BASE_URL}/#{href}"
      full_url
    end.compact
  end

  def fetch_guide_content(url)
    html = fetch(url)
    doc = Nokogiri::HTML(html)

    guide_title = doc.at_css("h1")&.text&.strip
    article_body = doc.at_css("#article-body")

    chapters = article_body.css("h2")

    chapters.each_with_index do |chapter, index|
      next_chapter = chapters[index + 1]
      chapter_content = extract_chapter_content(chapter, next_chapter)

      chapter_data = {
        title: "#{guide_title} - #{chapter.text.strip}",
        content: chapter_content,
        url: "#{url}##{chapter['id']}",
        topic: guide_title,
        subtopic: chapter.text.strip
      }
      save_to_article(chapter_data)
    end
  end

  def extract_chapter_content(current_chapter, next_chapter)
    current_node = current_chapter
    content = []

    while (current_node = current_node.next_element) && current_node != next_chapter
      content << current_node.to_html
    end

    content.join("\n")
  end

  def save_to_article(chapter_data)
   article = Article.new(
    title: chapter_data[:title],
    content: chapter_data[:content],
    url: chapter_data[:url],
    topic: chapter_data[:topic],
    subtopic: chapter_data[:subtopic]
  )

    if article.save
      puts "Article saved: #{article.title}"
    else
      puts "Failed to save article: #{article.errors.full_messages.join(", ")}"
    end
  end

  def fetch(url)
    if @test_mode
      File.read(Rails.root.join("tmp/sample_rails_page.html"))
    else
      Faraday.get(url).body
    end
  end
end
