class ProjMushroomIdCli::Cli 

    def self.run  ### HERE YOU FIND OUR MAIN PROCESS - FIRST WE GET THE INFO, THEN WE CYCLE THE MAIN MENU
        puts "Retrieving your mushroom info, one moment please...".colorize(:magenta)
        get_info
        main_menu
    end

    #old BASE_URL = "http://www.foragingguide.com/mushrooms/articles/general/your_first_10_wild_mushrooms"
    BASE_URL = "http://www.foragingguide.com/mushrooms/in_season"
    

    #This Mushroom Foraging CLI can:
    # use the Scraper class to scrape our Base URL and make instances of the Mushroom class with names and profile page URLs
    # retrieve attributes of these mushrooms through the mushroom profile pages
    # display mushroom info << note on colorize gem:(possible colors: black, red, green, yellow, blue, magenta, cyan, white, plus all those things with 'light_')




    def self.get_info
        mushrooms_array = ProjMushroomIdCli::Scraper.scrape_index_page(BASE_URL) 
            #^^^gets an array of mushroom hashes which contain the common name and the link to the profile page

        ProjMushroomIdCli::Mushroom.create_from_collection(mushrooms_array)
            #^^^creates instances of mushroom class that include common name and profile page link

        add_attributes_to_mushrooms
            #^^^scrapes the mushrooms' profile pages, adding all the details into instances of Mushroom class

    end
    
    
    #add_attributes_to_mushrooms
        #calles Scraper's scrape_profile_page, 
        # stores attributes from that mushroom's profile page, 
        # adding all the details into instances of Mushroom class
    def self.add_attributes_to_mushrooms
        ProjMushroomIdCli::Mushroom.all.each do |mushroom|
            attributes_hash = ProjMushroomIdCli::Scraper.scrape_profile_page(mushroom.link)
            mushroom.add_mushroom_attributes(attributes_hash)
        end
    end

    # ------------
    # ------------
    # ------------ MENU METHODS
    # ------------
    # ------------

    #main_menu
        #cycles thru our main menu and gets user input, calls appropriate methods according to input
    def self.main_menu
        input = ""
        while input != "exit" 
            print_main_menu
            print "-> ".colorize(:blue)               
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

    #print_main_menu
        #prints out our menu for the user
    def self.print_main_menu
        puts " \n--THE MUSHROOM FORAGING DATABASE--".colorize(:magenta)
        puts " \n-----------MAIN MENU-----------".colorize(:blue)
        puts "To read an intro, type 'read intro'.".colorize(:blue)
        puts "To read all of the mushroom foraging info, type 'all'.".colorize(:blue)
        puts "To get a description of a specific mushroom, type 'select'.".colorize(:blue)
        puts "To get a link to images of a specific mushroom, type 'link'.".colorize(:blue)
        puts "To quit, type 'exit'.".colorize(:blue)
    end


    # ------------
    # ------------ 
    # ------------ PRINTING INFO METHODS
    # ------------
    # ------------


    

    #print_intro
        #prints out the custom intro message that we set in our scraper
        #called by main_menu
    def self.print_intro      
        puts " \n#{ProjMushroomIdCli::Scraper.introtext}".colorize(:red)
    end


    #list_all
        #prints the descriptions of every mushroom instance in Mushroom.all
        #called by main_menu
    def self.list_all
        ProjMushroomIdCli::Mushroom.all.each{ |mushroom|
            puts "------------------------------------\n------------------------------------\n\n".colorize(:blue)
            print_description(mushroom)
            puts "------------------------------------\n------------------------------------\n\n".colorize(:blue)
        }   
    end


    #list_all_mushroom_names
        #prints a numbered list of mushroom names, using the range inputted by user
        #called by select_mushroom
    def self.list_all_mushroom_names
        found = false 

        while !found  
            found = false
            input, start, fin = nil
            puts "\n Please enter the range of mushrooms you would like to display. Total range is 1-#{ProjMushroomIdCli::Mushroom.all.count}. ex: '1-10'\n".colorize(:blue)
            puts "\n Or you can type 'menu' to return to the main menu.\n".colorize(:blue)
            print "-> ".colorize(:blue)
            input = gets.chomp
            return 'exiting' if input == 'menu'
            input = input.split("-")
            start = input[0].to_i
            fin = input[1].to_i
            if start > 0 && start <= ProjMushroomIdCli::Mushroom.all.count && fin >= start && fin <= ProjMushroomIdCli::Mushroom.all.count
                for i in start..fin do
                    puts "#{i}. #{ProjMushroomIdCli::Mushroom.all[i-1].common_name}".colorize(:blue)
                    found = true
                end
            else 
                puts "\n\n\n\n\n ---I'm sorry! I didn't get that. Please enter a valid range. \n".colorize(:red)
            end
            # ProjMushroomIdCli::Mushroom.all.each.with_index{ |mushroom, i|
            #     puts "#{i+1}. #{mushroom.common_name}".colorize(:blue)
            # }
        end
        return 'all clear'
    end

    
    #print_description(mushroom)
    #takes in instance of mushroom class, prints all available description info
    #called by main_menu and list_all
    def self.print_description(mushroom)
        mushroom.class.expectedInfoTypes.each {|infoType|
            if mushroom.send("#{infoType}")         
                puts " -- #{infoType.upcase.to_s.split("_").join(" ")}".colorize(:blue)
                puts " ---- #{mushroom.send("#{infoType}")}\n\n"
            end
        }
        
    end

    #link_mushroom
    #prints the link to the mushroom's profile page, so user can see pictures
    #called by main_menu
    def self.link_mushroom
        mushroom = select_mushroom
        puts mushroom.link if mushroom.class == ProjMushroomIdCli::Mushroom
    end
    
    # ------------
    # ------------
    # ------------ SELECT MUSHROOM METHOD
    # ------------
    # ------------
    
    
    #select_mushroom
    #allows user to select a mushroom after a numbered list has been printed
    #called by main_menu, link_mushroom
    def self.select_mushroom
        firstTime = true
        mushroom = nil
        found = false
        exiting = nil #helps handle if the user wants to exit from the "list_all_mushroom_names" method
        
        
        while !found  
            found = false
            num = nil
            puts "\n\n\n\n\n ---I'm sorry! I didn't get that. Please enter one of the numbers of an available mushroom. \n".colorize(:red) if !firstTime && exiting != 'exiting'
            exiting = list_all_mushroom_names
            return if exiting == 'exiting'
            puts "\nPlease type the number of the mushroom you'd like to select. \nOr you can type 'menu' to return to the main menu.\n".colorize(:blue)
            print "-> ".colorize(:blue)
            num = gets.chomp
            return if num == 'menu'
            num = num.to_i
            if num > 0 && num <= ProjMushroomIdCli::Mushroom.all.count 
                mushroom = ProjMushroomIdCli::Mushroom.all[num-1]
                binding.pry
                found = true if mushroom.class == ProjMushroomIdCli::Mushroom
            end
            firstTime = false
            
        end
        mushroom
    end
end