require 'open-uri'
require 'nokogiri' ##standard to include both of these in order to do this scraping
require 'pry'

#------------------
#originally built to scrape:
#       http://www.foragingguide.com/mushrooms/articles/general/your_first_10_wild_mushrooms
#
# and then:
#       each of the mushroom profile pages that that page links to
#

#
#
#
#
# ATTENTION ATTENTION ATTENTION !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# ATTENTION ATTENTION ATTENTION !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# ATTENTION ATTENTION ATTENTION !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#working to refactor to scrape the 'in season' mushrooms:
#       http://www.foragingguide.com/mushrooms/in_season
#------------------

class ProjMushroomIdCli::Scraper

    @@introtext
    
    def self.introtext
        @@introtext
    end

    def self.introtext=(introtextFromDoc)
        @@introtext = introtextFromDoc
        
    end

    def self.scrape_index_page(index_url)

        doc = Nokogiri::HTML(open(index_url))

        
        # @@introtext = (doc.css(".article p").text.split("»")[1].split(".").join(". ") + ".")
        # originally introtext read from the '10 most common' webpage. 
        #Now that we're scraping the 'in season' page, introtext will be set to a custom intro.
        @@introtext = "Please excercise extreme caution when foraging mushrooms. \nAlways forage with an experienced guide. \nDo not consume anything unless you are 1000% sure what you are eating."

        mushrooms_array = []
        
        doc.css("li").each.with_index do |mushroom, i|
            mushrooms_array << {common_name: doc.css("li")[i].text, link: "http://www.foragingguide.com" + "#{doc.css("li a")[i].attr("href")}"}
        end
        
        mushrooms_array
    end

    

    def self.scrape_profile_page(profile_url)
        
        doc = Nokogiri::HTML(open(profile_url))            

        profile_hash = {
            latin_name: doc.css("title").text.split(" - ")[1]
        }
        
        doc.css(".sp_items p").drop(2).each do |nokoEl|
            profile_hash[parse_key(nokoEl)] = nokoEl.children[1].text.gsub(":", "").strip
        end
        profile_hash
        
    end

    def self.parse_key(nokoEl)
        nokoEl.children[0].text.gsub(":", "").strip.downcase.split(" ").join("_")
    end
end