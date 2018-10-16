class ProjPlantIdCli::Cli 

    def self.run
        get_info
        main_menu
    end

    BASE_URL = "http://www.foragingguide.com/mushrooms/articles/general/your_first_10_wild_mushrooms"
    

    # def run < DONE
    # make plants < DONE 
    # add_attributes_to_plants < DONE
    # display_plants << NEED TO IMPROVE THIS, USE COLORIZE TO MAKE IT PRETTY
    # sort methods << MAY WANT TO ADD THIS
    # end

    def self.get_info
        plants_array = ProjPlantIdCli::Scraper.scrape_index_page(BASE_URL)
        ProjPlantIdCli::Plant.create_from_collection(plants_array)
        add_attributes_to_plants
    end

    def self.add_attributes_to_plants
        ProjPlantIdCli::Plant.all.each do |plant|
            attributes = ProjPlantIdCli::Scraper.scrape_profile_page(plant.link)
            plant.add_plant_attributes(attributes)
        end
    end

    def self.main_menu
        print_main_menu
        input = ""
        while input != "exit" 
            print "\n\nWhat would you like to do? \nTo see the options, type 'menu'.\n->"
            input = gets.chomp
            if input == "read intro"
                print_intro
            elsif input == "list"
                list_all 
            elsif input == "menu"
                print_main_menu
            elsif input == "select"
                plant = select_plant
                print_description(plant)
            elsif input == "link"
                link_plant
            end
        end
    end

    def self.print_main_menu
        puts " \n\n-----------MAIN MENU-----------"
        puts " \n \nWelcome to the Mushroom Foraging Database!"
        puts "To read the intro, type 'read intro'."
        puts "To list all of the mushroom foraging info, type 'list'."
        puts "To get a description of a specific mushroom, type 'select'."
        puts "To get a link to images of a specific mushroom, type 'link'."        
        puts "To quit, type 'exit'."
    end

    #------------------------------
    #------------------------------
    #------------------------------
    #------------------------------
    
    def self.print_intro      
        puts " \n --- #{ProjPlantIdCli::Scraper.introtext}"
        list_all_plant_names
    end

    def self.list_all
        ProjPlantIdCli::Plant.all.each{ |plant|
            puts "------------------------------------\n------------------------------------\n\n"
            print_description(plant)
            puts "------------------------------------\n------------------------------------\n\n"
        }   
    end

    def self.list_all_plant_names
        puts "\n"
        ProjPlantIdCli::Plant.all.each.with_index{ |plant, i|
            puts "#{i+1}. #{plant.common_name}"
        }
    end

    def self.select_plant
        list_all_plant_names
        num = 0
        found = false
        plant = nil
        
        while !found  
            puts "\nPlease type the number of the plant you'd like to select: \n"
            num = gets.chomp.to_i
            plant = ProjPlantIdCli::Plant.all[num-1]
            found = true if plant.class == ProjPlantIdCli::Plant
        end
        plant
    end

    def self.print_description(plant)
        plant.class.expectedInfoTypes.each {|infoType|
            if plant.send("#{infoType}")         
                puts " -- #{infoType.upcase.to_s.split("_").join(" ")}"
                puts " ---- #{plant.send("#{infoType}")}\n\n"
            end
        }

    end

    def self.link_plant
        plant = select_plant
        puts plant.link
    end

    # def self.search_plant
    #     list_all_plant_names
    #     puts "\nPlease type the name of the plant you'd like to search: \n"
    #     name = gets.chomp
    #     nameA = name.split(" ")
    #     print "https://www.google.com/search?q="
    #     nameA.each {|word| 
    #         print "#{word}"
    #         print "+" if word != nameA[-1]
    #     }
    #     puts ""
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