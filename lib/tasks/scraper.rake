namespace :scraper do
  desc "Fetch and save a random Rails guide"
  task fetch_guide: :environment do
    puts "Starting Rails guide scraper..."

    begin
      scraper = RailsGuideScraper.new
      result = scraper.call

      if result.nil?
        puts "No guides were found to scrape."
      end
    rescue StandardError => e
      puts "Error occurred while scraping: #{e.message}"
      puts e.backtrace.take(5)
    end

    puts "Scraping completed! There are now #{Article.count} articles in the database."
  end
end
