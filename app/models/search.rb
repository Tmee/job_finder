class Search < ActiveRecord::Base

  def self.get_html_docs(city, state = '')
    @monster_doc = Nokogiri::HTML(open("http://jobsearch.monster.com/search/ruby_5?where=#{city}__2C-#{state}"))
    @indeed_doc  = Nokogiri::HTML(open("http://www.indeed.com/jobs?q=ruby&l=#{city}%2C+#{state}"))
    if city.empty?
      begin
        @simply_doc  = Nokogiri::HTML(open("http://www.simplyhired.com/search?q=ruby&l=#{state}"))
        rescue OpenURI::HTTPError
      end
    else
      begin
        @simply_doc  = Nokogiri::HTML(open("http://www.simplyhired.com/search?q=ruby&l=#{city}%2C+#{state}"))
        rescue OpenURI::HTTPError
      end
    end
  end

  def self.monster_jobs
    rows = @monster_doc.xpath("//div[contains(@class, 'leftContainer')]//div[contains(@id, 'primaryResults')]//table//tr[position() > 1]//td[position() = 2]//div[contains(@class, 'jobTitleContainer')]//a")
    collect_data(rows)
  end

  def self.indeed_jobs
    rows = @indeed_doc.xpath("//table//tr//td//table//tr//td[contains(@id ,'resultsCol')]//div[contains(@class, 'row  result')]//h2//a")
    collect_data(rows, "www.indeed.com")
  end

  def self.simplyhired_jobs
    if @simply_doc.present?
      rows = @simply_doc.xpath("//div[contains(@id, 'content')]//div[contains(@id, 'search_results')]//div[contains(@class, 'column_center_inner')]//div[contains(@class, 'results')]//ul//li//div[position() = 1]//h2//a")
      collect_data(rows, "www.simplyhired.com")
    end
  end

  def self.collect_data(rows, url = nil)
    jobs_array = []
    rows.collect do |row|
      detail = {}
      detail[:title] = row.text.gsub(/\s{3}/, '')
      detail[:link]  = "#{url}#{row.attribute('href').value}"
      jobs_array << detail
      end
    jobs_array
  end
  private

end