class Cli 

    require_relative "scraper.rb"
    require_relative "plant.rb"
    require 'nokogiri'
    # require 'colorize'
    

    @@scraper

    def self.run
        get_info
        main_menu
    end

    def self.scraper 
        @@scraper
    end

    def self.scraper=(activeScraper)
        @@scraper = activeScraper
    end


    # BASE_PATH = "./fixtures/student-site/"

    # def run
    # make_students
    # add_attributes_to_students
    # display_students
    # end

    def self.get_info
        plants_array = Scraper.scrape_index_page
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
            elsif input == "list all"
                list_all 
            elsif input == "menu"
                print_main_menu
            elsif input == "select plant"
                select_plant
            end
        end
    end

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
        puts "\nPlease type the name of the plant you'd like to select: \n"
        name = gets.chomp
        puts "\n ---- #{Plant.find_by_name(name).description} \n"
    end

    def self.print_main_menu
        puts " \n\n-----------MAIN MENU-----------"
        puts " \n \nWelcome to your Pittsburgh tree Database!"
        puts "To read the intro, type 'read intro'."
        puts "To list all of the plants' names, type 'list all'."
        puts "To get a description of a specific plant, type 'select plant'."
        puts "To quit, type 'exit'."
    end

    # def self.print_user_prompt
    #     puts "\nWhat would you like to do?"
    #     puts "To see the options, type 'menu'.\n\n"
    # end

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