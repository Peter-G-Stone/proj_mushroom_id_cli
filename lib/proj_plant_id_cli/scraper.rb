require 'open-uri'
require 'nokogiri' ##standard to include both of these in order to do this scraping
require 'pry'


#built to scrape:

#       http://www.foragingguide.com/mushrooms/articles/general/your_first_10_wild_mushrooms
#
# and then:
#
#       each of the mushroom profile pages that that page links to
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

        
        @@introtext = doc.css(".article p").text.split("»")[1]
        
        plants_array = []
        
        doc.css("li").each.with_index do |plant, i|
            plants_array << {name: doc.css("li")[i].text, link: "http://www.foragingguide.com" + "#{doc.css("li a")[i].attr("href")}"}
        end
        
        plants_array
    end

    

    def self.scrape_profile_page(profile_url)
        doc = Nokogiri::HTML(open(profile_url))    
        profile_hash = {
            bio: doc.css(".description-holder p").text,
            profile_quote: doc.css(".profile-quote").text
        }       

        social_array = doc.css(".social-icon-container a")
        # self.parse_socials(profile_hash, social_array)
    end

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
#   end#   def self.scrape_profile_page(profile_url)
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