class Cli 

    require_relative "scraper.rb"
    require_relative "plant.rb"
    require 'nokogiri'
    # require 'colorize'
    


    def self.run
        get_info
        main_menu
    end


    BASE_URL = "http://popularpittsburgh.com/ten-common-trees-found-neck-woods/"

    # def run < DONE
    # make plants < DONE 
    # add_attributes_to_plants < NEED TO REFACTOR TO SCRAPE DIFFERENT SITE TO GET MORE INFO
    # display_plants << NEED TO ADD THIS ONCE I GET MORE INFO, USE COLORIZE TO MAKE IT PRETTY
    # end

    def self.get_info
        plants_array = Scraper.scrape_index_page(BASE_URL)
        Plant.create_from_collection(plants_array)
    end

    # def add_attributes_to_students
    # Student.all.each do |student|
    #     attributes = Scraper.scrape_profile_page(BASE_PATH + student.profile_url)
    #     student.add_student_attributes(attributes)
    # end
    # end

    def self.main_menu
        print_main_menu
        input = ""
        while !input.include?("exit")
            print "\n\nWhat would you like to do? \nTo see the options, type 'menu'.\n->"
            input = gets.chomp
            if input == "read intro"
                print_intro
            elsif input == "list"
                list_all 
            elsif input == "menu"
                print_main_menu
            elsif input == "select"
                select_plant
            elsif input == "search"
                search_plant
            end
        end
    end

    def self.print_main_menu
        puts " \n\n-----------MAIN MENU-----------"
        puts " \n \nWelcome to your Pittsburgh tree Database!"
        puts "To read the intro, type 'read intro'."
        puts "To list all of the plant info, type 'list'."
        puts "To get a description of a specific plant, type 'select'."
        puts "To get a google search of a specific plant, type 'search'."        
        puts "To quit, type 'exit'."
    end

    #------------------------------
    #------------------------------
    #------------------------------
    #------------------------------
    
    def self.print_intro      
        puts " \n --- #{Scraper.introtext}"
        list_all_plant_names
    end

    def self.list_all
        Plant.all.each{ |plant|
            puts "\n #{plant.name} \n"
            puts " ---- #{plant.description}"
        }   
    end

    def self.list_all_plant_names
        puts "\n"
        Plant.all.each{ |plant|
            puts "#{plant.name}"
        }
    end

    def self.select_plant
        list_all_plant_names
        name = ""
        found = false
        plant = nil
        
        while !found  
            puts "\nPlease type the name of the plant you'd like to select: \n"
            name = gets.chomp
            plant = Plant.find_by_name(name)
            found = true if plant
        end
        puts "\n ---- #{Plant.find_by_name(name).description} \n"
        ##### still doesn't handle names that aren't in the system
    end

    def self.search_plant
        list_all_plant_names
        puts "\nPlease type the name of the plant you'd like to search: \n"
        name = gets.chomp
        nameA = name.split(" ")
        print "https://www.google.com/search?q="
        nameA.each {|word| 
            print "#{word}"
            print "+" if word != nameA[-1]
        }
        puts ""
    end


    # def display_students
    # Student.all.each do |student|
    #     puts "#{student.name.upcase}".colorize(:blue)
    #     puts "  location:".colorize(:light_blue) + " #{student.location}"
    #     puts "  profile quote:".colorize(:light_blue) + " #{student.profile_quote}"
    #     puts "  bio:".colorize(:light_blue) + " #{student.bio}"
    #     puts "  twitter:".colorize(:light_blue) + " #{student.twitter}"
    #     puts "  linkedin:".colorize(:light_blue) + " #{student.linkedin}"
    #     puts "  github:".colorize(:light_blue) + " #{student.github}"
    #     puts "  blog:".colorize(:light_blue) + " #{student.blog}"
    #     puts "----------------------".colorize(:green)
    # end
    # end

end