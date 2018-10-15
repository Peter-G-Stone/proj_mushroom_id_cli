require 'open-uri'
require 'nokogiri' ##standard to include both of these in order to do this scraping
require 'pry'


class Scraper

    @@introtext
    
    def self.introtext
        @@introtext
    end

    def self.introtext=(introtextFromDoc)
        @@introtext = introtextFromDoc
    end

    def self.scrape_index_page(index_url)


        doc = Nokogiri::HTML(open(index_url))

        
        @@introtext = doc.css(".entry p")[0].text + " " + doc.css(".entry p")[1].text + " " + doc.css(".entry p")[2].text

        plants_array = []

        titleCounter = 0
        for i in 4...24
            if i.even?
                plants_array << {name: doc.css(".entry h2")[titleCounter].text, description: doc.css(".entry p")[i].text}
                titleCounter += 1
            end
        end

        plants_array
    end

    #

#   def self.scrape_profile_page(profile_url)
#     doc = Nokogiri::HTML(open(profile_url))    
#     profile_hash = {
#       bio: doc.css(".description-holder p").text,
#       profile_quote: doc.css(".profile-quote").text
#     }       
   
#     social_array = doc.css(".social-icon-container a")
#     self.parse_socials(profile_hash, social_array)
#   end

#   def self.parse_socials(profile_hash, social_array)
#     social_array.each do |noko_el|
#       link = noko_el.attr("href")
#       if link.include?("twitter")
#         profile_hash[:twitter] = link
#       elsif link.include?("facebook")
#         profile_hash[:facebook] = link
#       elsif link.include?("github")
#         profile_hash[:github] = link
#       elsif link.include?("linkedin")
#         profile_hash[:linkedin] = link
#       else
#         profile_hash[:blog] = link
#       end 
#     end
#     profile_hash
#   end

end