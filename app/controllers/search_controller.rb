class SearchController < ApplicationController

  def create
    if search_present?
      format_search
      Search.get_html_docs(@city, @state)
      scrape_for_jobs
    end
  end

  private

  def search_present?
    params[:city].present? || params[:state].present?
  end

  def format_search
    @city  = params[:city].gsub(/\s{1}/, '-')
    @state = params[:state].gsub(/\s{1}/, '-')
  end

  def scrape_for_jobs
    @monster_jobs     = Search.monster_jobs
    @indeed_jobs      = Search.indeed_jobs
    @simplyhired_jobs = Search.simplyhired_jobs
  end
end