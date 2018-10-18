class ProjMushroomIdCli::Cli 

    def self.run  ### HERE YOU FIND OUR MAIN PROCESS - FIRST WE GET THE INFO, THEN WE CYCLE THE MAIN MENU
        puts "Retrieving your mushroom info, one moment please...".colorize(:magenta)
        get_info
        main_menu
    end

    #BASE_URL = "http://www.foragingguide.com/mushrooms/articles/general/your_first_10_wild_mushrooms"
    BASE_URL = "http://www.foragingguide.com/mushrooms/in_season"
    

    #This Mushroom Foraging CLI can:
    # use the Scraper class to scrape our Base URL and make instances of the Mushroom class with names and profile page URLs
    # retrieve attributes of these mushrooms through the mushroom profile pages
    # display mushroom info << note on colorize gem:(possible colors: black, red, green, yellow, blue, magenta, cyan, white, plus all those things with 'light_')

    def self.get_info
        mushrooms_array = ProjMushroomIdCli::Scraper.scrape_index_page(BASE_URL)
        ProjMushroomIdCli::Mushroom.create_from_collection(mushrooms_array)
        add_attributes_to_mushrooms
    end

    def self.add_attributes_to_mushrooms
        ProjMushroomIdCli::Mushroom.all.each do |mushroom|
            attributes = ProjMushroomIdCli::Scraper.scrape_profile_page(mushroom.link)
            mushroom.add_mushroom_attributes(attributes)
        end
    end

    def self.main_menu
        input = ""
        while input != "exit" 
            print_main_menu                  
            input = gets.chomp.downcase
            case input
                when "read intro"
                    print_intro
                when "all"
                    list_all 
                when "menu"
                    print_main_menu
                when "select"
                    mushroom = select_mushroom
                    if mushroom.class == ProjMushroomIdCli::Mushroom
                        puts "\n\n Here is your selection: \n -------------".colorize(:magenta)
                        print_description(mushroom)
                        puts "See your requested info above.".colorize(:magenta)
                    end
                when "link"
                    link_mushroom
                else
                    if input != "exit"
                        puts "\n\n\nI'm sorry! You entered an invalid input. Please be mindful of the menu selection options.\n\n".colorize(:red)
                    end
            end
        end
    end

    def self.print_main_menu
        puts " \n--THE MUSHROOM FORAGING DATABASE--".colorize(:magenta)
        puts " \n-----------MAIN MENU-----------".colorize(:blue)
        puts "To read an intro, type 'read intro'.".colorize(:blue)
        puts "To read all of the mushroom foraging info, type 'all'.".colorize(:blue)
        puts "To get a description of a specific mushroom, type 'select'.".colorize(:blue)
        puts "To get a link to images of a specific mushroom, type 'link'.".colorize(:blue)
        puts "To quit, type 'exit'.".colorize(:blue)
    end

    #------------------------------
    #------------------------------
    #------------------------------
    #------------------------------
    
    def self.print_intro      
        puts " \n#{ProjMushroomIdCli::Scraper.introtext}".colorize(:red)
    end

    def self.list_all
        ProjMushroomIdCli::Mushroom.all.each{ |mushroom|
            puts "------------------------------------\n------------------------------------\n\n".colorize(:blue)
            print_description(mushroom)
            puts "------------------------------------\n------------------------------------\n\n".colorize(:blue)
        }   
    end

    def self.list_all_mushroom_names
        puts "\n"
        ProjMushroomIdCli::Mushroom.all.each.with_index{ |mushroom, i|
            puts "#{i+1}. #{mushroom.common_name}".colorize(:blue)
        }
    end

    
    def self.select_mushroom
        firstTime = true
        mushroom = nil
        found = false
        
        while !found  
            found = false
            num = nil
            puts "\n\n\n\n\n ---I'm sorry! I didn't get that. Please enter one of the numbers of an available mushroom. \n".colorize(:red) if !firstTime
            list_all_mushroom_names
            puts "\nPlease type the number of the mushroom you'd like to select. \nOr you can type 'menu' to return to the main menu.\n".colorize(:blue)
            num = gets.chomp
            return if num == 'menu'
            num = num.to_i
            if num > 0 && num <= ProjMushroomIdCli::Mushroom.all.count 
                mushroom = ProjMushroomIdCli::Mushroom.all[num-1]
                found = true if mushroom.class == ProjMushroomIdCli::Mushroom
            end
            firstTime = false
        end
        mushroom
    end

    def self.print_description(mushroom)
        mushroom.class.expectedInfoTypes.each {|infoType|
            if mushroom.send("#{infoType}")         
                puts " -- #{infoType.upcase.to_s.split("_").join(" ")}".colorize(:blue)
                puts " ---- #{mushroom.send("#{infoType}")}\n\n"
            end
        }

    end

    def self.link_mushroom
        mushroom = select_mushroom
        puts mushroom.link if mushroom.class == ProjMushroomIdCli::Mushroom
    end
end