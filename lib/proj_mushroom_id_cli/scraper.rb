require 'open-uri'
require 'nokogiri' ##standard to include both of these in order to do this scraping
require 'pry'

#------------------

#built to scrape:
#       http://www.foragingguide.com/mushrooms/in_season
#
# and then:
#       each of the mushroom profile pages that that page links to
#

#
#------------------

class ProjMushroomIdCli::Scraper

    @@introtext = "Please exercise extreme caution when foraging mushrooms. \nAlways forage with an experienced guide. \nDo not consume anything unless you are 1000% sure what you are eating."
    
    def self.introtext
        @@introtext
    end

    def self.introtext=(introtextFromDoc)
        @@introtext = introtextFromDoc
        
    end

    # scrapes the 'in season' page, getting mushroom names and profile page URLs
    def self.scrape_index_page(index_url)

        doc = Nokogiri::HTML(open(index_url))

        mushrooms_array = []        

        mushroomNokoEl_arr = doc.css(".info")
        
        mushroomNokoEl_arr.each.with_index do |mushroom, i|
            mushrooms_array << {common_name: mushroom.css(".name")[0].text, link: "http://www.foragingguide.com" + "#{mushroom.css("a").attr("href").value}"}
        end

        mushrooms_array
    end

    
    #scrapes the mushrooms' profile page for foraging data
    def self.scrape_profile_page(profile_url)
        
        doc = Nokogiri::HTML(open(profile_url))            

        profile_hash = {
            latin_name: doc.css("title").text.split(" - ")[1]
        }
        doc.css(".sp_items p").drop(2).each do |nokoEl|            
            profile_hash[parse_key(nokoEl).to_sym] = nokoEl.css(".info").text.gsub(":", "").strip
        end
        profile_hash
        
    end

    #called by #self.scrape_profile_page(profile_url), 
    #     reads what will become keys in that method's profile_hash
    def self.parse_key(nokoEl)
        nokoEl.css(".label").text.gsub(":", "").strip.downcase.split(" ").join("_")
    end
end